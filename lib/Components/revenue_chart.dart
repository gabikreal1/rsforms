import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Providers/analyticsProvider.dart';
import 'dart:io' show Platform;

class RevenueChart extends StatefulWidget {
  final List<double> data;

  const RevenueChart({super.key, required this.data});

  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  List<Color> gradientColors = [Colors.blue, Colors.green];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          mainData(),
          duration: Durations.long1,
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    int intVal = value.toInt();
    if (intVal == 0) {
      text = const Text('1', style: style);
    } else if (intVal == widget.data.length - 1) {
      text = Text((widget.data.length).toString(), style: style);
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    if (value % 200 != 0) {
      return Container();
    }
    String text = (value.toInt()).toString();

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchCallback: (p0, p1) {
          if (p1 != null && p1.lineBarSpots != null && p1.lineBarSpots!.isNotEmpty) {
            var x = p1.lineBarSpots!.first.x;
            var y = p1.lineBarSpots!.first.y;
            if (Provider.of<AnalyticsProvider>(context, listen: false).currentDay != x.toInt() && Platform.isIOS) {
              HapticFeedback.lightImpact();
            }
            Provider.of<AnalyticsProvider>(context, listen: false).setCurrentDay(x, y);
          }
        },
        touchSpotThreshold: 1000,
        handleBuiltInTouches: false,
      ),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 31,
      minY: 0,
      maxY: 1400,
      lineBarsData: [
        LineChartBarData(
          spots: widget.data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
          isCurved: true,
          curveSmoothness: 0.3,
          preventCurveOvershootingThreshold: 0,
          preventCurveOverShooting: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: false,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
