import '../../reusable_widgets/snackbar.dart';
import '../../services/loading_spinner.dart';
import 'package:flutter/material.dart';
import '../../reusable_widgets/header/global_header.dart';
import '../../reusable_widgets/sidebar/sidebar.dart';
import '../../services/search_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'password_requirements_tracker.dart';
import '../privacy_policy_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

// ...existing code...

class _AuthPageState extends State<AuthPage> {
      bool _showCheckEmail = false;
    // Password requirements state
    bool _hasMinLength = false;
    bool _hasUppercase = false;
    bool _hasLowercase = false;
    bool _hasNumber = false;
    bool _hasSymbol = false;

    void _checkPasswordRequirements(String password) {
      setState(() {
        _hasMinLength = password.length >= 8;
        _hasUppercase = password.contains(RegExp(r'[A-Z]'));
        _hasLowercase = password.contains(RegExp(r'[a-z]'));
        _hasNumber = password.contains(RegExp(r'[0-9]'));
        _hasSymbol = password.contains(RegExp(r'''[!@#\$%^&*(),.?":{}|<>\[\]\\\/;'`~_=+\-]'''));
      });
    }
  bool _isSignIn = true;
  final _formKey = GlobalKey<FormState>();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final supabase = Supabase.instance.client;
      if (_isSignIn) {
        // Sign In logic using Supabase (no email confirmation check)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: PageLoadingSpinner()),
        );
        supabase.auth
            .signInWithPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            )
            .then((response) {
          Navigator.of(context).pop(); // Remove loading dialog
          if (response.user != null) {
            if (response.user!.emailConfirmedAt == null) {
              showCustomSnackBar(
                context,
                'Please confirm your email before signing in.',
                positive: false,
              );
              return;
            }
            showCustomSnackBar(
              context,
              'Sign in successful!',
              positive: true,
            );
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
            });
          }
        });
      } else {
        // Sign Up logic with name as metadata
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: PageLoadingSpinner()),
        );
        await supabase.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          data: {
            'name': _nameController.text.trim(),
          },
        );
        Navigator.of(context).pop();
        setState(() {
          _showCheckEmail = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = SearchState();
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      drawer: const GlobalSidebarDrawer(),
      appBar: GlobalHeader(
        title: user != null ? "Account" : (_isSignIn ? 'Sign In' : 'Sign Up'),
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
        child: Center(
          child: _showCheckEmail
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 80, color: Colors.green),
                    SizedBox(height: 24),
                    Text(
                      'Check Your Email',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "We sent you a confirmation link to your email.",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : user != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified_user, size: 64, color: Colors.green),
                        const SizedBox(height: 16),
                        const Text(
                          "You're logged in!",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(user.email ?? '', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(child: PageLoadingSpinner()),
                            );
                            final logoutFuture = Supabase.instance.client.auth.signOut();
                            // Ensure spinner is visible for at least 1 second
                            await Future.wait([
                              logoutFuture,
                              Future.delayed(const Duration(seconds: 1)),
                            ]);
                            if (mounted) {
                              Navigator.of(context).pop(); // Remove spinner dialog
                              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                            }
                          },
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          'assets/storazaar_logo.png',
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        _isSignIn ? 'Log in' : 'Sign Up',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  if (!_isSignIn) ...[
                                    TextFormField(
                                      controller: _nameController,
                                      textCapitalization: TextCapitalization.words,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        labelText: 'Name',
                                        labelStyle: const TextStyle(color: Colors.black),
                                        floatingLabelStyle: const TextStyle(color: Colors.black),
                                        hintText: 'Enter your name',
                                        prefixIcon: const Icon(Icons.person),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: Colors.black, width: 2),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: const TextStyle(color: Colors.black),
                                      floatingLabelStyle: const TextStyle(color: Colors.black),
                                      hintText: 'Enter your email',
                                      prefixIcon: const Icon(Icons.email),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(color: Colors.black, width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    onChanged: (value) {
                                      _checkPasswordRequirements(value);
                                    },
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: const TextStyle(color: Colors.black),
                                      floatingLabelStyle: const TextStyle(color: Colors.black),
                                      hintText: 'Enter your password',
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(color: Colors.black, width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (!_hasMinLength || !_hasUppercase || !_hasLowercase || !_hasNumber || !_hasSymbol) {
                                        return 'Password does not meet all requirements';
                                      }
                                      return null;
                                    },
                                  ),
                                  if (!_isSignIn) ...[
                                    const SizedBox(height: 8),
                                    PasswordRequirementsTracker(
                                      hasMinLength: _hasMinLength,
                                      hasUppercase: _hasUppercase,
                                      hasLowercase: _hasLowercase,
                                      hasNumber: _hasNumber,
                                      hasSymbol: _hasSymbol,
                                    ),
                                  ],
                                  if (!_isSignIn) ...[
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _confirmPasswordController,
                                      obscureText: _obscureConfirmPassword,
                                      cursorColor: Colors.black,
                                      onChanged: (_) {
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Confirm Password',
                                        labelStyle: const TextStyle(color: Colors.black),
                                        floatingLabelStyle: const TextStyle(color: Colors.black),
                                        hintText: 'Re-enter your password',
                                        prefixIcon: const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureConfirmPassword = !_obscureConfirmPassword;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: Colors.black, width: 2),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please confirm your password';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                    if (_confirmPasswordController.text.isNotEmpty &&
                                        _confirmPasswordController.text == _passwordController.text)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 6, left: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.check_circle, color: Colors.green, size: 18),
                                            SizedBox(width: 6),
                                            Text(
                                              'Passwords match',
                                              style: TextStyle(fontSize: 13, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF228B22),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: Text(
                                      _isSignIn ? 'Sign In' : 'Sign Up',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _isSignIn
                                            ? "Don't have an account? "
                                            : "Already have an account? ",
                                        style: TextStyle(color: Colors.grey.shade600),
                                      ),
                                      TextButton(
                                        onPressed: _toggleMode,
                                        child: Text(
                                          _isSignIn ? 'Sign Up' : 'Sign In',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF228B22),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_isSignIn) ...[
                                    const SizedBox(height: 8),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/forgot-password');
                                        },
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                          mouseCursor: MaterialStateProperty.all(SystemMouseCursors.basic),
                                        ),
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                  ],
                                  if (!_isSignIn) ...[
                                    const SizedBox(height: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'By creating an account and/or using Storazaar,',
                                          style: TextStyle(fontSize: 13, color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                        Wrap(
                                          alignment: WrapAlignment.center,
                                          children: [
                                            const Text(
                                              'you agree to the ',
                                              style: TextStyle(fontSize: 13, color: Colors.black54),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context, '/settings/terms-conditions');
                                              },
                                              child: const Text(
                                                'Terms & Conditions',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 13,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              ' and ',
                                              style: TextStyle(fontSize: 13, color: Colors.black54),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const PrivacyPolicyPage(),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'Privacy Policy',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 13,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
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