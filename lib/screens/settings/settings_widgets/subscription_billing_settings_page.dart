import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_tables_contents.dart';

import 'payment_methods_settings_page.dart';
import 'help_support_settings_page.dart';

import '../../../reusable_widgets/footer/page_footer.dart';
import '../../../reusable_widgets/snackbar.dart';
import '../../subscription/invoice_page.dart';
import '../../subscription/receipt_page.dart';

class SubscriptionBillingSettingsPage extends StatefulWidget {
  const SubscriptionBillingSettingsPage({super.key});

  @override
  State<SubscriptionBillingSettingsPage> createState() => _SubscriptionBillingSettingsPageState();
}

class _SubscriptionBillingSettingsPageState extends State<SubscriptionBillingSettingsPage> {
    bool _showCancelButton = false;
  Map<String, dynamic>? subscription;
  List<Invoice>? invoices;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchSubscription();
    fetchInvoices();
  }

  Future<void> fetchSubscription() async {
  setState(() {
    subscription = null;
    loading = false;
    error = null;
  });
}

  Future<void> fetchInvoices() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        setState(() {
          error = 'User not logged in';
          loading = false;
        });
        return;
      }
      final response = await Supabase.instance.client
        .from(SupabaseTables.invoices)
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
      invoices = (response as List)
        .map((json) => Invoice.fromJson(json as Map<String, dynamic>))
        .toList();
      setState(() {
        loading = false;
        error = null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Widget buildActiveCardTile() {
    final cardType = subscription?['card_type'] ?? 'Visa';
    final cardLast4 = subscription?['card_last4'] ?? '1234';
    final cardExpiry = subscription?['card_expiry'] ?? '12/28';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card, color: Colors.grey[600], size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$cardType •••• $cardLast4',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expires $cardExpiry',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.grey, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'ACTIVE CARD',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(label, style: const TextStyle(fontSize: 15, color: Colors.black)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 15, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // Always show the page, even if not logged in or error
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Subscription',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        elevation: 1,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Your Subscription',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'View your plan, payment details, & payment history',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            const SizedBox(height: 32),
            // Current Plan Section
            if (subscription != null) ... [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription?['plan_name'] ?? '',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    if (subscription?['price'] != null)
                      Text(
                        'Price: ${subscription?['price']}',
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    const SizedBox(height: 8),
                    if (subscription?['status'] != null)
                      Row(
                        children: [
                          const Text('Status: ', style: TextStyle(fontSize: 16, color: Colors.black)),
                          Text(
                            subscription?['status']?.toString() ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: subscription?['status'] == 'Active' ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            subscription?['status'] == 'Active' ? Icons.check_circle : Icons.cancel,
                            color: subscription?['status'] == 'Active' ? Colors.green : Colors.red,
                            size: 18,
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Billing Information Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Billing Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (subscription?['invoice_number'] != null)
                      infoRow('Invoice Number:', subscription?['invoice_number'] ?? ''),
                    if (subscription?['start_date'] != null) ... [
                      const Divider(height: 24, thickness: 1, color: Colors.black12),
                      infoRow('Date of Subscription:', subscription?['start_date'] ?? ''),
                    ],
                    if (subscription?['price'] != null) ... [
                      const Divider(height: 24, thickness: 1, color: Colors.black12),
                      infoRow('Price / Month:', subscription?['price']?.toString() ?? ''),
                    ],
                    if (subscription?['billing_cycle'] != null) ... [
                      const Divider(height: 24, thickness: 1, color: Colors.black12),
                      infoRow('Billing Cycle:', subscription?['billing_cycle'] ?? ''),
                    ],
                    const Divider(height: 24, thickness: 1, color: Colors.black12),
                    const SizedBox(height: 12),
                    buildActiveCardTile(),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentMethodsSettingsPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Update Payment Method'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Subscription Actions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Subscription Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReceiptPage(
                              receipts: (invoices ?? [])
                                .whereType<Receipt>()
                                .toList(),
                            ),
                          ),
                      );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('View Receipts'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvoicePage(invoices: invoices ?? []),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('View Invoices'),
                    ),
                    const SizedBox(height: 8),
                    !_showCancelButton
                        ? IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              setState(() {
                                _showCancelButton = true;
                              });
                            },
                          )
                        : OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final TextEditingController confirmController = TextEditingController();
                                  return StatefulBuilder(
                                    builder: (context, setDialogState) {
                                      final bool isConfirmed = confirmController.text == 'Cancel Subscription';
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        title: const Text('Cancel Subscription'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Are you sure you want to cancel your subscription?\n\n'
                                              'If you continue, your subscription will be canceled and you will not be charged for the next billing cycle anymore.\n\n'
                                              'If you cancel, your Storazaar account will still be accessible.\n\n'
                                              'Please note: all of your store information and listed products will be immediately and permanently deleted and cannot be recovered.'
                                            ),
                                            const SizedBox(height: 18),
                                            const Text(
                                              'To confirm, type "Cancel Subscription" below:',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: confirmController,
                                              onChanged: (val) => setDialogState(() {}),
                                              cursorColor: Colors.black,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black, width: 2),
                                                ),
                                                hintText: 'Cancel Subscription',
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Keep Subscription', style: TextStyle(color: Colors.blue)),
                                          ),
                                          ElevatedButton(
                                            onPressed: isConfirmed
                                                ? () {
                                                    Navigator.pop(context);
                                                    // TODO: Add cancellation logic here
                                                    showCustomSnackBar(
                                                      context,
                                                      'Subscription canceled. All store data deleted.',
                                                      positive: false,
                                                    );
                                                  }
                                                : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isConfirmed ? Colors.red : Colors.grey,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Cancel Subscription'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade800,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Cancel Subscription'),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ] else ... [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: const Text(
                  'No active subscription found. Please subscribe to a plan to view details.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 32),
            ],
            // Support Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.help_outline, color: Colors.black, size: 22),
                      SizedBox(width: 8),
                      Text('Help', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportSettingsPage(),
                            ),
                          );
                        },
                        child: const Text('Contact Support', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                      // Help button removed
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Footer
            const PageFooter(),
          ],
        ),
      ),
    );
  }

}
