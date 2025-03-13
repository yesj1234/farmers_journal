import 'package:flutter/material.dart';

/// A container widget for organizing settings options.
///
/// Displays a section title and a list of selectable items, separated by dividers.
class SettingContainer extends StatelessWidget {
  /// Creates a [SettingContainer] with a title and a list of items.
  const SettingContainer(
      {super.key, required this.settingTitle, required this.items});

  /// The title of the settings section.
  final String settingTitle;

  /// A list of selectable items within the settings container.
  final List<Widget> items;

  /// Text style for the settings title.
  TextStyle get settingTitleStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );

  /// Decoration for the container, including background color and border radius.
  BoxDecoration get containerDecoration => const BoxDecoration(
        color: Color.fromRGBO(174, 189, 175, 0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      );

  /// Builds a list of settings items, adding dividers between them.
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

/// A selectable item within the settings container.
///
/// Displays an icon, a title, and invokes a callback when tapped.
class SelectionItemWithCallback extends StatelessWidget {
  /// Creates a [SelectionItemWithCallback] widget.
  const SelectionItemWithCallback({
    super.key,
    required this.callback,
    required this.icon,
    required this.selectionName,
  });

  /// The name displayed for the selection item.
  final String selectionName;

  /// The icon representing the selection item.
  final IconData icon;

  /// The callback function invoked when the item is tapped.
  final VoidCallback callback;

  /// Text style for the selection name.
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
                const EdgeInsets.only(left: 10, right: 16, top: 5, bottom: 5),
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
