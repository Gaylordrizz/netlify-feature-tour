import 'package:flutter/material.dart';
import '../../screens/storazaar_docs.dart/all_storazaar_docs.dart';

class PageFooter extends StatelessWidget {
  const PageFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final horizontalPadding = isMobile ? 12.0 : 40.0;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterLink(context, 'Profile', '/settings/profile'),
                    const SizedBox(height: 8),
                    _buildFooterLink(context, 'Account', '/settings/account'),
                    const SizedBox(height: 8),
                    _buildFooterLink(context, 'Security', '/settings/security'),
                  ],
                ),
              ),
              // Settings Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterLink(context, 'Notifications', '/settings/notifications'),
                    const SizedBox(height: 8),
                    _buildFooterLink(context, 'Privacy', '/settings/privacy'),
                    const SizedBox(height: 8),
                    _buildFooterLink(context, 'Payment Methods', '/settings/payment-methods'),
                    const SizedBox(height: 8),
                    _buildFooterLink(context, 'Subscription / Billing', '/settings/subscription-billing'),
                  ],
                ),
              ),
              // System Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterLink(context, 'Connected Devices', '/settings/connected-devices'),
                    const SizedBox(height: 8),
                    _buildFooterLink(context, 'Data & Storage', '/settings/data-storage'),
                    const SizedBox(height: 8),
                    _buildFooterLink(context, 'Help & Support', '/settings/help-support'),
                  ],
                ),
              ),
              // Legal Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterLink(context, 'About', '/settings/about'),
                    const SizedBox(height: 8),
                    _buildFooterLink(context, 'Terms & Conditions', '/settings/terms-conditions'),
                    const SizedBox(height: 8),
                    _buildDocsFooterLink(context),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Storazaar  2025',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/subscription');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/storazaar_logo.png',
                      height: 18,
                      width: 18,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Storazaar',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              '7639304856dhfn6hs56dcns85',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String text, String route) {
    return _HoverableFooterLink(
      text: text,
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildDocsFooterLink(BuildContext context) {
    return _HoverableFooterLink(
      text: 'Docs',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                // Import the docs page widget in the parent file
                // ignore: prefer_const_constructors
                AllStorazaarDocsPage(),
          ),
        );
      },
    );
  }
}

class _HoverableFooterLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _HoverableFooterLink({
    required this.text,
    required this.onTap,
  });

  @override
  State<_HoverableFooterLink> createState() => _HoverableFooterLinkState();
}

class _HoverableFooterLinkState extends State<_HoverableFooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            decoration: _isHovered ? TextDecoration.underline : TextDecoration.none,
            decorationColor: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }
}
