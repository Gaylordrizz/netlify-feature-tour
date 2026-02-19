import 'package:flutter/material.dart';

class PasswordRequirementsTracker extends StatelessWidget {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSymbol;

  const PasswordRequirementsTracker({
    super.key,
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSymbol,
  });

  Widget _buildRow(bool met, String text) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.cancel,
          color: met ? Colors.green : Colors.black,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: met ? Colors.green : Colors.black)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow(hasMinLength, 'At least 8 characters'),
        _buildRow(hasUppercase, 'Contains an uppercase letter'),
        _buildRow(hasLowercase, 'Contains a lowercase letter'),
        _buildRow(hasNumber, 'Contains a number'),
        _buildRow(hasSymbol, 'Contains a symbol'),
      ],
    );
  }
}