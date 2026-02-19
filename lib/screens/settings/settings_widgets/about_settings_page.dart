import 'package:flutter/material.dart';

class AboutSettingsPage extends StatelessWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: null, // No tooltip
        ),
        title: const Text('About'),
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFB6D5), // Lighter Pink
                Color(0xFFFFD700), // Gold
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'About Storazaar',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'App information, version details, and Our Story',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),

                  // App Icon & Version
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/storazaar_logo.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Storazaar',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Info Items
                  _buildInfoItem(
                    icon: Icons.info_outline,
                    label: 'Build Number',
                    value: '2025.01.01',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    icon: Icons.verified_user,
                    label: 'License',
                    value: 'Proprietary',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    icon: Icons.developer_mode,
                    label: 'Developer',
                    value: 'Oak Volen',
                  ),

                  const SizedBox(height: 32),

                  // Links
                  const Text(
                    'Our Story',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Storazaar began with a simple epiphany: discovering great online stores shouldn’t be hard, and growing one shouldn’t feel impossible.\n\n'
                    'What started as a moment of clarity quickly turned into a mission — to build a place where customers can easily discover remarkable online stores, and where entrepreneurs can showcase their products, and grow their business without friction or inflated costs.\n\n'
                    'Today, Storazaar is still growing — and proudly so. We exist to highlight independent brands, help them get discovered, and give them tools to attract the right audience.\n\n'
                    'For shoppers, Storazaar is a curated discovery platform — a way to explore new stores, products, and ideas in one place.\n'
                    'For entrepreneurs, it’s a simple and effective marketing companion: list your online store, showcase your products, run promotions, and gain visibility without needing a big marketing budget.\n\n'
                    'To support builders from day one, Storazaar is free to subscribe for the entire 2026 calendar year. This means you can list your online store, showcase your products, and grow your presence on the platform at no cost while we continue to build and improve alongside you.\n\n'
                    'Storazaar was built with the belief that great businesses deserve to be seen — no matter their size — and that discovery should work for everyone.',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 32),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
