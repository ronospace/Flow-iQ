import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

/// Reusable chart widgets for analytics dashboard
class AnalyticsChartWidget extends StatelessWidget {
  const AnalyticsChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is a placeholder widget - individual chart methods below
    return const SizedBox.shrink();
  }
}

/// Sleep Quality Chart Widget
class SleepQualityChart extends StatelessWidget {
  final List<SleepDataPoint> sleepData;
  final Color primaryColor;

  const SleepQualityChart({
    Key? key,
    required this.sleepData,
    this.primaryColor = const Color(0xFF2196F3),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: SfCartesianChart(
        backgroundColor: Colors.transparent,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0.5, color: Colors.white24),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 10),
          minimum: 0,
          maximum: 12,
        ),
        series: <CartesianSeries<dynamic, dynamic>>[
          AreaSeries<SleepDataPoint, DateTime>(
            dataSource: sleepData,
            xValueMapper: (SleepDataPoint data, _) => data.date,
            yValueMapper: (SleepDataPoint data, _) => data.hours,
            color: primaryColor.withValues(alpha: 0.3),
            borderColor: primaryColor,
            borderWidth: 2,
          ),
          LineSeries<SleepDataPoint, DateTime>(
            dataSource: sleepData,
            xValueMapper: (SleepDataPoint data, _) => data.date,
            yValueMapper: (SleepDataPoint data, _) => data.deepSleepHours,
            color: primaryColor.withValues(alpha: 0.8),
            width: 2,
          ),
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: '',
          textStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

/// Heart Rate Variability Chart
class HRVChart extends StatelessWidget {
  final List<HRVDataPoint> hrvData;
  final Color primaryColor;

  const HRVChart({
    Key? key,
    required this.hrvData,
    this.primaryColor = const Color(0xFFE91E63),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white.withValues(alpha: 0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < hrvData.length) {
                    return Text(
                      DateFormat('M/d').format(hrvData[value.toInt()].date),
                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 42,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: hrvData.length.toDouble() - 1,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: hrvData.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.hrv);
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  primaryColor.withValues(alpha: 0.8),
                  primaryColor,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withValues(alpha: 0.3),
                    primaryColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cycle Pattern Heatmap
class CyclePatternHeatmap extends StatelessWidget {
  final List<CycleHeatmapData> heatmapData;
  final int weeksToShow;

  const CyclePatternHeatmap({
    Key? key,
    required this.heatmapData,
    this.weeksToShow = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cycle Pattern Heatmap',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemCount: weeksToShow * 7,
              itemBuilder: (context, index) {
                final dataIndex = index < heatmapData.length ? index : null;
                final data = dataIndex != null ? heatmapData[dataIndex] : null;
                
                return Container(
                  decoration: BoxDecoration(
                    color: _getHeatmapColor(data),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: data != null
                      ? Tooltip(
                          message: _getTooltipMessage(data),
                          child: const SizedBox.expand(),
                        )
                      : const SizedBox.expand(),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _buildHeatmapLegend(),
        ],
      ),
    );
  }

  Widget _buildHeatmapLegend() {
    return Row(
      children: [
        const Text(
          'Less',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          return Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: _getLegendColor(index / 4),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        const SizedBox(width: 8),
        const Text(
          'More',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Color _getHeatmapColor(CycleHeatmapData? data) {
    if (data == null) return Colors.grey.withValues(alpha: 0.1);
    
    switch (data.phase) {
      case 'menstrual':
        return const Color(0xFFE91E63).withValues(alpha: 0.3 + (data.intensity * 0.7));
      case 'follicular':
        return const Color(0xFF4CAF50).withValues(alpha: 0.3 + (data.intensity * 0.7));
      case 'ovulatory':
        return const Color(0xFF2196F3).withValues(alpha: 0.3 + (data.intensity * 0.7));
      case 'luteal':
        return const Color(0xFF9C27B0).withValues(alpha: 0.3 + (data.intensity * 0.7));
      default:
        return Colors.grey.withValues(alpha: 0.2);
    }
  }

  Color _getLegendColor(double intensity) {
    return const Color(0xFF4CAF50).withValues(alpha: 0.2 + (intensity * 0.8));
  }

  String _getTooltipMessage(CycleHeatmapData data) {
    return '${DateFormat('MMM d').format(data.date)}\n'
           '${data.phase.toUpperCase()}\n'
           'Day ${data.dayInCycle}';
  }
}

/// Symptom Correlation Matrix
class SymptomCorrelationMatrix extends StatelessWidget {
  final Map<String, Map<String, double>> correlationData;

  const SymptomCorrelationMatrix({
    Key? key,
    required this.correlationData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final symptoms = correlationData.keys.toList();
    
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Symptom Correlations',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: symptoms.length,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                childAspectRatio: 1,
              ),
              itemCount: symptoms.length * symptoms.length,
              itemBuilder: (context, index) {
                final row = index ~/ symptoms.length;
                final col = index % symptoms.length;
                final symptom1 = symptoms[row];
                final symptom2 = symptoms[col];
                final correlation = correlationData[symptom1]?[symptom2] ?? 0.0;
                
                return Container(
                  decoration: BoxDecoration(
                    color: _getCorrelationColor(correlation),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Center(
                    child: Text(
                      correlation.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getCorrelationColor(double correlation) {
    final intensity = correlation.abs();
    if (correlation > 0) {
      return Color.lerp(Colors.white10, const Color(0xFF4CAF50), intensity) ?? Colors.white10;
    } else {
      return Color.lerp(Colors.white10, const Color(0xFFE91E63), intensity) ?? Colors.white10;
    }
  }
}

/// Mood Trend Chart
class MoodTrendChart extends StatelessWidget {
  final List<MoodDataPoint> moodData;

  const MoodTrendChart({
    Key? key,
    required this.moodData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: SfCartesianChart(
        backgroundColor: Colors.transparent,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0.5, color: Colors.white24),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 10),
          minimum: 1,
          maximum: 10,
        ),
        series: <CartesianSeries<dynamic, dynamic>>[
          ScatterSeries<MoodDataPoint, DateTime>(
            dataSource: moodData,
            xValueMapper: (MoodDataPoint data, _) => data.date,
            yValueMapper: (MoodDataPoint data, _) => data.moodScore,
            pointColorMapper: (MoodDataPoint data, _) => _getMoodColor(data.moodType),
            markerSettings: const MarkerSettings(
              isVisible: true,
              height: 8,
              width: 8,
            ),
          ),
          SplineSeries<MoodDataPoint, DateTime>(
            dataSource: moodData,
            xValueMapper: (MoodDataPoint data, _) => data.date,
            yValueMapper: (MoodDataPoint data, _) => data.moodScore,
            color: const Color(0xFF9C27B0).withValues(alpha: 0.6),
            width: 2,
          ),
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: '',
          textStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Color _getMoodColor(String moodType) {
    switch (moodType.toLowerCase()) {
      case 'happy':
        return const Color(0xFF4CAF50);
      case 'energetic':
        return const Color(0xFF2196F3);
      case 'calm':
        return const Color(0xFF00BCD4);
      case 'anxious':
        return const Color(0xFFFF9800);
      case 'sad':
        return const Color(0xFFE91E63);
      case 'tired':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }
}

// Data models for charts
class SleepDataPoint {
  final DateTime date;
  final double hours;
  final double deepSleepHours;
  final double quality;

  SleepDataPoint({
    required this.date,
    required this.hours,
    required this.deepSleepHours,
    required this.quality,
  });
}

class HRVDataPoint {
  final DateTime date;
  final double hrv;
  final double restingHR;

  HRVDataPoint({
    required this.date,
    required this.hrv,
    required this.restingHR,
  });
}

class CycleHeatmapData {
  final DateTime date;
  final String phase;
  final int dayInCycle;
  final double intensity;

  CycleHeatmapData({
    required this.date,
    required this.phase,
    required this.dayInCycle,
    required this.intensity,
  });
}

class MoodDataPoint {
  final DateTime date;
  final String moodType;
  final double moodScore;

  MoodDataPoint({
    required this.date,
    required this.moodType,
    required this.moodScore,
  });
}
