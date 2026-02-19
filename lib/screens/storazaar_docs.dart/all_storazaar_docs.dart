import 'package:flutter/material.dart';

class AllStorazaarDocsPage extends StatefulWidget {
  const AllStorazaarDocsPage({super.key});

  @override
  State<AllStorazaarDocsPage> createState() => _AllStorazaarDocsPageState();
}

class _AllStorazaarDocsPageState extends State<AllStorazaarDocsPage> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = [GlobalKey(), GlobalKey(), GlobalKey(), GlobalKey()];
  int _highlightedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    for (int i = 0; i < _sectionKeys.length; i++) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final offset = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
        if (offset.dy <= 120) {
          if (_highlightedIndex != i) {
            setState(() {
              _highlightedIndex = i;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            title: isMobile
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).maybePop(),
                        tooltip: 'Back',
                      ),
                      const Text(
                        'Storazaar Docs',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.black),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          tooltip: 'Open navigation',
                        ),
                      ),
                    ],
                  )
                : const Text(
                    'Storazaar Docs',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
            centerTitle: !isMobile,
            leading: null, // handled in title for mobile
            actions: null, // handled in title for mobile
          ),
          drawer: isMobile
              ? Drawer(
                  child: SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 0),
                      children: [
                        _buildNavItem('How to Post and Optimize Your Store', 0, closeDrawer: true),
                        _buildNavItem('How to Post and Optimize Products', 1, closeDrawer: true),
                        _buildNavItem('Storazaar Subscription Guide', 2, closeDrawer: true),
                        _buildNavItem('Storazaar Analytics Guide', 3, closeDrawer: true),
                      ],
                    ),
                  ),
                )
              : null,
          body: isMobile
              ? SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        key: _sectionKeys[0],
                        title: 'How to Post and Optimize Your Store on Storazaar',
                        content: _storeDocContent(),
                      ),
                      _buildSection(
                        key: _sectionKeys[1],
                        title: 'How to Post and Optimize Products on Storazaar',
                        content: _productsDocContent(),
                      ),
                      _buildSection(
                        key: _sectionKeys[2],
                        title: 'Storazaar Subscription Guide',
                        content: _subscriptionDocContent(),
                      ),
                      _buildSection(
                        key: _sectionKeys[3],
                        title: 'Storazaar Analytics Guide',
                        content: _analyticsDocContent(),
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    // Left navigation panel
                    Container(
                      width: 220,
                      color: Colors.grey[100],
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 0),
                        children: [
                          _buildNavItem('How to Post and Optimize Your Store', 0),
                          _buildNavItem('How to Post and Optimize Products', 1),
                          _buildNavItem('Storazaar Subscription Guide', 2),
                          _buildNavItem('Storazaar Analytics Guide', 3),
                        ],
                      ),
                    ),
                    // Main content area
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSection(
                              key: _sectionKeys[0],
                              title: 'How to Post and Optimize Your Store on Storazaar',
                              content: _storeDocContent(),
                            ),
                            _buildSection(
                              key: _sectionKeys[1],
                              title: 'How to Post and Optimize Products on Storazaar',
                              content: _productsDocContent(),
                            ),
                            _buildSection(
                              key: _sectionKeys[2],
                              title: 'Storazaar Subscription Guide',
                              content: _subscriptionDocContent(),
                            ),
                            _buildSection(
                              key: _sectionKeys[3],
                              title: 'Storazaar Analytics Guide',
                              content: _analyticsDocContent(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildNavItem(String title, int index, {bool closeDrawer = false}) {
    final isActive = _highlightedIndex == index;
    return InkWell(
      onTap: () {
        final ctx = _sectionKeys[index].currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
        }
        if (closeDrawer) Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        // No background or border radius for highlight
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.black,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required Key key, required String title, required List<Widget> content}) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black)),
          const SizedBox(height: 16),
          ...content,
        ],
      ),
    );
  }

  List<Widget> _storeDocContent() => const [
    Text(
      'Welcome to Storazaar, the platform designed to help you showcase, sell, and promote your store with ease. This guide will walk you through posting your store, optimizing it for maximum visibility, and ensuring it attracts the right customers.',
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 24),
    Text('1. Preparing Your Store for Posting', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Before you even open Storazaar, take a moment to prepare your store’s content. The more polished and complete your listing, the better your visibility and appeal.', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 8),
    Text('Essential Elements to Prepare:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Store Name – Choose a memorable, relevant name that reflects your brand or the type of products you offer.\n\nLogo & Images – High-quality images of your storefront, products, and logo. Clear, bright visuals capture attention and build trust.\n\nDescription – A compelling summary of your store. Highlight your unique selling points, product range, and what sets you apart.\n\nContact & Location Info – Ensure phone numbers, email, website, and physical address (if applicable) are accurate.\n\nCategory & Tags – Identify the main category of your store (e.g., electronics, fashion, home goods) and relevant tags to improve searchability.\n\nSocial Media Links – Add Instagram, Facebook, TikTok, or other social links to allow users to explore your brand further.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('2. Posting Your Store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Once you’ve prepared your materials, follow these steps to post your store:', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 8),
    Text('Step-by-Step Posting Guide:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Log In or Create an Account – Use your Storazaar account to access the store management panel.\n\nNavigate to “Create a Store” – Typically found in the dashboard or main menu.\n\nFill Out Store Details – Input all essential information:\n  • Store name\n  • Description\n  • Category & tags\n  • Contact info\n\nUpload Images – Include your logo and store/product images. Aim for a mix of professional and lifestyle shots.\n\nAdd Social Links & Website – Helps users follow your brand and drives external traffic.\n\nSet Operational Details – Hours, shipping options, payment methods, or appointment availability.\n\nPreview Your Store – Always check how your listing looks to visitors. Adjust text or images for readability and visual appeal.\n\nPublish – Once satisfied, click “Publish” to make your store live on Storazaar.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('3. Optimizing Your Store for Maximum Visibility', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('A great listing is only half the battle. Optimization ensures your store gets noticed by users searching for products like yours.', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 8),
    Text('Tips for SEO and Discoverability:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Use Keywords in Your Description – Include the products you sell and terms customers might search for.\n\nCategorize Correctly – Make sure your store is in the correct category to reach the right audience.\n\nAdd Tags – Tags improve search matching and help users find your store organically.\n\nUpdate Frequently – Keep your store info, images, and product offerings up to date. Active stores get higher visibility.\n\nEncourage Reviews – Customer reviews build credibility and increase engagement.\n\nLink Social Media – Drives traffic and strengthens your store’s online presence.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('4. Showcasing Your Store Effectively', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Presentation matters. How your store looks can influence a visitor’s decision to explore further or make a purchase.', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 8),
    Text('Visual Best Practices:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('High-Resolution Images – Avoid blurry or low-quality visuals. Use consistent lighting and style.\n\nOrganized Layout – Group products logically and make navigation intuitive.\n\nHighlight Key Products – Feature bestsellers or unique items at the top.\n\nBranding Consistency – Keep colors, fonts, and style consistent with your overall brand.\n\nInclude Lifestyle Images – Show products in use to help customers visualize them.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 12),
    Text('Content Best Practices:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Engaging Description – Use storytelling to make your store memorable.\n\nClear Calls to Action – Encourage visitors to “Shop Now,” “Follow,” or “Contact.”\n\nDetailed Product Info – Include sizes, materials, colors, and any special features.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('5. Maintaining Your Store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('A posted store isn’t static. Regular maintenance keeps your listing fresh, relevant, and attractive to new visitors.', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 8),
    Text('Maintenance Checklist:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Update product images and descriptions regularly.\n\nRespond promptly to inquiries or reviews.\n\nAdd seasonal promotions or new collections.\n\nMonitor analytics to see which products or images attract the most attention.\n\nRefresh tags and keywords to stay relevant in searches.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('6. Tips for Long-Term Success on Storazaar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Be Consistent – Consistency in posting and branding builds recognition.\n\nEngage with Customers – Answer questions and interact with followers to foster loyalty.\n\nExperiment with Content – Try different types of images, descriptions, and promotions to see what resonates.\n\nLeverage Social Proof – Encourage satisfied customers to leave reviews and share your store on social media.\n\nTrack Performance – Use Storazaar analytics (if available) to refine your approach and optimize for conversions.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('Conclusion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Posting a store on Storazaar is more than just filling out a form—it’s about presenting your brand in the best possible light, optimizing for visibility, and engaging with your audience. By following these steps, you can create a store that attracts attention, builds trust, and drives growth.\n\nRemember: A great store is a living store. Keep it updated, polished, and aligned with your brand to maximize your success on Storazaar.', style: TextStyle(fontSize: 16, color: Colors.black)),
  ];

  List<Widget> _productsDocContent() => const [
    Text(
      'Posting products effectively on Storazaar is key to driving visibility, attracting customers, and making sales. A well-presented product listing can make all the difference. This guide will take you step by step through posting, optimizing, and showcasing your products.',
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 24),
    Text('1. Preparing Your Product Listing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Before you log in to Storazaar, prepare all the materials you’ll need. The more complete and high-quality your listing, the more attractive it will be to potential customers.', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 8),
    Text('Essential Materials to Gather:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Product Name – Clear, descriptive, and searchable. Include brand or style if relevant.\n\nProduct Images – High-resolution photos from multiple angles. Lifestyle images (products in use) are highly recommended. (Maximum of 5 photos per product).\n\nDescription – Detailed and persuasive. Include materials, size, color, features, and benefits.\n\nPrice – Set a competitive and realistic price.\n\nInventory Information – Stock quantity, variants, or sizes available.\n\nTags & Categories – Select the right category and use descriptive tags to improve searchability.\n\nShipping or Delivery Info – Options, costs, and estimated delivery times.\n\nSKU or Product ID (if applicable) – Helps with inventory management.\n\nNote: Each store can post a maximum of 10 products on Storazaar. Plan strategically which products will showcase your store best.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('2. Posting Your Product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Once your materials are ready, follow these steps:', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 8),
    Text('Step-by-Step Product Posting Guide:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Log In to Storazaar – Access your store dashboard.\n\nGo to “Add Product” – Usually located in the store management panel.\n\nEnter Product Details:\n  • Product Name – Keep it clear and keyword-rich.\n  • Description – Provide all necessary details. Use bullet points for clarity.\n  • Price & Inventory – Set price, stock, and any variant options (size, color, etc.).\n  • Select Category & Tags – Choose the most relevant category and tags for discoverability.\n\nUpload Product Images – Include high-quality main image plus additional images showing different angles or usage. (Limit 5 images per product.)\n\nSet Shipping Options – Indicate shipping costs, delivery time, and regions.\n\nPreview Your Listing – Check how your product will appear to customers. Adjust images or text for readability and visual appeal.\n\nPublish – Once satisfied, click “Publish” to make the product live.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('3. Optimizing Your Product Listings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Optimized listings increase visibility, attract more clicks, and improve conversions.', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 8),
    Text('Optimization Tips:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Use Keywords in Product Name & Description – Think about what customers would search for.\n\nInclude High-Quality Images – Sharp, bright, well-lit photos increase engagement.\n\nHighlight Unique Features – Show why your product stands out.\n\nUse Tags Strategically – Include relevant search terms and common synonyms.\n\nUpdate Regularly – Keep product info, images, and stock levels up to date.\n\nEncourage Reviews – Positive customer feedback improves credibility and visibility.\n\nOffer Clear Shipping Info – Transparent shipping options reduce hesitation.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('4. Showcasing Products Effectively', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('How your product looks and is described can make a huge difference in sales.', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 8),
    Text('Visual Best Practices:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Main Image First – Should be clear and eye-catching; often determines click-through rate.\n\nMultiple Angles – Include front, back, side, close-up, and lifestyle images. (Maximum 5 images per product.)\n\nConsistent Style – Maintain brand consistency in lighting, background, and presentation.\n\nZoom & Detail – Ensure images allow customers to see texture or fine details.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 12),
    Text('Description Best Practices:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Lead with Key Selling Points – Include the most important features in the first few lines.\n\nBe Honest & Accurate – Avoid exaggeration; set correct expectations.\n\nUse Bullet Points – Makes information scannable and easy to read.\n\nInclude Size & Material Info – Crucial for clothing, furniture, or product variants.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('5. Managing Your Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Posting is just the beginning. Active management ensures your products remain relevant and visible.', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 8),
    Text('Product Management Checklist:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Update stock levels regularly.\n\nRefresh images or descriptions seasonally or with new trends.\n\nTrack product performance using Storazaar analytics (clicks, favorites, sales).\n\nRespond to customer inquiries promptly.\n\nPromote top-selling or seasonal items to keep traffic high.\n\nRemember: You can only post up to 10 products per store. Plan which products showcase your store best and rotate or update them strategically.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('6. Tips for Long-Term Success', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Consistency is Key – Regularly post new products or refresh existing ones within your 10-product limit.\n\nEngage With Customers – Answer questions, accept feedback, and build relationships.\n\nLeverage Promotions – Discounts, bundles, or seasonal offers attract buyers.\n\nUse Social Media – Share your Storazaar products to drive external traffic.\n\nMonitor Trends – Stay aware of customer preferences and competitor offerings.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('Conclusion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Posting products on Storazaar isn’t just about listing items—it’s about creating compelling, well-presented offerings that attract customers and drive sales. From preparation to optimization and ongoing management, each step contributes to your store’s success.\n\nRemember: Each store can post up to 10 products, with up to 5 images per product. Make every product count by presenting it clearly, attractively, and accurately.', style: TextStyle(fontSize: 16, color: Colors.black)),
  ];

  List<Widget> _subscriptionDocContent() => const [
    Text(
      'Storazaar is committed to providing an accessible and valuable platform for both store owners and customers. This guide explains how subscriptions work, what features are included, and important billing details.',
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 24),
    Text('1. Free Access for 2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('To be fair to customers and store owners, Storazaar is completely free for the entire calendar year of 2026.\n\nAll users in 2026 have full access to the platform without paying.\n\nEven though the service is free, subscribers will still receive email receipts, including receipts showing a \$0.00 amount.\n\nFree access includes the ability to post your store, upload images, add social media links, and list products.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('2. Subscription Features', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Starting in 2027, Storazaar will offer a paid subscription plan. Subscribers will receive full access to all store posting features, including:', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 8),
    Text('Store Information – Name, description, location, and contact info.\n\nStore Photos – Upload high-quality images to showcase your store.\n\nSocial Media Links – Connect Instagram, Facebook, TikTok, or other channels.\n\nProducts –\n  • List up to 10 products per store.\n  • Upload up to 5 images per product.\n  • Include product descriptions, pricing, and shipping info.\n\nPricing & Shipping – Full control over pricing, discounts, shipping costs, and delivery options.\n\nDetailed Descriptions – Add clear, engaging descriptions to showcase your products and store.\n\nSubscribers will have the tools to fully optimize their store for visibility, engagement, and sales.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('3. Subscription Pricing and Billing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Monthly Fee: \$40 USD per month.\n\nBilling Start Date: January 1st, 2027 at 12:00 AM.\n\n2026 Access: Free for all users. Even though no payment is due, Storazaar will send receipts for \$0.00 for transparency and recordkeeping.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 8),
    Text('Important Billing Notes:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('The subscription is automatic and recurring monthly once active.\n\nUsers will be emailed receipts for every billing cycle, whether the amount is \$0.00 (during free access in 2026) or \$40 USD/month starting in 2027.\n\nBilling information and subscription management will be accessible via your Storazaar account dashboard.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('4. Getting the Most from Your Subscription', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('To maximize your subscription benefits:', style: TextStyle(fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Complete Your Store Profile – Add your store name, description, contact info, and social media links.\n\nPost Products Strategically – Utilize the full allowance of 10 products and 5 photos per product to showcase your best offerings.\n\nOptimize for Visibility – Use clear, keyword-rich descriptions and high-quality images.\n\nKeep Information Up-to-Date – Update pricing, shipping info, and product availability regularly.\n\nMonitor Performance – Track clicks, favorites, and sales to adjust your listings and improve engagement.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('5. Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('2026: Free full access to all features. \$0.00 receipts sent for transparency.\n\n2027 Onward: Monthly subscription of \$40 USD/month begins on Jan 1, 12:00 AM.\n\nSubscription Benefits: Full store posting, product posting, social media linking, pricing, shipping info, and image uploads.\n\nProduct Limits: Maximum of 10 products per store, with up to 5 images per product.\n\nStorazaar is designed to give store owners everything they need to showcase their store professionally, grow their brand, and reach customers effectively.', style: TextStyle(fontSize: 15, color: Colors.black)),
  ];

  List<Widget> _analyticsDocContent() => const [
    Text(
      'Storazaar provides powerful analytics tools to help store owners track performance, understand customer engagement, and make data-driven decisions. This guide explains how to use the analytics dashboard, interpret stats, and manage your store and products effectively.',
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
    SizedBox(height: 24),
    Text('1. Overview of Analytics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('The Storazaar Analytics Dashboard is divided into two main sections:\n\nStore Analytics – Tracks overall performance of your store.\n\nProduct Analytics – Tracks the performance of individual products.\n\nAll analytics are automatically updated to show the latest accurate data, giving you a real-time view of your store’s activity.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('2. Store Analytics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Features:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Stat Boxes – Key metrics for your store at a glance:\n\nImpressions – The number of times your store appeared in search results or user feeds.\n\nClicks – How many times users clicked on your store.\n\nVisits to Store – The number of users who viewed your store page.\n\nDays Listed – How long your store has been active on Storazaar.\n\nLine Chart – Displays trends over time for the selected stat box. When you select a stat box, the chart updates to show how that metric has changed daily, weekly, or monthly.\n\nToggle Between Store and Product Analytics – Quickly switch between analyzing your store as a whole or focusing on specific products.\n\nEdit Store Info Button – Directs you to the page where you can update store name, description, images, social links, and other details.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('3. Product Analytics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Features:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Select Product to Analyze – Choose any product from your store to view detailed analytics.\n\nStat Boxes – Key metrics for the selected product:\n\nImpressions – Number of times the product appeared in search results or feeds.\n\nClicks – Number of times users clicked on the product.\n\nDays Listed – How long the product has been active on Storazaar.\n\nProduct Rating Avg – The average rating given by customers.\n\nLine Chart – Updates based on the selected stat box to show how the metric has changed over time. This allows you to quickly identify trends and performance patterns.\n\nManage Product Button – Direct link to the page where you can edit product details, update images, adjust pricing, or manage shipping info.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('4. How to Use the Analytics Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Step-by-Step Instructions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
    SizedBox(height: 4),
    Text('Access Analytics – From your store dashboard, click “Analytics.”\n\nSelect Analytics Type – Use the toggle to switch between Store Analytics and Product Analytics.\n\nView Stat Boxes – Review key metrics at a glance. Click on any stat box to update the line chart below.\n\nInterpret the Line Chart – Each stat box selection shows trends over time. Use this to track growth, identify dips in engagement, or analyze patterns.\n\nAnalyze Products – When in Product Analytics, select a specific product from the list to view detailed stats.\n\nTake Action – Use the Edit Store Info or Manage Product buttons to make improvements based on analytics insights.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('5. Tips for Maximizing Analytics Insights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('Monitor Impressions vs Clicks – High impressions but low clicks may indicate your store or product listing could use stronger visuals or descriptions.\n\nTrack Visits to Store – This metric helps you understand overall interest in your store.\n\nReview Product Ratings – Identify highly-rated products to promote, or low-rated ones to improve.\n\nCompare Metrics Over Time – Use the line chart to spot trends and adjust marketing, descriptions, or product offerings accordingly.\n\nUse Analytics to Prioritize Updates – Focus on products or sections of your store that show lower engagement for improvements.', style: TextStyle(fontSize: 15, color: Colors.black)),
    SizedBox(height: 24),
    Text('6. Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    SizedBox(height: 8),
    Text('The Storazaar Analytics Dashboard provides everything you need to monitor, understand, and improve your store and products:\n\nStore Analytics: Impressions, clicks, visits, days listed\n\nProduct Analytics: Impressions, clicks, days listed, product rating average\n\nLine charts show trends over time for each metric\n\nButtons to edit store info or manage products make improvements fast\n\nFully automated updates ensure you always have the latest true data\n\nAnalytics empowers store owners to make data-driven decisions, optimize visibility, and maximize engagement on Storazaar.', style: TextStyle(fontSize: 15, color: Colors.black)),
  ];
}
