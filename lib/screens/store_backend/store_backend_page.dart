// ignore: unused_import
import '../../algorithem/algorithm_stat_boxes.dart' as stat_algo;
// ignore: unused_import
import '../../algorithem/algorithm_line_chart.dart' as chart_algo;

// --- Algorithm Integration Example ---
// Use stat_algo.computeStoreAnalytics and chart_algo.buildTimeSeries
// to compute analytics/stat box values and chart data for the store backend.
// See algorithm_stat_boxes.dart and algorithm_line_chart.dart for details.
import 'package:flutter/material.dart';
import 'package:flutter_application_1/reusable_widgets/sidebar/sidebar.dart';
import 'package:flutter_application_1/reusable_widgets/header/global_header.dart';
import 'edit_store_info_page.dart';
import 'manage_products_page.dart';
import 'line_chart_store_and_product.dart';
import 'package:flutter_application_1/reusable_widgets/snackbar.dart';

// Import the docs page
import '../storazaar_docs.dart/all_storazaar_docs.dart';

// Store Info Card widget
class _StoreInfoCard extends StatelessWidget {
  final List<_StatBoxInfo> statBoxes;
  final String storeName;
  final String domain;
  final String category;
  final int productsListed;

  const _StoreInfoCard({
    Key? key,
    required this.statBoxes,
    required this.storeName,
    required this.domain,
    required this.category,
    required this.productsListed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 320,
        maxWidth: double.infinity,
      ),
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Store Name:',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      storeName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.right,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1, color: Colors.white24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Domain:',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      domain,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.right,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1, color: Colors.white24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category:',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category[0].toUpperCase() + category.substring(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.right,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1, color: Colors.white24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products Listed:',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      productsListed.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.right,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 16),
          // Stat boxes removed: no impressions, clicks, visits, or days listed shown here
        ],
      ),
    );
  }
}

class _StatBoxInfo {
  final String label;
  final String value;
  _StatBoxInfo(this.label, this.value);
}

// StatBox widget for displaying stats
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatBox({
    Key? key,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Colors.grey[900]!, Colors.grey[900]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey[900]!,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Gradient button widget
class _GradientButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const _GradientButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)], // Pink to Gold
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.transparent, // Transparent so gradient shows
          elevation: 0,
        ),
        icon: Icon(icon, color: Colors.black),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class StoreBackendPage extends StatefulWidget {
  final int impressions;
  final int clicks;
  final int visits;
  final int daysOnStorazaar;
  final List<double> impressionsData;
  final List<double> clicksData;
  final List<double> visitsData;
  final List<double> daysOnStorazaarData;
  final List<String> productNames;
  final Map<String, List<double>> productImpressionsData;
  final Map<String, List<double>> productClicksData;
  final Map<String, List<double>> productDaysSincePostedData;
  final String storeName;
  final String domain;
  final String category;

  const StoreBackendPage({
    Key? key,
    required this.impressions,
    required this.clicks,
    required this.visits,
    required this.daysOnStorazaar,
    required this.impressionsData,
    required this.clicksData,
    required this.visitsData,
    required this.daysOnStorazaarData,
    required this.productNames,
    required this.productImpressionsData,
    required this.productClicksData,
    required this.productDaysSincePostedData,
    required this.storeName,
    required this.domain,
    required this.category,
  }) : super(key: key);

  @override
  State<StoreBackendPage> createState() => _StoreBackendPageState();
}

class _StoreBackendPageState extends State<StoreBackendPage> {
  bool _showStoreAnalytics = true;
  String _selectedMetric = 'Impressions';
  String? _selectedProduct;
  bool _productDropdownExpanded = false;
  bool _showAnalyticsOverlay = false;

  List<String> get _productNames => widget.productNames;

