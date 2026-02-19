
import '../../payment_methods_page/add_billing_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../reusable_widgets/footer/page_footer.dart';


class PaymentMethodsSettingsPage extends StatefulWidget {
  const PaymentMethodsSettingsPage({super.key});

  @override
  State<PaymentMethodsSettingsPage> createState() => PaymentMethodsSettingsPageState();
}


class PaymentCard {
  String type;
  String last4;
  String expiry;
  String name;
  String cvv;
  PaymentCard({
    required this.type,
    required this.last4,
    required this.expiry,
    required this.name,
    required this.cvv,
  });
}

class PaymentMethodsSettingsPageState extends State<PaymentMethodsSettingsPage> {
  List<PaymentCard> _cards = [];

  void _addCard(PaymentCard card) {
    setState(() {
      _cards.add(card);
      print('Card added: type=${card.type}, last4=${card.last4}, expiry=${card.expiry}');
    });
  }



  void _deleteCard(int index) {
    setState(() {
      _cards.removeAt(index);
    });
  }

  Future<void> _navigateAddCard() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBillingInfoPage(),
      ),
    );
    print('Received result from AddBillingInfoPage: $result');
    if (result is Map) {
      final card = PaymentCard(
        type: result['type'] ?? 'Card',
        last4: result['last4'] ?? '',
        expiry: result['expiry'] ?? '',
        name: result['name'] ?? '',
        cvv: result['cvv'] ?? '',
      );
      _addCard(card);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Payment Methods',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Your Payment Methods',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    _cards.isEmpty
                        ? const Center(child: Text('No payment methods added.'))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _cards.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final card = _cards[index];
                              return buildPaymentMethodCard(
                                context: context,
                                type: card.type,
                                last4: card.last4,
                                expiry: card.expiry,
                                onDelete: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      title: const Row(
                                        children: [
                                          Icon(Icons.warning, color: Colors.red, size: 28),
                                          SizedBox(width: 12),
                                          Text('Delete Payment Method'),
                                        ],
                                      ),
                                      content: const Text(
                                        'Are you sure you want to delete this card/payment method? If it is your active payment method and you are subscribed, you will lose your subscription, and your listed product(s), store profile and domain will be deleted from Storazaar at the end of your billing cycle. Your account will be still available, though.',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _deleteCard(index);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Yes, delete this card/payment method'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                isActive: index == 0,
                              );
                            },
                          ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Card'),
                        onPressed: () => _navigateAddCard(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          const PageFooter(),
        ],
      ),
    );
  }
}


Widget buildPaymentMethodCard({
  required BuildContext context,
  required String type,
  required String last4,
  required String expiry,
  required VoidCallback onDelete,
  bool isActive = false,
}) {
  IconData cardIcon;
  Color cardColor;

  switch (type) {
    case 'Visa':
      cardIcon = Icons.credit_card;
      cardColor = Colors.grey[600]!;
      break;
    case 'Mastercard':
      cardIcon = Icons.credit_card;
      cardColor = Colors.grey[600]!;
      break;
    default:
      cardIcon = Icons.credit_card;
      cardColor = Colors.grey[600]!;
  }

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: isActive ? Colors.green : Colors.grey.shade300, width: 3),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(cardIcon, color: cardColor, size: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$type •••• $last4',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Expires $expiry',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        if (isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'ACTIVE CARD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.grey.shade600),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 28),
                    SizedBox(width: 12),
                    Text('Delete Payment Method'),
                  ],
                ),
                content: const Text(
                  'Are you sure you want to delete this card/payment method? If it is your active payment method and you are subscribed, you will lose your subscription, and your listed product(s), store profile and domain will be deleted at the end of your billing cycle. Your account will be still available, though.',
                  style: TextStyle(fontSize: 15),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Yes, delete this card/payment method'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget buildPaymentOption({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade600),
        ],
      ),
    ),
  );
}
