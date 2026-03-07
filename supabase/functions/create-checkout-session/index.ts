const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};
console.log("EDGE FUNCTION HIT", new Date().toISOString());
// @ts-ignore Deno/npm import works in Supabase Edge Functions
import Stripe from "npm:stripe";
// @ts-ignore Deno/npm import works in Supabase Edge Functions
import { createClient } from "npm:@supabase/supabase-js@2.35.0";








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
  // @ts-ignore Deno global is available in Supabase Edge Functions
  const pricePaid = Deno.env.get("STRIPE_PRICE_ID_PAID");
  // @ts-ignore Deno global is available in Supabase Edge Functions
  const priceFree = Deno.env.get("STRIPE_PRICE_ID_FREE");
  // @ts-ignore Deno global is available in Supabase Edge Functions
  const ORIGIN = Deno.env.get("PUBLIC_ORIGIN") ?? "*";
  // Log the server's current UTC time
  console.log("Current server UTC time:", new Date().toISOString());


  // Handle OPTIONS before anything else
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }


  // Check for required environment variables after OPTIONS
  if (!stripeSecret || !supabaseUrl || !supabaseAnon || !supabaseService || !pricePaid || !priceFree) {
    console.error("Missing env vars", {
      stripeSecret: !!stripeSecret,
      supabaseUrl: !!supabaseUrl,
      supabaseAnon: !!supabaseAnon,
      supabaseService: !!supabaseService,
      pricePaid: !!pricePaid,
      priceFree: !!priceFree,
    });
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

  // Only create clients after env check and before POST logic
  const stripe = new Stripe(stripeSecret);
  const supabaseAdmin = createClient(supabaseUrl, supabaseService);

  try {
    const authHeader = req.headers.get("Authorization") ?? "";
    console.log("Authorization header:", authHeader);
    // Extract Bearer token
    const bearerMatch = authHeader.match(/^Bearer\s+(.+)$/i);
    const accessToken = bearerMatch ? bearerMatch[1] : null;
    console.log("Extracted accessToken:", accessToken);

    if (!accessToken) {
      return new Response(
        JSON.stringify({ error: "Invalid user session" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 401 }
      );
    }

    // Pass access token via global headers
    const supabaseUserClient = createClient(supabaseUrl, supabaseAnon, {
      global: {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      },
    });

    // Pass the token explicitly to getUser
    const { data: authData, error: authError } = await supabaseUserClient.auth.getUser(accessToken);
    console.log("getUser result:", JSON.stringify({ authData, authError }));

    if (authError || !authData?.user) {
      console.warn("Auth validation failed:", authError);
      return new Response(
        JSON.stringify({ error: "Invalid user session" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 401 }
      );
    }

    const user = authData.user;
    // Parse POST body for planId
    let planId = undefined;
    try {
      const body = await req.json();
      planId = body.planId;
      console.log("Received planId from body:", planId);
    } catch (e) {
      console.log("No JSON body or planId provided.");
    }

    // Map planId to correct Stripe price ID
    const year = new Date().getFullYear();
    let priceId: string;
    if (planId === "free") {
      priceId = priceFree;
    } else if (planId === "paid") {
      priceId = pricePaid;
    } else {
      // fallback: use year logic as before
      priceId = year === 2026 ? priceFree : pricePaid;
    }

    // Look up existing stripe customer id
    const { data: existingOrders, error: existingOrderError } = await supabaseAdmin
      .from("orders")
      .select("stripe_customer_id")
      .eq("user_id", user.id)
      .limit(1);

    if (existingOrderError) {
      console.error("Error querying orders:", existingOrderError);
      throw new Error("Database error");
    }

    let stripeCustomerId: string | null = existingOrders?.[0]?.stripe_customer_id ?? null;

    if (!stripeCustomerId) {
      const customer = await stripe.customers.create({
        email: user.email ?? undefined,
        metadata: { supabase_user_id: user.id },
      });
      stripeCustomerId = customer.id;
    }

    const { data: order, error: orderError } = await supabaseAdmin
      .from("orders")
      .insert({
        user_id: user.id,
        status: "pending",
        stripe_customer_id: stripeCustomerId,
        amount: year === 2026 ? 0 : 4000,
      })
      .select()
      .single();

    if (orderError || !order) {
      console.error("Failed to create order:", orderError);
      throw new Error("Failed to create order");
    }

    const session = await stripe.checkout.sessions.create({
      mode: "subscription",
      customer: stripeCustomerId,
      client_reference_id: String(order.id),
      line_items: [{ price: priceId, quantity: 1 }],
      success_url: `${ORIGIN}/post-your-store?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${ORIGIN}/subscription/cancel`,
    });

    await supabaseAdmin
      .from("orders")
      .update({ stripe_session_id: session.id })
      .eq("id", order.id);

    return new Response(
      JSON.stringify({ sessionId: session.id, url: session.url }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (err) {
    console.error("create-checkout-session error:", err);
    return new Response(
      JSON.stringify({ error: err instanceof Error ? err.message : String(err) }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 500,
      }
    );
  }
});