  List<_StatBoxInfo> get _statBoxes {
    if (_showStoreAnalytics) {
      // Always show 0 for all stat boxes by default
      return [
        _StatBoxInfo('Impressions', '0'),
        _StatBoxInfo('Clicks', '0'),
        _StatBoxInfo('Visits to Store', '0'),
        _StatBoxInfo('Days Listed', '0'),
      ];
    } else {
      // Show actual product analytics for selected product
      final product =
          _selectedProduct ??
          (_productNames.isNotEmpty ? _productNames.first : null);
      final impressions =
          product != null && widget.productImpressionsData[product] != null
          ? widget.productImpressionsData[product]!.last.toString()
          : '0';
      final clicks =
          product != null && widget.productClicksData[product] != null
          ? widget.productClicksData[product]!.last.toString()
          : '0';
      final days =
          product != null && widget.productDaysSincePostedData[product] != null
          ? widget.productDaysSincePostedData[product]!.last.toString()
          : '0';
      // Product Rating is still 0 (no data)
      return [
        _StatBoxInfo('Impressions', impressions),
        _StatBoxInfo('Clicks', clicks),
        _StatBoxInfo('Days', days),
        _StatBoxInfo('Product Rating', '0'),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const GlobalSidebarDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth <= 600;
            if (isNarrow) {
              // MOBILE VERSION: single column, scrollable, all widgets stacked vertically
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GlobalHeader(title: 'Store Backend'),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToggleButtons(
                            constraints: const BoxConstraints(
                              minHeight: 32,
                              minWidth: 120,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            fillColor: const Color(0xFFFFD700),
                            selectedColor: Colors.black,
                            color: Colors.white,
                            isSelected: [_showStoreAnalytics, !_showStoreAnalytics],
                            onPressed: (index) {
                              final switchingToProductAnalytics = index == 1 && _showStoreAnalytics;
                              setState(() {
                                _showStoreAnalytics = index == 0;
                                _selectedMetric = 'Impressions';
                                if (!_showStoreAnalytics && widget.productNames.isNotEmpty) {
                                  _selectedProduct ??= widget.productNames.first;
                                }
                              });
                              if (switchingToProductAnalytics && widget.productNames.isNotEmpty) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  showCustomSnackBar(
                                    context,
                                    'Scroll to the bottom and select product.',
                                    positive: true,
                                  );
                                });
                              }
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.0,
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  'Store Analytics',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.0,
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  'Product Analytics',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Tooltip(
                            message: 'Docs',
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllStorazaarDocsPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.menu_book_outlined,
                                    color: Colors.grey[300],
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _GradientButton(
                      text: 'Edit Store Info',
                      icon: Icons.edit,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditStoreInfoPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _GradientButton(
                      text: 'Manage Products',
                      icon: Icons.inventory,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageProductsPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Stat boxes in 2x2 grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: LayoutBuilder(
                        builder: (context, statConstraints) {
                          double spacing = 16.0;
                          double boxWidth = (statConstraints.maxWidth - spacing) / 2;
                          boxWidth = boxWidth.clamp(120.0, 220.0);
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: boxWidth,
                                    height: 120,
                                    child: _StatBox(
                                      label: _statBoxes[0].label,
                                      value: _statBoxes[0].value,
                                      isSelected: _selectedMetric == _statBoxes[0].label,
                                      onTap: () {
                                        setState(() {
                                          _selectedMetric = _statBoxes[0].label;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: spacing),
                                  SizedBox(
                                    width: boxWidth,
                                    height: 120,
                                    child: _StatBox(
                                      label: _statBoxes[1].label,
                                      value: _statBoxes[1].value,
                                      isSelected: _selectedMetric == _statBoxes[1].label,
                                      onTap: () {
                                        setState(() {
                                          _selectedMetric = _statBoxes[1].label;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: boxWidth,
                                    height: 120,
                                    child: _StatBox(
                                      label: _statBoxes[2].label,
                                      value: _statBoxes[2].value,
                                      isSelected: _selectedMetric == _statBoxes[2].label,
                                      onTap: () {
                                        setState(() {
                                          _selectedMetric = _statBoxes[2].label;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: spacing),
                                  SizedBox(
                                    width: boxWidth,
                                    height: 120,
                                    child: _StatBox(
                                      label: _statBoxes[3].label,
                                      value: _statBoxes[3].value,
                                      isSelected: _selectedMetric == _statBoxes[3].label,
                                      onTap: () {
                                        setState(() {
                                          _selectedMetric = _statBoxes[3].label;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Line chart parent widget
                    SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: ModernLineChart(
                        data: _getChartData(),
                        metricLabel: _selectedMetric,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Store Info Card
                    _StoreInfoCard(
                      statBoxes: _statBoxes,
                      storeName: widget.storeName,
                      domain: widget.domain,
                      category: widget.category,
                      productsListed: _productNames.length,
                    ),
                    const SizedBox(height: 16),
                    // Product dropdown (only for Product Analytics)
                    if (!_showStoreAnalytics)
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _productDropdownExpanded = !_productDropdownExpanded;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: _productNames.isNotEmpty ? Colors.grey[900] : Colors.grey[800],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _productNames.isNotEmpty ? (_selectedProduct ?? 'Select a product') : 'No products available',
                                      style: TextStyle(
                                        color: _productNames.isNotEmpty ? Colors.white : Colors.white54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    _productDropdownExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                    color: _productNames.isNotEmpty ? Colors.white : Colors.white54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_productDropdownExpanded && _productNames.isNotEmpty)
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(12),
                                ),
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 4,
                              ),
                              child: Column(
                                children: [
                                  for (final product in _productNames.take(10))
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedProduct = product;
                                          _productDropdownExpanded = false;
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _selectedProduct == product ? Colors.yellow[700] : Colors.grey[800],
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: _selectedProduct == product ? Colors.yellow : Colors.white24,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          product,
                                          style: TextStyle(
                                            color: _selectedProduct == product ? Colors.black : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }
            // WEB/DESKTOP VERSION: restore original layout
            final isWide = constraints.maxWidth > 900;
            final isMedium = constraints.maxWidth > 600 && constraints.maxWidth <= 900;
            final isHideAnalytics = constraints.maxWidth <= 700;
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalHeader(title: 'Store Backend'),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToggleButtons(
                            constraints: const BoxConstraints(
                              minHeight: 32,
                              minWidth: 120,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            fillColor: const Color(0xFFFFD700),
                            selectedColor: Colors.black,
                            color: Colors.white,
                            isSelected: [_showStoreAnalytics, !_showStoreAnalytics],
                            onPressed: (index) {
                              setState(() {
                                _showStoreAnalytics = index == 0;
                                _selectedMetric = 'Impressions';
                                if (!_showStoreAnalytics && widget.productNames.isNotEmpty) {
                                  _selectedProduct ??= widget.productNames.first;
                                }
                              });
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.0,
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  'Store Analytics',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.0,
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  'Product Analytics',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Tooltip(
                            message: 'Docs',
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllStorazaarDocsPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.menu_book_outlined,
                                    color: Colors.grey[300],
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 32.0 : 8.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column: buttons, store info, product dropdown
                            Expanded(
                              flex: 2,
                              child: Container(
                                constraints: isHideAnalytics
                                    ? const BoxConstraints(minWidth: 320)
                                    : null,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: isWide ? 24.0 : 8.0,
                                    left: isWide ? 24.0 : 0.0,
                                    right: isWide ? 24.0 : 0.0,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        _GradientButton(
                                          text: 'Edit Store Info',
                                          icon: Icons.edit,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const EditStoreInfoPage(),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        _GradientButton(
                                          text: 'Manage Products',
                                          icon: Icons.inventory,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const ManageProductsPage(),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        _StoreInfoCard(
                                          statBoxes: _statBoxes,
                                          storeName: widget.storeName,
                                          domain: widget.domain,
                                          category: widget.category,
                                          productsListed: _productNames.length,
                                        ),
                                        if (!_showStoreAnalytics)
                                          Column(
                                            children: [
                                              const SizedBox(height: 24),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _productDropdownExpanded = !_productDropdownExpanded;
                                                  });
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: _productNames.isNotEmpty ? Colors.grey[900] : Colors.grey[800],
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: Colors.white24,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 14,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _productNames.isNotEmpty ? (_selectedProduct ?? 'Select a product') : 'No products available',
                                                          style: TextStyle(
                                                            color: _productNames.isNotEmpty ? Colors.white : Colors.white54,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Icon(
                                                        _productDropdownExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                        color: _productNames.isNotEmpty ? Colors.white : Colors.white54,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (_productDropdownExpanded && _productNames.isNotEmpty)
                                                Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[900],
                                                    borderRadius: const BorderRadius.vertical(
                                                      bottom: Radius.circular(12),
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.white24,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: 4,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      for (final product in _productNames.take(10))
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _selectedProduct = product;
                                                              _productDropdownExpanded = false;
                                                            });
                                                          },
                                                          child: Container(
                                                            width: double.infinity,
                                                            margin: const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 16,
                                                              vertical: 12,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              color: _selectedProduct == product ? Colors.yellow[700] : Colors.grey[800],
                                                              borderRadius: BorderRadius.circular(8),
                                                              border: Border.all(
                                                                color: _selectedProduct == product ? Colors.yellow : Colors.white24,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              product,
                                                              style: TextStyle(
                                                                color: _selectedProduct == product ? Colors.black : Colors.white,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 14,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
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
                            // Right column: stat boxes and line chart
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: isWide ? 0.0 : 0.0,
                                  right: isWide ? 0.0 : 0.0,
                                  top: isWide ? 24.0 : 16.0,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      if (!isHideAnalytics)
                                        Column(
                                          children: [
                                            LayoutBuilder(
                                              builder: (context, statConstraints) {
                                                int statCount = _statBoxes.length;
                                                double minBoxWidth = 140.0;
                                                double maxBoxWidth = 260.0;
                                                double spacing = 16.0;
                                                double availableWidth = statConstraints.maxWidth - spacing;
                                                int perRow = isMedium ? 2 : 4;
                                                double boxWidth = ((availableWidth - (spacing * (perRow - 1))) / perRow).clamp(minBoxWidth, maxBoxWidth);
                                                return Wrap(
                                                  spacing: spacing,
                                                  runSpacing: spacing,
                                                  children: [
                                                    for (int i = 0; i < statCount; i++)
                                                      SizedBox(
                                                        width: boxWidth,
                                                        height: 140,
                                                        child: _StatBox(
                                                          label: _statBoxes[i].label,
                                                          value: _statBoxes[i].value,
                                                          isSelected: _selectedMetric == _statBoxes[i].label,
                                                          onTap: () {
                                                            setState(() {
                                                              _selectedMetric = _statBoxes[i].label;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 24),
                                            SizedBox(
                                              width: double.infinity,
                                              height: (constraints.maxHeight * 0.45).clamp(120.0, 500.0),
                                              child: ModernLineChart(
                                                data: _getChartData(),
                                                metricLabel: _selectedMetric,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (isHideAnalytics)
                                        Center(
                                          child: IconButton(
                                            icon: const Icon(Icons.analytics, color: Colors.yellow, size: 48),
                                            tooltip: 'Show Analytics',
                                            onPressed: () {
                                              setState(() {
                                                _showAnalyticsOverlay = true;
                                              });
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_showAnalyticsOverlay)
                  LayoutBuilder(
                    builder: (context, popupConstraints) {
                      return AnimatedSlide(
                        offset: _showAnalyticsOverlay ? Offset(0, 0) : Offset(0, 1),
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                        child: AnimatedOpacity(
                          opacity: _showAnalyticsOverlay ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 350),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Material(
                              color: Colors.black,
                              child: Container(
                                width: popupConstraints.maxWidth,
                                height: popupConstraints.maxHeight,
                                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.close, color: Colors.white, size: 32),
                                            tooltip: 'Close',
                                            onPressed: () {
                                              setState(() {
                                                _showAnalyticsOverlay = false;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Stat boxes in a 2x2 grid (square)
                                      LayoutBuilder(
                                        builder: (context, statConstraints) {
                                          double spacing = 16.0;
                                          double boxWidth = (statConstraints.maxWidth - spacing) / 2;
                                          boxWidth = boxWidth.clamp(120.0, 220.0);
                                          double gridWidth = (boxWidth * 2) + spacing;
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: boxWidth,
                                                      height: 120,
                                                      child: _StatBox(
                                                        label: _statBoxes[0].label,
                                                        value: _statBoxes[0].value,
                                                        isSelected: _selectedMetric == _statBoxes[0].label,
                                                        onTap: () {
                                                          setState(() {
                                                            _selectedMetric = _statBoxes[0].label;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: spacing),
                                                    SizedBox(
                                                      width: boxWidth,
                                                      height: 120,
                                                      child: _StatBox(
                                                        label: _statBoxes[1].label,
                                                        value: _statBoxes[1].value,
                                                        isSelected: _selectedMetric == _statBoxes[1].label,
                                                        onTap: () {
                                                          setState(() {
                                                            _selectedMetric = _statBoxes[1].label;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: boxWidth,
                                                      height: 120,
                                                      child: _StatBox(
                                                        label: _statBoxes[2].label,
                                                        value: _statBoxes[2].value,
                                                        isSelected: _selectedMetric == _statBoxes[2].label,
                                                        onTap: () {
                                                          setState(() {
                                                            _selectedMetric = _statBoxes[2].label;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: spacing),
                                                    SizedBox(
                                                      width: boxWidth,
                                                      height: 120,
                                                      child: _StatBox(
                                                        label: _statBoxes[3].label,
                                                        value: _statBoxes[3].value,
                                                        isSelected: _selectedMetric == _statBoxes[3].label,
                                                        onTap: () {
                                                          setState(() {
                                                            _selectedMetric = _statBoxes[3].label;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),
                                                // Line chart parent widget, same width as stat box grid
                                                SizedBox(
                                                  width: gridWidth,
                                                  height: 180,
                                                  child: ModernLineChart(
                                                    data: _getChartData(),
                                                    metricLabel: _selectedMetric,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                // End of if (_showAnalyticsOverlay)
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper to get chart data based on selected metric
  List<double> _getChartData() {
    if (_showStoreAnalytics) {
      switch (_selectedMetric) {
        case 'Impressions':
          return widget.impressionsData;
        case 'Clicks':
          return widget.clicksData;
        case 'Visits to Store':
          return widget.visitsData;
        case 'Days on Storazaar':
          return widget.daysOnStorazaarData;
        default:
          return [];
      }
    } else {
      final product =
          _selectedProduct ??
          (_productNames.isNotEmpty ? _productNames.first : null);
      if (product == null) return [];
      switch (_selectedMetric) {
        case 'Impressions':
          return widget.productImpressionsData[product] ?? [];
        case 'Clicks':
          return widget.productClicksData[product] ?? [];
        case 'Days Since Posted':
          return widget.productDaysSincePostedData[product] ?? [];
        default:
          return [];
      }
    }
  }
}
