import 'package:flutter/material.dart';

class SettingContainer extends StatelessWidget {
  const SettingContainer(
      {super.key, required this.settingTitle, required this.items});
  final String settingTitle;
  final List<SelectionItemWithCallback> items;

  TextStyle get settingTitleStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );

  BoxDecoration get containerDecoration => const BoxDecoration(
        color: Color.fromRGBO(174, 189, 175, 0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      );

  List<Widget> get settingItems {
    List<Widget> result = [];
    for (var (index, item) in items.indexed) {
      if (index == items.length - 1) {
        result.add(item);
      } else {
        result.addAll([
          item,
          const Divider(
            indent: 50,
            endIndent: 10,
          ),
        ]);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settingTitle,
          style: settingTitleStyle,
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width - 30,
          ),
          decoration: containerDecoration,
          child: Column(
            children: settingItems,
          ),
        ),
      ],
    );
  }
}

class SelectionItemWithCallback extends StatelessWidget {
  const SelectionItemWithCallback({
    super.key,
    required this.callback,
    required this.icon,
    required this.selectionName,
  });
  final String selectionName;
  final IconData icon;
  final VoidCallback callback;

  TextStyle get selectionNameTextStyle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      behavior: HitTestBehavior.translucent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            child: Icon(
              icon,
              size: 50,
            ),
          ),
          const SizedBox(width: 10),
          Text(selectionName, style: selectionNameTextStyle),
          const Spacer(),
          const Opacity(
            opacity: 0.5,
            child: Icon(
              Icons.navigate_next,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
