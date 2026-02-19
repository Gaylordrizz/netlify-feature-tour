import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'password_requirements_tracker.dart';

class CreateNewPasswordPage extends StatefulWidget {
  final String? accessToken;
  const CreateNewPasswordPage({Key? key, this.accessToken}) : super(key: key);

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}


class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  // No token needed; session is already active
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  // Password requirements state
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSymbol = false;
  bool _canSubmit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  void _updatePasswordRequirements(String value) {
    setState(() {
      _hasMinLength = value.length >= 8;
      _hasUppercase = value.contains(RegExp(r'[A-Z]'));
      _hasLowercase = value.contains(RegExp(r'[a-z]'));
      _hasNumber = value.contains(RegExp(r'[0-9]'));
      _hasSymbol = value.contains(RegExp(r'[-!@#\$%^&*(),.?":{}|<>\[\]\\/~`_=+;\x19]'));
    });
    _validateForm();
  }

  void _validateForm() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final valid = password.length >= 8 &&
        password == confirmPassword &&
        _hasUppercase && _hasLowercase && _hasNumber && _hasSymbol;
    setState(() {
      _canSubmit = valid;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Actually resets the user's password using the provided token and new password.
  // Called when the user submits the new password form.
  Future<bool> resetPassword() async {
    final newPassword = _passwordController.text;
    if (newPassword.isEmpty) {
      setState(() {
        _errorText = 'Missing password.';
      });
      print('[resetPassword] Missing password.');
      return false;
    }
    try {
      // Session is already active, just update the password
      final response = await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      print('[resetPassword] updateUser response: user=${response.user}');
      if (response.user != null) {
        // Clear Supabase session after successful password reset
        await Supabase.instance.client.auth.signOut();
        print('[resetPassword] Password reset successful.');
        return true;
      } else {
        setState(() {
          _errorText = 'Password reset FAILED.';
        });
        print('[resetPassword] Password reset FAILED.');
        return false;
      }
    } on AuthException catch (e) {
      setState(() {
        _errorText = 'Supabase error: ${e.message}';
      });
      print('[resetPassword] Supabase AuthException: ${e.message}');
      return false;
    } catch (e) {
      setState(() {
        _errorText = 'Error: $e';
      });
      print('[resetPassword] Unknown error: $e');
      return false;
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate() || !_canSubmit) return;
    setState(() { _isLoading = true; _errorText = null; });
    final success = await resetPassword();
    setState(() { _isLoading = false; });
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/password-changed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)], // pink to gold
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Lock icon at the top, centered
                      const Center(
                        child: Icon(Icons.lock, size: 48, color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Create New Password',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          labelStyle: const TextStyle(color: Colors.black),
                          hintText: 'New Password',
                          hintStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black, width: 2),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.black),
                            onPressed: () {
                              setState(() { _obscurePassword = !_obscurePassword; });
                            },
                          ),
                          errorText: _errorText,
                        ),
                        onChanged: _updatePasswordRequirements,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter a new password';
                          if (value.length < 8) return 'Password must be at least 8 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      // Live password requirements tracker
                      PasswordRequirementsTracker(
                        hasMinLength: _hasMinLength,
                        hasUppercase: _hasUppercase,
                        hasLowercase: _hasLowercase,
                        hasNumber: _hasNumber,
                        hasSymbol: _hasSymbol,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          labelStyle: const TextStyle(color: Colors.black),
                          hintText: 'Confirm New Password',
                          hintStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black, width: 2),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.black),
                            onPressed: () {
                              setState(() { _obscureConfirmPassword = !_obscureConfirmPassword; });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please confirm your new password';
                          if (value != _passwordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: (_isLoading || !_canSubmit) ? null : _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canSubmit ? Colors.blue : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Confirm new password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
