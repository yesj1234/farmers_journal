import 'package:farmers_journal/src/presentation/pages/page_statistics/chart.dart';
import 'package:flutter/material.dart';

class PriceRecord extends StatelessWidget {
  const PriceRecord({super.key});

  BoxDecoration get priceRecordBoxDecoration => const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(20),
          right: Radius.circular(20),
        ),
      );

  TextStyle get priceRecordTitleStyle => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 90,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  "가격",
                  style: priceRecordTitleStyle,
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 38,
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: priceRecordBoxDecoration,
          constraints: const BoxConstraints(maxWidth: 340, maxHeight: 300),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                "포도 경매가",
                style: priceRecordTitleStyle,
              ),
              const SizedBox(height: 20),
              const Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    _PriceBarChart(),
                    _PriceLineChart(),
                  ],
                ),
              ),
              const Expanded(child: _PriceBarChartDescription()),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceLineChart extends StatelessWidget {
  const _PriceLineChart();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: 50,
        right: 20,
        bottom: 30,
      ),
      child: PriceLineChart(),
    );
  }
}

class _PriceBarChart extends StatelessWidget {
  const _PriceBarChart();

  @override
  Widget build(BuildContext context) {
    return const PriceBarChart();
  }
}

class _PriceBarChartDescription extends StatelessWidget {
  const _PriceBarChartDescription();

  TextStyle get textStyle => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(0, 0, 0, 0.5),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline,
          size: 22,
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
        const SizedBox(width: 8),
        Text(
          "현재 보여지는 통계(실시간 포도 경매가)에 대한 설명란.\n가격 단위, 정보 제공 주체, 등등 통계에 대한 메타데이터 설명란",
          style: textStyle,
        )
      ],
    );
  }
}
