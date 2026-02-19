import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show OtpType;
import '../../reusable_widgets/snackbar.dart';
class CheckEmailPage extends StatefulWidget {
  const CheckEmailPage({super.key});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
    bool _isResending = false;

    Future<void> _resendCode() async {
      if (_email == null) return;
      setState(() { _isResending = true; });
      try {
        await Supabase.instance.client.auth.resetPasswordForEmail(_email!);
        showCustomSnackBar(context, 'A new code has been sent to your email.', positive: true);
        print('[resendCode] Password reset code sent to $_email');
      } catch (e) {
        _showError('Error resending code: ${e.toString()}');
        print('[resendCode] Error: $e');
      } finally {
        setState(() { _isResending = false; });
      }
    }
  final TextEditingController _codeController = TextEditingController();
  bool _isValidCode = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_validateCode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _email = args;
    }
  }

  void _validateCode() {
    setState(() {
      // Accept any non-empty code (Supabase may send 6, 8, or other lengths)
      _isValidCode = _codeController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submitCode() async {
    if (!_isValidCode || _email == null) return;
    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        type: OtpType.recovery,
        token: _codeController.text.trim(),
        email: _email!,
      );
      if (response.session != null && response.session!.accessToken.isNotEmpty) {
        // Session is now active, user is authenticated
        Navigator.pushReplacementNamed(
          context,
          '/create-new-password',
        );
        print('[submitCode] OTP verified and session created for $_email');
      } else {
        _showError('Invalid or expired code.');
        print('[submitCode] Invalid or expired code for $_email');
      }
    } on AuthException catch (e) {
      _showError('Supabase error: ${e.message}');
      print('[submitCode] Supabase AuthException: ${e.message}');
    } catch (e) {
      _showError('Error verifying code: ${e.toString()}');
      print('[submitCode] Unknown error: $e');
    }
  }

  void _showError(String message) {
    showCustomSnackBar(context, message, positive: false);
  }

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
            child: Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 36.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, size: 80, color: Colors.green),
                    const SizedBox(height: 32),
                    const Text(
                      'Check Your Email',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'If an account exists for this email, \n a one time code has been sent to your email.\nPlease check your spam folder if you do not see it in your inbox.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (_email != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Email: $_email',
                          style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    // OTP code entry bar for any length code
                    Container(
                      width: 420, // Wider for long codes
                      child: TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                          fontSize: 20, // Slightly smaller for compactness
                          letterSpacing: 4,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          // No hintText or hintStyle
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16), // Much less tall
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 160,
                      child: ElevatedButton(
                        onPressed: _isValidCode ? _submitCode : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isValidCode ? Colors.blue : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        const Text(
                          "Didn't get a code?",
                          style: TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: (_isResending || _email == null) ? null : _resendCode,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              _isResending ? 'Resending...' : 'Resend Code',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
