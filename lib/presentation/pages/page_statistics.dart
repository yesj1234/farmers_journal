import 'package:farmers_journal/components/avatar/avatar_profile.dart';
import 'package:flutter/material.dart';
import 'package:farmers_journal/components/chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:farmers_journal/components/button/button_filter_date.dart';

class PageStatistics extends StatelessWidget {
  const PageStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistics Page")),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 75,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(174, 189, 175, 0.5)),
              child: const Row(
                children: [
                  SizedBox(width: 20),
                  AvatarProfile(
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Anonymous",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.red),
                    bottom: BorderSide(color: Colors.red),
                  ),
                ),
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Center(
                  child: ListView(
                    children: const [
                      SizedBox(height: 20),
                      Center(
                        child: _JournalRecord(),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: _PriceRecord(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PriceRecord extends StatelessWidget {
  const _PriceRecord({super.key});

  BoxDecoration get priceRecordBoxDecoration => const BoxDecoration(
          color: Color.fromRGBO(174, 189, 175, 1),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(20),
            right: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
            ),
          ]);

  TextStyle get priceRecordTitleStyle => const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Color.fromRGBO(0, 0, 0, 0.6),
              blurRadius: 10.0,
              offset: Offset(3.0, 3.0),
            )
          ]);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            "가격",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
  const _PriceLineChart({super.key});

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
  const _PriceBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const PriceBarChart();
  }
}

class _PriceBarChartDescription extends StatelessWidget {
  const _PriceBarChartDescription({super.key});

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

class _JournalRecord extends StatelessWidget {
  const _JournalRecord({super.key});

  TextStyle get titleTextStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );

  BoxDecoration get journalRecordContainerDecoration => const BoxDecoration(
          color: Color.fromRGBO(174, 189, 175, 1),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(20),
            right: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
            ),
          ]);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "기록",
              style: titleTextStyle,
            )),
        Container(
          decoration: journalRecordContainerDecoration,
          constraints: const BoxConstraints(maxWidth: 340, maxHeight: 140),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _FireIcon(),
              SizedBox(
                width: 250,
                height: 125,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: RecordBarChart(),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _FireIcon extends StatelessWidget {
  const _FireIcon({super.key});

  TextStyle get daysTextStyle => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      );

  TextStyle get subtitleTextStyle => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      );

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/svgs/fire-svgrepo-com.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
      width: 45,
      height: 45,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        svg,
        Text(
          "91일",
          style: daysTextStyle,
        ),
        Text(
          "입력항목",
          style: subtitleTextStyle,
        )
      ],
    );
  }
}
