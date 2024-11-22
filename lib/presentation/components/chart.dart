import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'dart:math';

import 'package:farmers_journal/data/providers.dart';

class RecordBarChart extends StatelessWidget {
  const RecordBarChart({super.key});

  FlTitlesData get flTitlesData => FlTitlesData(
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
      );

  FlGridData get flGridData => const FlGridData(
        show: false,
        drawVerticalLine: false,
      );
  FlBorderData get flBorderData => FlBorderData(show: false);
  @override
  Widget build(BuildContext context) {
    var random = Random();
    List<BarChartGroupData> barChartGroupData = List.generate(
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
        barGroups: barChartGroupData,
        alignment: BarChartAlignment.center,
        titlesData: flTitlesData,
        gridData: flGridData,
        borderData: flBorderData,
      ),
    );
  }
}

class PriceLineChart extends ConsumerWidget {
  const PriceLineChart({super.key});

  List<String> get times => [
        "12:30",
        "13:00",
        "13:30",
        "14:00",
        "14:30",
        "15:00",
        "15:30",
        "16:00",
        "17:00",
        "17:30"
      ];
  FlTitlesData get flTitlesData => FlTitlesData(
        show: false,
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            minIncluded: false,
            maxIncluded: false,
            reservedSize: 30,
            interval: 3000,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 22,
            showTitles: true,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              axisSide: AxisSide.bottom,
              child: Text(
                times[value.toInt()],
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );

  FlGridData get flGridData => const FlGridData(show: false);
  FlBorderData get flBorderData => FlBorderData(show: false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var price = ref.watch(priceProvider);

    List<LineChartBarData> lineChartBarData = [
      LineChartBarData(
        barWidth: 4.0,
        color: Colors.white,
        spots: List.generate(
          10,
          (index) => FlSpot(
            index.toDouble(),
            price[index].toDouble(),
          ),
        ),
      )
    ];

    return LineChart(
      LineChartData(
        lineBarsData: lineChartBarData,
        titlesData: flTitlesData,
        gridData: flGridData,
        borderData: flBorderData,
      ),
    );
  }
}

class PriceBarChart extends ConsumerWidget {
  const PriceBarChart({super.key});

  List<String> get times => [
        "12:30",
        "13:00",
        "13:30",
        "14:00",
        "14:30",
        "15:00",
        "15:30",
        "16:00",
        "17:00",
        "17:30"
      ];

  FlTitlesData get flTitlesData => FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            minIncluded: false,
            maxIncluded: false,
            reservedSize: 30,
            interval: 3000,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              axisSide: AxisSide.bottom,
              child: Text(
                times[value.toInt()],
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );

  FlGridData get flGridData => FlGridData(
        show: true,
        drawVerticalLine: false,
        checkToShowHorizontalLine: (value) => value >= 3000,
      );

  FlBorderData get flBorderData => FlBorderData(
        show: false,
      );
  BarTouchTooltipData get barTouchTooltipData => BarTouchTooltipData(
        tooltipMargin: 4,
        getTooltipColor: (group) => Colors.transparent,
        tooltipBorder: BorderSide.none,
        tooltipPadding: EdgeInsets.zero,
        getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
          NumberFormat.simpleCurrency(locale: "ko_KR")
              .format(rod.toY.round())
              .toString(),
          const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var price = ref.watch(priceProvider);
    int maxPrice = price.reduce(max);
    List<BarChartGroupData> barChartGroupData = List.generate(10, (index) {
      if (price[index] == maxPrice) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: price[index].toDouble(),
              width: 20,
              color: const Color.fromRGBO(52, 75, 253, 1),
              borderRadius: BorderRadius.circular(3),
            )
          ],
          showingTooltipIndicators: [0],
        );
      } else {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: price[index].toDouble(),
              width: 20,
              color: const Color.fromRGBO(233, 236, 241, 1),
              borderRadius: BorderRadius.circular(3),
            )
          ],
        );
      }
    });
    return BarChart(
      BarChartData(
        groupsSpace: 1,
        barGroups: barChartGroupData,
        titlesData: flTitlesData,
        gridData: flGridData,
        borderData: flBorderData,
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: barTouchTooltipData,
        ),
      ),
    );
  }
}
