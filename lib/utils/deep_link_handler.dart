import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import '../screens/post_your_store/post_your_store_page.dart';

/// Handles incoming deep links and navigates to PostYourStorePage if the Stripe success URL is received.
class DeepLinkHandler extends StatefulWidget {
  final Widget child;
  const DeepLinkHandler({required this.child, Key? key}) : super(key: key);

  @override
  State<DeepLinkHandler> createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> {
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.toString().startsWith('https://storazaar.com/stripe-success-post-store')) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const PostYourStorePage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
