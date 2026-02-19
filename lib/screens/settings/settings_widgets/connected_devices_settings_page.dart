import 'package:flutter/material.dart';
import '../../../reusable_widgets/header/global_header.dart';
import '../../../reusable_widgets/sidebar/sidebar.dart';
import '../../../services/search_state.dart';

class ConnectedDevicesSettingsPage extends StatelessWidget {
  const ConnectedDevicesSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchState = SearchState();

    return Scaffold(
      drawer: const GlobalSidebarDrawer(),
      appBar: GlobalHeader(
        title: 'Connected Devices',
        productSearchController: searchState.productSearchController,
        storeSearchController: searchState.storeSearchController,
        onProductSearch: (query) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
        onStoreSearch: (query) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
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
                    'Connected Devices',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'List of devices currently logged in; option to sign out remotely',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Current Device
                  _buildDeviceCard(
                    icon: Icons.computer,
                    deviceName: 'Windows PC',
                    location: 'New York, USA',
                    time: 'Active now',
                    isCurrent: true,
                  ),

                  const SizedBox(height: 16),

                  // Other Devices
                  _buildDeviceCard(
                    icon: Icons.phone_android,
                    deviceName: 'Android Phone',
                    location: 'New York, USA',
                    time: '2 hours ago',
                    isCurrent: false,
                  ),

                  const SizedBox(height: 16),

                  _buildDeviceCard(
                    icon: Icons.tablet,
                    deviceName: 'iPad',
                    location: 'New York, USA',
                    time: '1 day ago',
                    isCurrent: false,
                  ),

                  const SizedBox(height: 32),

                  // Sign Out All Button
                  OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('Sign Out All Devices'),
                          content: const Text(
                            'This will sign you out from all devices except this one. You will need to log in again on those devices.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Signed out from all devices')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Sign Out All'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text('Sign Out All Devices', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard({
    required IconData icon,
    required String deviceName,
    required String location,
    required String time,
    required bool isCurrent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: isCurrent ? Colors.green : Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: isCurrent ? Colors.green.shade50 : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: isCurrent ? Colors.green : Colors.grey.shade600, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      deviceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Current',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          if (!isCurrent)
            TextButton(
              onPressed: () {
                // Sign out this device
              },
              child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}
