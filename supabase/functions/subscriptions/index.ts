// Unified Subscriptions Edge Function
// Handles both creation and cancellation of subscriptions
const corsHeaders = {
	"Access-Control-Allow-Origin": "*",
	"Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// @ts-ignore Deno/npm import works in Supabase Edge Functions
import Stripe from "npm:stripe@12.18.0"; 
// @ts-ignore Deno/npm import works in Supabase Edge Functions
import { createClient, SupabaseClient } from "npm:@supabase/supabase-js@2.35.0";

async function getUserEmail(supabaseAdmin: SupabaseClient, userId: string) {
	// Fetch user email from auth.users table
	const { data, error } = await supabaseAdmin
		.from("users")
		.select("email")
		.eq("id", userId)
		.maybeSingle();
	if (error || !data?.email) throw new Error("Could not fetch user email");
	return data.email;
}

// @ts-ignore Deno global is available in Supabase Edge Functions
Deno.serve(async (req: Request) => {
	// Read env vars inside the handler
	// @ts-ignore Deno global is available in Supabase Edge Functions
	const stripeSecret = Deno.env.get("STRIPE_SECRET_KEY");
	// @ts-ignore Deno global is available in Supabase Edge Functions
	const supabaseUrl = Deno.env.get("SUPABASE_URL");
	// @ts-ignore Deno global is available in Supabase Edge Functions
	const supabaseAnon = Deno.env.get("SUPABASE_ANON_KEY");
	// @ts-ignore Deno global is available in Supabase Edge Functions
	const supabaseService = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

	if (req.method === "OPTIONS") {
		return new Response("ok", { headers: corsHeaders });
	}

	if (!stripeSecret || !supabaseUrl || !supabaseAnon || !supabaseService) {
		return new Response(
			JSON.stringify({ error: "Server misconfiguration" }),
			{
				headers: { ...corsHeaders, "Content-Type": "application/json" },
				status: 500,
			}
		);
	}

	if (req.method !== "POST") {
		return new Response(
			JSON.stringify({ error: "Method not allowed" }),
			{ headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 405 }
		);
	}

	const stripe = new Stripe(stripeSecret);
	const supabaseAdmin = createClient(supabaseUrl, supabaseService);

	let body;
	try {
		body = await req.json();
	} catch {
		return new Response(
			JSON.stringify({ error: "Invalid JSON body" }),
			{ headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 }
		);
	}

	const action = body.action;
	if (!action || !["create", "cancel"].includes(action)) {
		return new Response(
			JSON.stringify({ error: "Missing or invalid action" }),
			{ headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 }
		);
	}

	try {
		if (action === "create") {
			// Create subscription checkout session
			const { priceId, userId } = body;
			if (!priceId || !userId) {
				return new Response(
					JSON.stringify({ error: "Missing priceId or userId" }),
					{ headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 }
				);
			}
			const customer_email = await getUserEmail(supabaseAdmin, userId);
			const session = await stripe.checkout.sessions.create({
				customer_email,
				payment_method_types: ["card"],
				line_items: [{ price: priceId, quantity: 1 }],
				mode: "subscription",
				success_url: body.successUrl || "https://your-site.com/success",
				cancel_url: body.cancelUrl || "https://your-site.com/cancel",
				metadata: { user_id: userId },
			});

			// Insert a new row in subscriptions table with status 'active'
			await supabaseAdmin.from("subscriptions").insert({
				user_id: userId,
				status: "active",
				price_id: priceId,
				// quantity, cancel_at_period_end, current_period_start, current_period_end, etc. can be set by webhook after Stripe confirmation
			});

			return new Response(JSON.stringify({ url: session.url }), {
				headers: { ...corsHeaders, "Content-Type": "application/json" },
				status: 200,
			});
		}

		if (action === "cancel") {
			// Cancel subscription logic (from cancel-subscription)
			const authHeader = req.headers.get("Authorization") ?? "";
			const bearerMatch = authHeader.match(/^Bearer\s+(.+)$/i);
			const accessToken = bearerMatch ? bearerMatch[1] : null;
			if (!accessToken) {
				return new Response(
					JSON.stringify({ error: "Invalid user session" }),
					{ headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 401 }
				);
			}

			// Get user info
			const supabaseUserClient = createClient(supabaseUrl, supabaseAnon, {
				global: {
					headers: {
						Authorization: `Bearer ${accessToken}`,
					},
				},
			});
			const { data: authData, error: authError } = await supabaseUserClient.auth.getUser(accessToken);
			if (authError || !authData?.user) {
				return new Response(
					JSON.stringify({ error: "Invalid user session" }),
					{ headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 401 }
				);
			}
			const user = authData.user;

			// Find user's active subscription
			const { data: subscription, error: subError } = await supabaseAdmin
				.from("subscriptions")
				.select("id")
				.eq("user_id", user.id)
				.eq("status", "active")
				.maybeSingle();

			if (subError || !subscription?.id) {
				return new Response(
					JSON.stringify({ error: "Could not find active subscription" }),
					{ headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 }
				);
			}

			// Update subscription status to canceled
			await supabaseAdmin
				.from("subscriptions")
				.update({ status: "canceled", updated_at: new Date().toISOString(), cancel_at_period_end: true })
				.eq("id", subscription.id);

			// Optionally, cancel Stripe subscription if you store the Stripe subscription ID in the subscriptions table
			// If you want to cancel the Stripe subscription, you need to store and retrieve the Stripe subscription ID
			// Example:
			// const { data: subRow } = await supabaseAdmin
			//     .from("subscriptions")
			//     .select("stripe_subscription_id")
			//     .eq("id", subscription.id)
			//     .maybeSingle();
			// if (subRow?.stripe_subscription_id) {
			//     try {
			//         await stripe.subscriptions.cancel(subRow.stripe_subscription_id);
			//     } catch (err) {
			//         console.error("Stripe cancel error", err);
			//     }
			// }

			// Delete user's store (if any)
			const { data: store } = await supabaseAdmin
				.from("stores")
				.select("id")
				.eq("user_id", user.id)
				.maybeSingle();

			if (store?.id) {
				// Delete all products for this store
				await supabaseAdmin
					.from("products")
					.delete()
					.eq("store_id", store.id);
				// Delete the store itself
				await supabaseAdmin
					.from("stores")
					.delete()
					.eq("id", store.id);
			}

			// Redirect to homepage (client should handle this based on response)
			return new Response(
				JSON.stringify({ success: true, redirect: "/" }),
				{ headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 200 }
			);
		}
	} catch (err) {
		console.error("subscriptions error:", err);
		return new Response(
			JSON.stringify({ error: err instanceof Error ? err.message : String(err) }),
			{ headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 500 }
		);
	}
});
