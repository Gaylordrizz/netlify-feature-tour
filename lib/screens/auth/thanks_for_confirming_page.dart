import 'package:flutter/material.dart';

class ThanksForConfirmingPage extends StatelessWidget {
	const ThanksForConfirmingPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Container(
				width: double.infinity,
				height: double.infinity,
				decoration: const BoxDecoration(
					gradient: LinearGradient(
						colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
						begin: Alignment.topLeft,
						end: Alignment.bottomRight,
					),
				),
				child: SafeArea(
					child: Center(
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								const Icon(Icons.check_circle, size: 80, color: Colors.white),
								const SizedBox(height: 32),
								const Text(
									'Thanks for confirming your email.',
									style: TextStyle(
										fontSize: 32,
										fontWeight: FontWeight.bold,
										color: Colors.white,
									),
									textAlign: TextAlign.center,
								),
								const SizedBox(height: 16),
								const Text(
									'Please login again.',
									style: TextStyle(
										fontSize: 18,
										color: Colors.white,
									),
									textAlign: TextAlign.center,
								),
								const SizedBox(height: 40),
								SizedBox(
									width: 200,
									child: ElevatedButton(
										onPressed: () {
											Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
										},
										style: ElevatedButton.styleFrom(
											backgroundColor: Colors.white,
											foregroundColor: Colors.pink,
											padding: const EdgeInsets.symmetric(vertical: 16),
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(8),
											),
											elevation: 2,
										),
										child: const Text(
											'Login',
											style: TextStyle(
												fontSize: 18,
												fontWeight: FontWeight.bold,
											),
										),
									),
								),
							],
						),
					),
				),
			),
		);
	}
}
