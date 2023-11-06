import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';

class ParameterLineChart extends StatefulWidget {
  final List<dynamic> values;
  final Color borderColor;
  final Color fillColor;
  final double interval;
  const ParameterLineChart({
    super.key,
    required this.values,
    required this.interval,
    required this.borderColor,
    required this.fillColor,
  });

  @override
  State<ParameterLineChart> createState() => _ParameterLineChartState();
}

class _ParameterLineChartState extends State<ParameterLineChart> {
  SideTitles get _bottomTitles => SideTitles(
        interval: 5,
        showTitles: true,
        getTitlesWidget: (value, meta) {
          return Text(value.toStringAsFixed(0));
        },
      );
  SideTitles get _leftTitles => SideTitles(
        interval: widget.interval,
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (widget.interval >= 1000) {
            return Text('${(value / 1000).toStringAsFixed(0)}K');
          }
          return Text(value.toStringAsFixed(0));
        },
      );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: widget.values
                  .mapIndexed(
                    (index, element) => FlSpot(
                      index.toDouble(),
                      element.toDouble(),
                    ),
                  )
                  .toList(),
              belowBarData: BarAreaData(
                show: true,
                color: widget.fillColor,
              ),
              isCurved: true,
              preventCurveOverShooting: true,
              dotData: const FlDotData(show: false),
              barWidth: 3,
              color: widget.borderColor,
            ),
          ],
          borderData: FlBorderData(
            border: const Border(
              bottom: BorderSide(),
              left: BorderSide(),
            ),
          ),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            leftTitles: AxisTitles(sideTitles: _leftTitles),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white,
              tooltipRoundedRadius: 16,
              tooltipPadding: const EdgeInsets.all(4),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map(
                  (LineBarSpot touchedSpot) {
                    return LineTooltipItem(
                      widget.values[touchedSpot.spotIndex].toStringAsFixed(2),
                      TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: widget.fillColor,
                      ),
                    );
                  },
                ).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
