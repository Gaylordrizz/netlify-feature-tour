import 'package:flutter/material.dart';
import 'package:credit_card_form/credit_card_form.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/simple_icons.dart';
import '../../screens/storazaar_docs.dart/all_storazaar_docs.dart';
import '../../reusable_widgets/snackbar.dart';

class AddBillingInfoPage extends StatelessWidget {
    AddBillingInfoPage({Key? key}) : super(key: key);

    final CardDataInputController controller = CardDataInputController();

    final ValueNotifier<CardData> cardDataNotifier = ValueNotifier(CardData());

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: const Text('Add Billing Info'),
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
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                                                child: Column(
                                                        children: [
                                                                const SizedBox(height: 32),
                                                                const Text(
                                                                    'Change your current payment method or add another card.',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                                                                ),
                                                                const SizedBox(height: 18),
                                                                Container(
                                                                    width: 370,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        border: Border.all(color: Colors.black, width: 1.5),
                                                                        borderRadius: BorderRadius.circular(0), // square corners
                                                                    ),
                                                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                                                                    child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                            Theme(
                                                                                data: Theme.of(context).copyWith(
                                                                                    textSelectionTheme: const TextSelectionThemeData(
                                                                                        cursorColor: Colors.black,
                                                                                    ),
                                                                                ),
                                                                                child: CreditCardForm(
                                                                                    theme: CreditCardLightTheme(),
                                                                                    controller: controller,
                                                                                    onChanged: (CardData data) {
                                                                                        cardDataNotifier.value = data;
                                                                                    },
                                                                                ),
                                                                            ),
                                                                            const SizedBox(height: 18),
                                                                            ValueListenableBuilder<CardData>(
                                                                                valueListenable: cardDataNotifier,
                                                                                builder: (context, cardData, _) {
                                                                                    String cardTypeText = cardData.cardType != null
                                                                                            ? cardData.cardType.toString().split('.').last
                                                                                            : '';
                                                                                    return cardTypeText.isNotEmpty
                                                                                            ? Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [
                                                                                                        const Text(
                                                                                                            'Card Type: ',
                                                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                        ),
                                                                                                        Text(
                                                                                                            cardTypeText,
                                                                                                            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                                                                                        ),
                                                                                                    ],
                                                                                                )
                                                                                            : const SizedBox.shrink();
                                                                                },
                                                                            ),
                                                                            const SizedBox(height: 10),
                                                                            SizedBox(
                                                                                width: 160,
                                                                                child: ElevatedButton(
                                                                                    child: const Text('Add Card'),
                                                                                    style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: Colors.blue,
                                                                                        foregroundColor: Colors.white,
                                                                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                                                                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                        final cardData = controller.value;
                                                                                        print('Submit pressed: cardData = ${cardData.cardNumber}, ${cardData.expiredDate}, ${cardData.cardHolderName}, ${cardData.cvc}, ${cardData.cardType}');
                                                                                        if (cardData.cardNumber.isNotEmpty && cardData.expiredDate.isNotEmpty) {
                                                                                            final result = {
                                                                                                'type': cardData.cardType != null ? cardData.cardType.toString().split('.').last : 'Card',
                                                                                                'last4': cardData.cardNumber.length >= 4 ? cardData.cardNumber.substring(cardData.cardNumber.length - 4) : cardData.cardNumber,
                                                                                                'expiry': cardData.expiredDate,
                                                                                                'name': cardData.cardHolderName,
                                                                                                'cvv': cardData.cvc,
                                                                                            };
                                                                                            print('Returning result: $result');
                                                                                            Navigator.pop(context, result);
                                                                                        } else {
                                                                                            showCustomSnackBar(
                                                                                                context,
                                                                                                'Please enter valid card details',
                                                                                                positive: false,
                                                                                            );
                                                                                        }
                                                                                    },
                                                                                ),
                                                                            ),
                                                                            const SizedBox(height: 18),
                                                                            IconButton(
                                                                                icon: const Icon(Icons.menu_book, color: Colors.grey, size: 32),
                                                                                onPressed: () {
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => AllStorazaarDocsPage(),
                                                                                        ),
                                                                                    );
                                                                                },
                                                                            ),
                                                                        ],
                                                                    ),
                                                                ),
                                                                const SizedBox(height: 24),
                                                                const Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                        Iconify(SimpleIcons.visa, size: 32, color: Color(0xFF1A1F71)), // Visa blue
                                                                        SizedBox(width: 12),
                                                                        Iconify(SimpleIcons.mastercard, size: 32, color: Color(0xFFFF5F00)), // Mastercard orange
                                                                        SizedBox(width: 12),
                                                                        Iconify(SimpleIcons.americanexpress, size: 32, color: Color(0xFF2E77BB)), // Amex blue
                                                                        SizedBox(width: 12),
                                                                        Iconify(SimpleIcons.paypal, size: 32, color: Color(0xFF003087)), // PayPal blue
                                                                        SizedBox(width: 12),
                                                                        Iconify(SimpleIcons.applepay, size: 32, color: Colors.black), // Apple Pay black
                                                                        SizedBox(width: 12),
                                                                        Iconify(SimpleIcons.googlepay, size: 32, color: Color(0xFF4285F4)), // Google Pay blue
                                                                    ],
                                                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}