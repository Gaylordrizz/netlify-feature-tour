import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// ignore: unused_import
import '../../algorithem/algorithm_line_chart.dart' as chart_algo;

class ModernLineChart extends StatelessWidget {
  final List<double> data;
  final String metricLabel;

  const ModernLineChart({
    super.key,
    required this.data,
    required this.metricLabel,
  });

  // --- Algorithm Integration Example ---
  // Use chart_algo.buildTimeSeries to generate data for this chart.
  // See algorithm_line_chart.dart for details.

  @override
  Widget build(BuildContext context) {
    final minY = data.isNotEmpty ? data.reduce((a, b) => a < b ? a : b).toDouble() : 0.0;
    final maxY = data.isNotEmpty ? data.reduce((a, b) => a > b ? a : b).toDouble() : 10.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$metricLabel Last 30 Days',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 130,
                    width: (data.length > 10 ? data.length * 32.0 : constraints.maxWidth),
                    child: data.isEmpty
                        ? Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : LineChart(
                            LineChartData(
                              minY: minY,
                              maxY: maxY,
                              backgroundColor: Colors.grey[900],
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          value.toStringAsFixed(0),
                                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval: 5,
                                    getTitlesWidget: (value, meta) {
                                      if (value % 5 == 0 && value >= 0 && value < data.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 6.0),
                                          child: Text(
                                            (value.toInt() + 1).toString(),
                                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              lineTouchData: LineTouchData(
                                handleBuiltInTouches: true,
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipMargin: 12,
                                  tooltipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      final day = spot.x.toInt() + 1;
                                      final value = spot.y.toStringAsFixed(0);
                                      return LineTooltipItem(
                                        'Day $day: $value $metricLabel',
                                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                      );
                                    }).toList();
                                  },
                                ),
                                getTouchedSpotIndicator: (barData, spotIndexes) {
                                  return spotIndexes.map((index) {
                                    return TouchedSpotIndicatorData(
                                      FlLine(color: Colors.blueAccent, strokeWidth: 2),
                                      FlDotData(
                                        show: true,
                                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                          radius: 7,
                                          color: Colors.blueAccent,
                                          strokeWidth: 2,
                                          strokeColor: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i])),
                                  isCurved: false, // spiky line
                                  color: Colors.blueAccent,
                                  barWidth: 4,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
