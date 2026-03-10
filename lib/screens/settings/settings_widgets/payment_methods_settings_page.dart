import 'package:flutter/material.dart';
import 'subscription_billing_settings_page.dart';
import '../../payment_methods_page/add_billing_info.dart';

class PaymentMethodsSettingsPage extends StatelessWidget {
	const PaymentMethodsSettingsPage({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		// TODO: Replace with real card info passed from SubscriptionBillingSettingsPage
		final String cardNumber = '4242 1234 5678 9012';
		final String cardHolder = 'John Doe';
		final String expiry = '12/28';

		return Scaffold(
			appBar: PreferredSize(
				preferredSize: const Size.fromHeight(kToolbarHeight),
				child: Container(
					decoration: const BoxDecoration(
						gradient: LinearGradient(
							colors: [
								Color(0xFFFFC1CC), // Pink
								Color(0xFFFFD700), // Gold
							],
							begin: Alignment.topLeft,
							end: Alignment.bottomRight,
						),
					),
					child: SafeArea(
						child: Stack(
							alignment: Alignment.center,
							children: [
								Align(
									alignment: Alignment.centerLeft,
									child: IconButton(
										icon: const Icon(Icons.arrow_back, color: Colors.black),
										tooltip: '', // No tooltip
										onPressed: () => Navigator.of(context).pushReplacement(
											MaterialPageRoute(builder: (context) => SubscriptionBillingSettingsPage()),
										),
									),
								),
								const Center(
									child: Text(
										'Payment Methods',
										style: TextStyle(
											color: Colors.black,
											fontWeight: FontWeight.bold,
											fontSize: 20,
										),
									),
								),
							],
						),
					),
				),
			),
			body: SingleChildScrollView(
				child: Center(
					child: Column(
						children: [
							const SizedBox(height: 24),
							const Text(
							  'Update or add a payment method',
							  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
							  textAlign: TextAlign.center,
							),
							Container(
							  margin: const EdgeInsets.only(top: 24),
							  width: 350,
							  padding: const EdgeInsets.all(24),
							  decoration: BoxDecoration(
							    color: Colors.white,
							    border: Border.all(color: Colors.black, width: 2),
							    boxShadow: [
							      BoxShadow(
							        color: Colors.black.withOpacity(0.08),
							        blurRadius: 12,
							        offset: const Offset(0, 6),
							      ),
							    ],
							  ),
							  child: Column(
							    mainAxisSize: MainAxisSize.min,
							    crossAxisAlignment: CrossAxisAlignment.start,
							    children: [
															const SizedBox(height: 24),
															ElevatedButton(
															  style: ElevatedButton.styleFrom(
															    backgroundColor: Colors.blue,
															    foregroundColor: Colors.white,
															    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
															    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
															    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
															  ),
															  onPressed: () {
															    Navigator.of(context).push(
															      MaterialPageRoute(builder: (context) => AddBillingInfoPage()),
															    );
															  },
															  child: const Text('Add'),
															),
								// Cardholder Label and Field (top)
								const Text('Cardholder:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
								Container(
									width: double.infinity,
									padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
									margin: const EdgeInsets.only(bottom: 12, top: 4),
									decoration: BoxDecoration(
										color: Colors.grey.shade200,
										border: Border.all(color: Colors.black, width: 1),
									),
									child: Text(
										cardHolder,
										style: const TextStyle(fontSize: 18, color: Colors.black),
									),
								),
								// Card Number Label and Field
								const Text('Card Number:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
								Container(
									width: double.infinity,
									padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
									margin: const EdgeInsets.only(bottom: 12, top: 4),
									decoration: BoxDecoration(
										color: Colors.grey.shade200,
										border: Border.all(color: Colors.black, width: 1),
									),
									child: Text(
										cardNumber,
										style: const TextStyle(fontSize: 18, color: Colors.black),
									),
								),
								// Expiry and CVV side by side
								Row(
								  children: [
									Expanded(
									  flex: 1,
									  child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
										  const Text('Expiry:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
										  Container(
											width: 90,
											padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
											margin: const EdgeInsets.only(bottom: 18, top: 4),
											decoration: BoxDecoration(
											  color: Colors.grey.shade200,
											  border: Border.all(color: Colors.black, width: 1),
											),
											child: Text(
											  expiry,
											  style: const TextStyle(fontSize: 18, color: Colors.black),
											),
										  ),
										],
									  ),
									),
									const SizedBox(width: 16),
									Expanded(
									  flex: 1,
									  child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
										  const Text('CVV:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
										  Container(
											width: 90,
											padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
											margin: const EdgeInsets.only(bottom: 18, top: 4),
											decoration: BoxDecoration(
											  color: Colors.grey.shade200,
											  border: Border.all(color: Colors.black, width: 1),
											),
											child: const Text(
											  '123',
											  style: TextStyle(fontSize: 18, color: Colors.black),
											),
										  ),
										],
									  ),
									),
								  ],
								),
								// Active Card Label
								Container(
									padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
									decoration: BoxDecoration(
										color: Colors.transparent,
										border: Border.all(color: Colors.green, width: 2),
									),
									child: const Text(
										'ACTIVE CARD',
										style: TextStyle(
											color: Colors.black,
											fontWeight: FontWeight.bold,
											fontSize: 10,
										),
									),
								),
							],
						),
					),
						],
					),
				),
			),
		);
	}
}