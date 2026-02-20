import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/foundation.dart';
// ignore: unused_import
// import 'dart:html' as html; // Removed for platform compatibility
import '../../reusable_widgets/snackbar.dart';
import 'package:flutter/material.dart';
import '../../reusable_widgets/header/global_header.dart';
import '../../reusable_widgets/sidebar/sidebar.dart';
import '../../reusable_widgets/footer/page_footer.dart';
import '../../services/search_state.dart';
// import '../post_your_store/post_your_store_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
// import '../auth/auth_page.dart'; // Removed unused import


class SubscriptionPage extends StatefulWidget {
  SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}


class _SubscriptionPageState extends State<SubscriptionPage> {
  final GlobalKey _planTileKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  late final SearchState searchState;

  @override
  void initState() {
    super.initState();
    searchState = SearchState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const GlobalSidebarDrawer(),
      appBar: GlobalHeader(
        title: 'Store Owner Subscription',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/business_owner.jpg',
                            fit: BoxFit.cover,
                          ),
                          Container(color: Colors.black.withOpacity(0.25)),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.asset(
                                      'assets/storazaar_logo.png',
                                      height: 70,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  Text(
                                    'Ready for more customers?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 6,
                                          color: Colors.black.withOpacity(0.7),
                                          offset: Offset(0, 2),
                                        ),
                                        const Shadow(
                                          blurRadius: 0,
                                          color: Colors.black,
                                          offset: Offset(0.8, 0.8),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Post your online store, and get discovered by shoppers looking for stores like yours.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      height: 1.5,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 4,
                                          color: Colors.black.withOpacity(0.7),
                                          offset: Offset(0, 1.2),
                                        ),
                                        const Shadow(
                                          blurRadius: 0,
                                          color: Colors.black,
                                          offset: Offset(0.7, 0.7),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 44,
                                      color: Colors.white,
                                    ),
                                    tooltip: 'Scroll Down',
                                    onPressed: () {
                                      final contextTile = _planTileKey.currentContext;
                                      if (contextTile != null) {
                                        Scrollable.ensureVisible(
                                          contextTile,
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                          alignment: 0.1,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          color: const Color.fromARGB(255, 255, 251, 242),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              Widget subscriptionTile;
                              if (constraints.maxWidth < 700) {
                                subscriptionTile = Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 24.0),
                                        child: Container(
                                          key: _planTileKey,
                                          constraints: const BoxConstraints(maxWidth: 288),
                                          child: Column(
                                            children: [
                                              _buildPlanCard(
                                                context,
                                                'Store Owner Plan',
                                                0.00,
                                                [
                                                  '• Post your store on Storazaar',
                                                  '• Showcase up to 10 products',
                                                  '• Chat with a community of store owners',
                                                  '• Reach customers looking for your store',
                                                  '• Access a store backend with basic stats',
                                                  '• Add store info, contact, and social links',
                                                  '• Cancel anytime',
                                                  '• Subscribe for FREE for 2026',
                                                ],
                                                true,
                                              ),
                                              const SizedBox(height: 18),
                                              Container(
                                                constraints: const BoxConstraints(maxWidth: 288),
                                                margin: const EdgeInsets.only(top: 0, bottom: 18),
                                                child: Image.asset(
                                                  'assets/payment_options.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                    ],
                                  ),
                                );
                              } else {
                                subscriptionTile = Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 32),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.5 - 1,
                                            alignment: Alignment.topLeft,
                                            child: const Padding(
                                              padding: EdgeInsets.only(right: 32.0, top: 8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Let's get your products seen.",
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  SizedBox(height: 32),
                                                  Text(
                                                    'Welcome to Storazaar, the ultimate platform to showcase your online store and reach real customers. By subscribing, you can post your store, showcase up to 10 products, customize your store profile, and track store and product performance with simple analytics. Shoppers can visit your actual online store via a link button on your store profile.\n\nAs a special launch promotion, all store owners can subscribe for free for the entire 2026 calendar year. No matter when you join, your store and products can be listed, seen, and ready for customers until December 31, 2026. After that, you can automatically continue your subscription to keep reaching more buyers every month.',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87,
                                                      height: 1.7,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 32.0),
                                              child: Container(
                                                alignment: Alignment.topCenter,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      key: _planTileKey,
                                                      constraints: const BoxConstraints(maxWidth: 306),
                                                      child: _buildPlanCard(
                                                        context,
                                                        'Store Owner Plan',
                                                        0.00,
                                                        [
                                                          ' Post your store on Storazaar',
                                                          ' Showcase up to 10 products',
                                                          ' Chat with a community of store owners',
                                                          ' Reach customers looking for your store',
                                                          ' Access a store backend with basic stats',
                                                          ' Add store info, contact, and social links',
                                                          ' Cancel anytime',
                                                          ' Subscribe for FREE for 2026',
                                                        ],
                                                        true,
                                                      ),
                                                    ),
                                                    Container(
                                                      constraints: const BoxConstraints(maxWidth: 306),
                                                      margin: const EdgeInsets.only(top: 0, bottom: 18),
                                                      child: Image.asset(
                                                        'assets/payment_options.png',
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 40),
                                    ],
                                  ),
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  subscriptionTile,
                                  const SizedBox(height: 32),
                                  const PageFooter(),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    String title,
    double price,
    List<String> features,
    bool isPopular,
  ) {
    final user = Supabase.instance.client.auth.currentUser;
    final isLoggedIn = user != null;
    final now = DateTime.now();
    final isFreeYear = now.year == 2026;
    final displayPrice = isFreeYear ? 0.00 : 40.00;
    final priceText = isFreeYear
      ? 'until Jan 1, 2027 then \$40.00 USD/mo.'
      : 'per month (USD)';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: isPopular
              ? const Color.fromARGB(255, 255, 192, 203)
              : Colors.grey.shade300,
          width: isPopular ? 2.4 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 9.6,
            offset: const Offset(0, 3.2),
          ),
          BoxShadow(
            color: Colors.amber.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(12, 0),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12.8),
            decoration: BoxDecoration(
              gradient: isPopular
                  ? const LinearGradient(
                      colors: [
                        Color(0xFFFFC0CB),
                        Color(0xFFFFD700),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isPopular ? null : Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.8,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 9.6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      displayPrice.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      isFreeYear ? '/mo. USD' : '/mo. USD',
                      style: TextStyle(
                        fontSize: 12.8,
                        color: isPopular
                            ? Colors.black54
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.4),
                Text(
                  priceText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 9.6),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12.8),
                if (isLoggedIn)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                final user = Supabase.instance.client.auth.currentUser;
                                if (user == null) {
                                  showCustomSnackBar(context, 'User not logged in.', positive: false);
                                  return;
                                }
                                final session = Supabase.instance.client.auth.currentSession;
                                final jwt = session?.accessToken;
                                if (jwt == null) {
                                  showCustomSnackBar(context, 'Session token not available.', positive: false);
                                  return;
                                }
                                final now = DateTime.now();
                                final planId = now.year == 2026 ? 'free' : 'paid';
                                final body = {
                                  'user_id': user.id,
                                  'planId': planId,
                                };
                                final res = await Supabase.instance.client.functions.invoke(
                                  'create-checkout-session',
                                  body: body,
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer $jwt',
                                  },
                                );
                                final data = res.data;
                                // Match TS return keys
                                final String? checkoutUrl = data is Map ? data['url'] as String? : null;
                                // sessionId is available if needed: data['sessionId']
                                if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
                                  if (await canLaunchUrlString(checkoutUrl)) {
                                    await launchUrlString(
                                      checkoutUrl,
                                      mode: LaunchMode.externalApplication,
                                      webOnlyWindowName: '_self', // Prevent popup blocking on web
                                    );
                                  } else {
                                    showCustomSnackBar(context, 'Could not launch checkout URL.', positive: false);
                                  }
                                } else {
                                  showCustomSnackBar(context, 'Error: No URL returned from the function', positive: false);
                                }
                              } catch (err) {
                                showCustomSnackBar(context, 'Error starting checkout: $err', positive: false);
                              } finally {
                                if (mounted) {
                                  setState(() => _isLoading = false);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 11.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.6),
                        ),
                        elevation: 1.6,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Select Plan',
                              style: TextStyle(
                                fontSize: 12.8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 11.2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9.6),
                    ),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(text: 'Please '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/auth',
                                  );
                                },
                                child: const Text(
                                  'create an account',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: ' to post your store.'),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
