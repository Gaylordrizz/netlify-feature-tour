// @ts-ignore Deno/npm import works in Supabase Edge Functions
import Stripe from "npm:stripe@14.0.0";
// @ts-ignore Deno/npm import works in Supabase Edge Functions
import { createClient } from "npm:@supabase/supabase-js@2.35.0";

// Removed STRIPE_API_VERSION constant

// @ts-ignore Deno global is available in Supabase Edge Functions
const stripeSecret = Deno.env.get("STRIPE_SECRET_KEY");
// @ts-ignore Deno global is available in Supabase Edge Functions
const webhookSecret = Deno.env.get("STRIPE_WEBHOOK_SECRET");
// @ts-ignore Deno global is available in Supabase Edge Functions
const supabaseUrl = Deno.env.get("SUPABASE_URL");
// @ts-ignore Deno global is available in Supabase Edge Functions
const supabaseService = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

if (!stripeSecret || !webhookSecret || !supabaseUrl || !supabaseService) {
  throw new Error("Missing required webhook environment variables");
}

// Stripe constructor without apiVersion
const stripe = new Stripe(stripeSecret);
const cryptoProvider = Stripe.createSubtleCryptoProvider();
const supabaseAdmin = createClient(supabaseUrl, supabaseService);

// @ts-ignore Deno global is available in Supabase Edge Functions
Deno.serve(async (request: Request) => {
  try {
    const signature = request.headers.get("stripe-signature");
    if (!signature) return new Response("Missing signature", { status: 400 });

    const body = await request.text();
    const event = await stripe.webhooks.constructEventAsync(body, signature, webhookSecret, undefined, cryptoProvider);

    if (event.type === "checkout.session.completed") {
      const session = event.data.object as Stripe.Checkout.Session;
      if (!session.client_reference_id || !session.customer) throw new Error("Missing session identifiers");

      await supabaseAdmin
        .from("orders")
        .update({
          status: "active",
          stripe_subscription_id: session.subscription as string,
          stripe_customer_id: String(session.customer),
        })
        .eq("id", session.client_reference_id);
    }

    return new Response("ok", { status: 200 });
  } catch (err) {
    console.error("stripe-webhook error:", err);
    return new Response("Webhook error", { status: 500 });
  }
});
