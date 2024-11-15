import 'package:flutter/material.dart';
import 'package:farmers_journal/components/chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageStatistics extends StatelessWidget {
  const PageStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistics Page")),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.red),
              bottom: BorderSide(color: Colors.red),
            ),
          ),
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: const Center(
            child: _JournalRecord(),
          ),
        ),
      ),
    );
  }
}

class _JournalRecord extends StatelessWidget {
  const _JournalRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              "기록",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
        Container(
            decoration: const BoxDecoration(
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
                ]),
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
            ))
      ],
    );
  }
}

class _FireIcon extends StatelessWidget {
  const _FireIcon({super.key});

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
        const Text(
          "91일",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "입력항목",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
