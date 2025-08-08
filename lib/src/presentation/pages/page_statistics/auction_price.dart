import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../domain/model/real_time_auction_info.dart';

class AuctionPriceChart extends StatelessWidget {
  const AuctionPriceChart({super.key, required this.prices});
  final List<AuctionPrice> prices;

  FlGridData get gridData => FlGridData(show: false);
  FlBorderData get borderData => FlBorderData(show: false);
  AxisTitles get leftTitles =>
      AxisTitles(sideTitles: SideTitles(showTitles: false));
  AxisTitles get rightTitles =>
      AxisTitles(sideTitles: SideTitles(showTitles: false));

  AxisTitles get topTitles =>
      AxisTitles(sideTitles: SideTitles(showTitles: false));

  @override
  Widget build(BuildContext context) {
    prices.sort((a, b) => a.saledate.compareTo(b.saledate));

    // Create spots using index as x, price as y
    final spots = <FlSpot>[];
    final labels = <String>[];

    for (int i = 0; i < prices.length; i++) {
      final item = prices[i];
      final y = double.tryParse(item.cost);
      if (y == null) continue;

      spots.add(FlSpot(i.toDouble(), y));

      final date = item.parsedDate;
      labels.add('${date.month}/${date.day}');
    }

    return LineChart(
      LineChartData(
        borderData: borderData,
        gridData: gridData,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: leftTitles,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles:
                  false, // default to False, but explicitly set it to false.
            ),
          ),
          topTitles: topTitles,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < labels.length) {
                  return Text(labels[index], style: TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AuctionCandlestickChart extends StatelessWidget {
  const AuctionCandlestickChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Red Paprika Auction Prices'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seoul Garak Market - Red Paprika (5kg Box)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Date: May 2, 2024 | Location: Jinju, Gyeongsangnam-do',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CandlestickChart(),
            ),
          ],
        ),
      ),
    );
  }
}

class CandlestickChart extends StatelessWidget {
  const CandlestickChart({super.key});

  // Sample auction data converted to OHLC format
  List<CandleData> get candleData {
    // Simulating OHLC data based on the auction transactions
    // In real implementation, you'd aggregate actual transaction data by time periods
    return [
      CandleData(0, 15000, 23000, 12500, 18000), // First time period
      CandleData(1, 18000, 25000, 16000, 22000), // Second time period
      CandleData(2, 22000, 24000, 19000, 20500), // Third time period
      CandleData(3, 20500, 21000, 18500, 19500), // Fourth time period
      CandleData(4, 19500, 23500, 17000, 21000), // Fifth time period
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            minX: -0.5,
            maxX: candleData.length - 0.5,
            minY: 10000,
            maxY: 26000,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: true,
              horizontalInterval: 2000,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[300]!,
                  strokeWidth: 0.5,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.grey[300]!,
                  strokeWidth: 0.5,
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
                  getTitlesWidget: (value, meta) {
                    const style = TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    );
                    return Text('T${value.toInt() + 1}', style: style);
                  },
                  reservedSize: 30,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2000,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '₩${(value / 1000).toInt()}k',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    );
                  },
                  reservedSize: 40,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            lineBarsData: _createCandlesticks(),
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _createCandlesticks() {
    List<LineChartBarData> candlesticks = [];

    for (var candle in candleData) {
      final isGreen = candle.close >= candle.open;
      final color = isGreen ? Colors.green : Colors.red;

      // High-Low line (wick)
      candlesticks.add(
        LineChartBarData(
          spots: [
            FlSpot(candle.x, candle.high),
            FlSpot(candle.x, candle.low),
          ],
          isCurved: false,
          color: color,
          barWidth: 1,
          dotData: const FlDotData(show: false),
        ),
      );

      // Open-Close body
      final bodyTop = candle.open > candle.close ? candle.open : candle.close;
      final bodyBottom =
          candle.open > candle.close ? candle.close : candle.open;

      candlesticks.add(
        LineChartBarData(
          spots: [
            FlSpot(candle.x - 0.15, bodyTop),
            FlSpot(candle.x - 0.15, bodyBottom),
            FlSpot(candle.x + 0.15, bodyBottom),
            FlSpot(candle.x + 0.15, bodyTop),
            FlSpot(candle.x - 0.15, bodyTop),
          ],
          isCurved: false,
          color: color,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: isGreen
                ? Colors.green.withValues(alpha: 0.3)
                : Colors.red.withValues(alpha: 0.3),
          ),
        ),
      );

      // Horizontal lines for open and close
      candlesticks.add(
        LineChartBarData(
          spots: [
            FlSpot(candle.x - 0.15, candle.open),
            FlSpot(candle.x + 0.15, candle.open),
          ],
          isCurved: false,
          color: color,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
      );

      candlesticks.add(
        LineChartBarData(
          spots: [
            FlSpot(candle.x - 0.15, candle.close),
            FlSpot(candle.x + 0.15, candle.close),
          ],
          isCurved: false,
          color: color,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
      );
    }

    return candlesticks;
  }
}

class CandleData {
  final double x;
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData(this.x, this.open, this.high, this.low, this.close);
}
