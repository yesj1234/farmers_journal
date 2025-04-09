import 'package:flutter/material.dart';

/// {@category Presentation}
/// {@subCategory Component}
/// A simple wrapper widget that applies padding to its child.
///
/// This widget provides customizable horizontal and vertical padding around
/// the provided child widget.
class TextPortion extends StatelessWidget {
  /// Creates a [TextPortion] widget.
  ///
  /// The [child] parameter is required and specifies the content to be padded.
  /// The [horizontalPadding] and [verticalPadding] parameters define the padding sizes.
  const TextPortion({
    super.key,
    required this.child,
    required this.horizontalPadding,
    required this.verticalPadding,
  });

  final double horizontalPadding;
  final double verticalPadding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: child,
    );
  }
}

/// A widget displaying a formatted date with optional edit/delete options.
///
/// This widget shows a date in a localized format (e.g., "10월 15일 화요일") and
/// includes a cascading menu for edit and delete actions if [editable] is true.
class DatePortion extends StatelessWidget {
  /// Creates a [DatePortion] widget.
  ///
  /// The [date] parameter specifies the date to display.
  /// The [onEdit] and [onDelete] callbacks handle edit and delete actions.
  /// The [horizontalPadding] and [verticalPadding] define padding sizes.
  /// The [fontSize] sets the text size.
  /// The [editable] parameter defaults to true and controls menu visibility.
  const DatePortion({
    super.key,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.date,
    required this.onEdit,
    required this.onDelete,
    required this.fontSize,
    this.editable = true,
    this.onTapCallback,
  });

  final double horizontalPadding;
  final double verticalPadding;
  final DateTime date;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double fontSize;
  final bool editable;
  final void Function()? onTapCallback;

  /// Formats the [date] into a Korean-style string (e.g., "10월 15일 화요일").
  String? _formatDate(DateTime date) {
    final localDateTime = date.toLocal();
    final weekDayOrder = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];
    int month = localDateTime.month;
    int day = localDateTime.day;
    int weekDay = localDateTime.weekday;

    return '$month월 $day일 ${weekDayOrder[weekDay - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color:
          colorScheme.onSurfaceVariant.withValues(alpha: 0.5), // Subtle color
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_formatDate(date)}',
            style: textStyle,
          ),
          editable
              ? Flexible(
                  child: MyCascadingMenu(
                    menuType: CascadingMenuType.personal,
                    onCallBack1: onEdit,
                    onCallBack2: onDelete,
                    onTapCallback: onTapCallback,
                  ),
                ) // Show menu if editable
              : const SizedBox.shrink(), // Hide if not editable
        ],
      ),
    );
  }
}

/// Enum defining types of cascading menus.
enum CascadingMenuType {
  personal, // For personal content (edit/delete)
  community, // For community content (report/block)
}

/// A cascading menu widget with contextual options.
///
/// Displays a three-dot menu that opens to show options based on [menuType],
/// either for personal (edit/delete) or community (report/block) actions.
class MyCascadingMenu extends StatefulWidget {
  /// Creates a [MyCascadingMenu] widget.
  ///
  /// The [menuType] determines the menu options.
  /// The [onCallBack1] and [onCallBack2] handle the two menu actions.
  const MyCascadingMenu({
    super.key,
    required this.onCallBack1,
    required this.onCallBack2,
    required this.menuType,
    this.onTapCallback,
    this.color,
  });

  final CascadingMenuType menuType;
  final VoidCallback onCallBack1;
  final VoidCallback onCallBack2;
  final void Function()? onTapCallback;
  final Color? color;
  @override
  State<StatefulWidget> createState() => _MyCascadingMenuState();
}

/// The state for [MyCascadingMenu], managing menu options and interactions.
class _MyCascadingMenuState extends State<MyCascadingMenu> {
  /// Returns the list of menu items based on [menuType].
  List<Widget> get menus => switch (widget.menuType) {
        CascadingMenuType.personal => [
            MenuItemButton(
              onPressed: () => widget.onCallBack1(),
              child: const Row(children: [
                Icon(Icons.edit),
                Text("수정하기"), // "Edit" in Korean
              ]),
            ),
            MenuItemButton(
              onPressed: () => widget.onCallBack2(),
              child: const Row(children: [
                Icon(Icons.delete_forever),
                Text("삭제하기"), // "Delete" in Korean
              ]),
            ),
          ],
        CascadingMenuType.community => [
            MenuItemButton(
              onPressed: () => widget.onCallBack1(),
              child: const Row(
                spacing: 5,
                children: [
                  Icon(Icons.report_outlined),
                  Text("글 신고"), // "Report Post" in Korean
                ],
              ),
            ),
            MenuItemButton(
              onPressed: () => widget.onCallBack2(),
              child: const Row(
                spacing: 5,
                children: [
                  Icon(Icons.block_sharp),
                  Text("유저 차단"), // "Block User" in Korean
                ],
              ),
            ),
          ],
      };

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return MenuAnchor(
      menuChildren: menus,
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            widget.onTapCallback?.call();
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Icon(
            Icons.more_vert_outlined, // Three-dot menu icon
            color: widget.color ??
                themeData.buttonTheme.colorScheme
                    ?.onPrimary, // Semi-transparent black
            size: 24,
          ),
        );
      },
    );
  }
}
