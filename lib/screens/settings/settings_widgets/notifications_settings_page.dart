import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../reusable_widgets/snackbar.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _emailNotifications = true;
  bool _promotionalEmails = false;
  bool _storazaarUpdates = true;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final meta = user.userMetadata ?? {};
      setState(() {
        _emailNotifications = meta['email_notifications'] ?? true;
        _promotionalEmails = meta['promotional_emails'] ?? false;
        _storazaarUpdates = meta['storazaar_updates'] ?? true;
      });
    }
  }

  Future<void> _updateNotificationSettings({
    bool? emailNotifications,
    bool? promotionalEmails,
    bool? storazaarUpdates,
    bool showFeedback = false,
  }) async {
    setState(() { _loading = true; });
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() { _loading = false; });
      if (showFeedback) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be signed in.')),
        );
      }
      return;
    }
    final currentMeta = Map<String, dynamic>.from(user.userMetadata ?? {});
    if (emailNotifications != null) currentMeta['email_notifications'] = emailNotifications;
    if (promotionalEmails != null) currentMeta['promotional_emails'] = promotionalEmails;
    // Removed old storeUpdates logic; only using storazaarUpdates now
      if (storazaarUpdates != null) currentMeta['storazaar_updates'] = storazaarUpdates;
    final res = await supabase.auth.updateUser(
      UserAttributes(data: currentMeta),
    );
    setState(() { _loading = false; });
    if (showFeedback) {
      if (res.user != null) {
        showCustomSnackBar(context, 'Notification preferences saved', positive: true);
      } else {
        showCustomSnackBar(context, 'Failed to save notification preferences.', positive: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: null, // No tooltip
        ),
        title: const Text('Notification Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFB6D5), // Light Pink
                Color(0xFFFFD700), // Gold
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
                    'Notifications',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Receive updates via email',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ...Push Notifications option removed...

                  // Email Notifications
                  _buildNotificationToggle(
                    icon: Icons.email,
                    title: 'Email Notifications',
                    subtitle: 'Receive updates via email',
                    value: _emailNotifications,
                    onChanged: _loading
                        ? (value) {}
                        : (value) {
                            setState(() {
                              _emailNotifications = value;
                              if (!value) {
                                _promotionalEmails = false;
                                _storazaarUpdates = false;
                              }
                            });
                            _updateNotificationSettings(
                              emailNotifications: value,
                              promotionalEmails: value ? _promotionalEmails : false,
                              storazaarUpdates: value ? _storazaarUpdates : false,
                            );
                          },
                  ),

                  const SizedBox(height: 16),

                  // ...removed In-App Messages toggle...
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),

                  const Text(
                    'Notification Types',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 16),

                  // Order Updates
                  const SizedBox(height: 16),

                  // Store Updates
                  _buildNotificationToggle(
                    icon: Icons.store,
                    title: 'Storazaar Updates',
                    subtitle: 'Updates of the platform, UI, and bug fixes',
                    value: _storazaarUpdates,
                    onChanged: _loading
                        ? (value) {}
                        : (value) {
                            setState(() => _storazaarUpdates = value);
                            _updateNotificationSettings(storazaarUpdates: value);
                          },
                  ),

                  const SizedBox(height: 16),

                  // Promotional Emails
                  _buildNotificationToggle(
                    icon: Icons.local_offer,
                    title: 'Promotional Emails',
                    subtitle: 'Deals, offers, and marketing emails',
                    value: _promotionalEmails,
                    onChanged: (value) {
                      if (_loading) return;
                      setState(() => _promotionalEmails = value);
                      _updateNotificationSettings(promotionalEmails: value);
                    },
                  ),

                  const SizedBox(height: 40),

                  // Save Button
                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            await _updateNotificationSettings(
                              emailNotifications: _emailNotifications,
                              promotionalEmails: _promotionalEmails,
                              storazaarUpdates: _storazaarUpdates,
                              showFeedback: true,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildNotificationToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
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
    );
  }
}
