import 'package:flutter/material.dart';

/// Returns a CircleAvatar widget for a user with:
/// - Background color based on first letter of name (Google-style)
/// - White text color for the initial
CircleAvatar getUserAvatar(String name, {double radius = 20}) {
	if (name.isEmpty) return CircleAvatar(backgroundColor: Colors.grey, radius: radius);

	// 1. Define a fixed palette of colors
	final List<Color> palette = [
		Colors.red,
		Colors.blue,
		Colors.green,
		Colors.orange,
		Colors.purple,
		Colors.teal,
		Colors.indigo,
		Colors.pink,
		Colors.brown,
		Colors.cyan,
	];

	// 2. Take first character and convert to uppercase
	String firstLetter = name[0].toUpperCase();

	// 3. Convert character to ASCII code
	int code = firstLetter.codeUnitAt(0);

	// 4. Map code to palette using modulo
	int colorIndex = code % palette.length;
	Color bgColor = palette[colorIndex];

	// 5. Return CircleAvatar with white text
	return CircleAvatar(
		radius: radius,
		backgroundColor: bgColor,
		child: Text(
			firstLetter,
			style: const TextStyle(
				color: Colors.white, // white text
				fontWeight: FontWeight.bold,
			),
		),
	);
}
