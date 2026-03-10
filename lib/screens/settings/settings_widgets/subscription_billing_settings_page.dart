import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_tables_contents.dart';

import 'payment_methods_settings_page.dart';
import 'help_support_settings_page.dart';

import '../../../reusable_widgets/footer/page_footer.dart';
import '../../subscription/invoice_page.dart';
import '../../subscription/receipt_page.dart';
import '../../../services/pro_status_service.dart';
import '../../../state/app_state_provider.dart';

class SubscriptionBillingSettingsPage extends StatefulWidget {
  const SubscriptionBillingSettingsPage({super.key});

  @override
  State<SubscriptionBillingSettingsPage> createState() =>
      _SubscriptionBillingSettingsPageState();
}

class _SubscriptionBillingSettingsPageState
    extends State<SubscriptionBillingSettingsPage> {
  bool _showCancelButton = false;
  Map<String, dynamic>? subscription;
  String? _cancellationStatus; // null, 'pending', 'cancelled', etc.
  List<Invoice>? invoices;
  List<Receipt>? receipts;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchSubscriptionAndInvoicesAndReceipts();
  }

  Future<void> fetchSubscriptionAndInvoicesAndReceipts() async {
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
      final subResponse = await Supabase.instance.client
          .from('subscriptions')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();
      subscription = subResponse;

      final invoiceResponse = await Supabase.instance.client
          .from(SupabaseTables.invoices)
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);
        invoices = invoiceResponse
          .whereType<Map<String, dynamic>>()
          .map((json) => Invoice.fromJson(json))
          .toList();

      final receiptResponse = await Supabase.instance.client
          .from(SupabaseTables.receipts)
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);
        receipts = receiptResponse
          .whereType<Map<String, dynamic>>()
          .map((json) => Receipt.fromJson(json))
          .toList();

      setState(() {
        loading = false;
        error = null;
      });
    } catch (e) {
      setState(() {
        invoices = <Invoice>[];
        receipts = <Receipt>[];
        loading = false;
        error = null;
      });
    }
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
    // Show only masked card reference (**** **** **** 4242)
    final last4 =
      (subscription?['card_last4'] as String?) ??
      (subscription?['stripe_card_last4'] as String?) ??
      '4242';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card, color: Colors.green, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '**** **** **** $last4',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 2,
            ), // 50% smaller
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
                fontSize: 7,
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
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Loading spinner removed
    // if (loading) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }
    // Don't show a big error, just show empty states if error
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
            if (subscription != null) ...[
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
                      // Display subscription status as the plan name (or use a real plan name if you have one)
                      subscription?['status']?.toString().toUpperCase() ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (subscription?['price_id'] != null)
                      Text(
                        'Price ID: \\${subscription?['price_id']}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    if (subscription?['quantity'] != null)
                      Text(
                        'Quantity: \\${subscription?['quantity']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Status row
                    if (subscription?['status'] != null || _cancellationStatus != null)
                      Row(
                        children: [
                          const Text(
                            'Status: ',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Builder(
                            builder: (context) {
                              final status =
                                  _cancellationStatus ??
                                  (subscription?['status']?.toString() ?? '');
                              final isActive = status.toLowerCase() == 'active';
                              final isPending = status.toLowerCase() == 'pending';
                              final isCancelled = status.toLowerCase() == 'cancelled' || status.toLowerCase() == 'canceled';
                              Color iconColor;
                              IconData iconData;
                              if (isActive) {
                                iconColor = Colors.green;
                                iconData = Icons.check_circle;
                              } else if (isPending) {
                                iconColor = Colors.amber;
                                iconData = Icons.settings;
                              } else if (isCancelled) {
                                iconColor = Colors.red;
                                iconData = Icons.cancel;
                              } else {
                                iconColor = Colors.black;
                                iconData = Icons.help_outline;
                              }
                              return Row(
                                children: [
                                  Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isActive
                                          ? Colors.green
                                          : isPending
                                          ? Colors.amber.shade800
                                          : isCancelled
                                          ? Colors.red
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(iconData, color: iconColor, size: 18),
                                ],
                              );
                            },
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
                    const Text(
                      'Billing Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (subscription?['current_period_start'] != null)
                      infoRow(
                        'Current Period Start:',
                        subscription?['current_period_start']?.toString() ?? '',
                      ),
                    if (subscription?['current_period_end'] != null)
                      infoRow(
                        'Current Period End:',
                        subscription?['current_period_end']?.toString() ?? '',
                      ),
                    if (subscription?['cancel_at_period_end'] != null)
                      infoRow(
                        'Cancel At Period End:',
                        (subscription?['cancel_at_period_end']?.toString() ?? ''),
                      ),
                    if (subscription?['created_at'] != null)
                      infoRow(
                        'Created At:',
                        subscription?['created_at']?.toString() ?? '',
                      ),
                    if (subscription?['updated_at'] != null)
                      infoRow(
                        'Updated At:',
                        subscription?['updated_at']?.toString() ?? '',
                      ),
                    const Divider(
                      height: 24,
                      thickness: 1,
                      color: Colors.black12,
                    ),
                    const SizedBox(height: 12),
                    buildActiveCardTile(),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PaymentMethodsSettingsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                    const Text(
                      'Subscription Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReceiptPage(
                              receipts: receipts ?? [],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View Receipts'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InvoicePage(invoices: invoices ?? []),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                                  final TextEditingController
                                  confirmController = TextEditingController();
                                  return StatefulBuilder(
                                    builder: (context, setDialogState) {
                                      final bool isConfirmed =
                                          confirmController.text ==
                                          'Cancel Subscription';
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        title: const Text(
                                          'Cancel Subscription',
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Are you sure you want to cancel your subscription?\n\n'
                                              'If you continue, your subscription will be canceled and you will not be charged for the next billing cycle anymore.\n\n'
                                              'If you cancel, your Storazaar account will still be accessible.\n\n'
                                              'Please note: all of your store information and listed products will be immediately and permanently deleted and cannot be recovered.',
                                            ),
                                            const SizedBox(height: 18),
                                            const Text(
                                              'To confirm, type "Cancel Subscription" below:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: confirmController,
                                              onChanged: (val) =>
                                                  setDialogState(() {}),
                                              cursorColor: Colors.black,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 2,
                                                      ),
                                                    ),
                                                hintText: 'Cancel Subscription',
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text(
                                              'Keep Subscription',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: isConfirmed
                                                ? () async {
                                                    Navigator.pop(context); // Close confirmation dialog
                                                    setState(() {
                                                      _cancellationStatus = 'pending';
                                                    });
                                                    try {
                                                      // Use new unified subscriptions Edge Function
                                                      await Supabase
                                                          .instance
                                                          .client
                                                          .functions
                                                          .invoke(
                                                            'subscriptions',
                                                            body: { 'action': 'cancel' },
                                                          );
                                                      await Supabase
                                                          .instance
                                                          .client
                                                          .auth
                                                          .signOut();
                                                      if (context.mounted) {
                                                        // Pop dialogs (including spinner) but do not pop the main Account page
                                                        var nav = Navigator.of(context, rootNavigator: true);
                                                        int popCount = 0;
                                                        while (nav.canPop() && popCount < 10) {
                                                          nav.pop();
                                                          popCount++;
                                                        }
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Subscription canceled and all data deleted.',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    } catch (e) {
                                                      if (context.mounted) {
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Failed to cancel subscription: \$e',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isConfirmed
                                                  ? Colors.red
                                                  : Colors.grey,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text(
                                              'Cancel Subscription',
                                            ),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Cancel Subscription'),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ] else ...[
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
                      Text(
                        'Help',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                              builder: (context) =>
                                  const HelpSupportSettingsPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Contact Support',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Help button removed
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Footer
            FutureBuilder<bool>(
              future: ProStatusService.isUserPro(),
              builder: (context, snapshot) {
                final isPro = snapshot.data == true;
                final userTier = isPro
                    ? UserTier.accountPaying
                    : UserTier.accountFree;
                return PageFooter(userTier: userTier);
              },
            ),
          ],
        ),
      ),
    );
  }
}
