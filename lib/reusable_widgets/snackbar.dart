import 'package:flutter/material.dart';

/// Shows a custom SnackBar with white background, black text, rounded corners, slide-up animation, and 4-second duration.
void showCustomSnackBar(
	BuildContext context,
	String message, {
	SnackBarAction? action,
	bool positive = true,
}) {
	ScaffoldMessenger.of(context).showSnackBar(
		SnackBar(
						content: IntrinsicWidth(
							stepWidth: 0,
							child: Container(
								constraints: const BoxConstraints(maxWidth: 220),
								child: Center(
									child: Row(
										mainAxisSize: MainAxisSize.min,
										crossAxisAlignment: CrossAxisAlignment.center,
										children: [
											Padding(
												padding: const EdgeInsets.symmetric(horizontal: 8.0),
												child: Text(
													message,
													style: const TextStyle(color: Colors.black),
													overflow: TextOverflow.ellipsis,
													maxLines: 2,
													textAlign: TextAlign.center,
												),
											),
											Icon(
												Icons.check_circle,
												color: positive ? Colors.green : Colors.red,
											),
										],
									),
								),
							),
						),
			backgroundColor: Colors.white,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(16),
			),
			behavior: SnackBarBehavior.floating,
			duration: const Duration(seconds: 4),
			action: action,
			elevation: 8,
			margin: const EdgeInsets.only(left: 0, right: 0, bottom: 40),
			// Centered and short width.
		),
	);
}
