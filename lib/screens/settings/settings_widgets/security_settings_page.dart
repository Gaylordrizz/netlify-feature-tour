import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _loginAlertsEnabled = true;
  bool _deviceSecurityEnabled = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadSettingsFromSupabase();
  }

  Future<void> _loadSettingsFromSupabase() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final meta = user.userMetadata ?? {};
      setState(() {
        _loginAlertsEnabled = meta['login_alerts_enabled'] ?? true;
        _deviceSecurityEnabled = meta['device_security_enabled'] ?? true;
      });
    }
  }

  Future<void> _updateUserMetadata({bool? loginAlerts, bool? deviceSecurity}) async {
    setState(() { _loading = true; });
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() { _loading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in.')),
      );
      return;
    }
    final currentMeta = Map<String, dynamic>.from(user.userMetadata ?? {});
    if (loginAlerts != null) currentMeta['login_alerts_enabled'] = loginAlerts;
    if (deviceSecurity != null) currentMeta['device_security_enabled'] = deviceSecurity;
    final res = await supabase.auth.updateUser(
      UserAttributes(data: currentMeta),
    );
    setState(() { _loading = false; });
    if (res.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update security settings.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Security Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Security',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login alerts, device security settings',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),

                // Login Alerts
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications_active, color: Colors.grey.shade600, size: 28),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login Alerts',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Get notified when someone logs into your account',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _loginAlertsEnabled,
                        onChanged: _loading
                            ? null
                            : (value) async {
                                setState(() {
                                  _loginAlertsEnabled = value;
                                });
                                await _updateUserMetadata(loginAlerts: value);
                              },
                        activeColor: const Color.fromARGB(255, 49, 232, 55),
                        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.white;
                          }
                          return Colors.white;
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Device Security
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.phone_android, color: Colors.grey.shade600, size: 28),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Device Security',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Require authentication on new devices',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _deviceSecurityEnabled,
                        onChanged: _loading
                            ? null
                            : (value) async {
                                setState(() {
                                  _deviceSecurityEnabled = value;
                                });
                                await _updateUserMetadata(deviceSecurity: value);
                              },
                        activeColor: const Color.fromARGB(255, 49, 232, 55),
                        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.white;
                          }
                          return Colors.white;
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ...existing code...
}
