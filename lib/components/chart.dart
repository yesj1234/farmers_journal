import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:math';

class RecordBarChart extends StatelessWidget {
  const RecordBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    var random = Random();
    List<BarChartGroupData> temp = List.generate(
      12,
      (index) => BarChartGroupData(
        x: index + 1,
        barRods: <BarChartRodData>[
          BarChartRodData(
            toY: (5 + random.nextInt(45)).toDouble(),
            width: 15,
            color: const Color.fromRGBO(54, 91, 55, 1),
            borderRadius: BorderRadius.circular(3),
            backDrawRodData: BackgroundBarChartRodData(
              toY: 50,
              color: const Color.fromRGBO(233, 236, 241, 1),
              show: true,
            ),
          ),
        ],
      ),
    );

    return BarChart(
      BarChartData(
        barGroups: temp,
        alignment: BarChartAlignment.center,
        titlesData: FlTitlesData(
          show: true,
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 1,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                axisSide: AxisSide.bottom,
                child: Text(
                  '${value.toInt()}월',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
        ),
        gridData: const FlGridData(
          show: false,
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
      ),
    );
  }
}
