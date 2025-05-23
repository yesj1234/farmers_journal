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
    this.iconSize,
  });

  final double horizontalPadding;
  final double verticalPadding;
  final DateTime date;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double fontSize;
  final bool editable;
  final void Function()? onTapCallback;
  final double? iconSize;

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
                    onCallback1: onEdit,
                    onCallback2: onDelete,
                    onTapCallback: onTapCallback,
                    iconSize: iconSize,
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
  /// The [onCallback1] and [onCallback2] handle the two menu actions.
  const MyCascadingMenu({
    super.key,
    required this.onCallback1,
    required this.onCallback2,
    required this.menuType,
    this.onTapCallback,
    this.color,
    this.onCallback1Name,
    this.onCallback2Name,
    this.iconSize,
  });

  final CascadingMenuType menuType;
  final VoidCallback onCallback1;
  final VoidCallback onCallback2;
  final void Function()? onTapCallback;
  final Color? color;
  final String? onCallback1Name;
  final String? onCallback2Name;
  final double? iconSize;

  @override
  State<StatefulWidget> createState() => _MyCascadingMenuState();
}

/// The state for [MyCascadingMenu], managing menu options and interactions.
class _MyCascadingMenuState extends State<MyCascadingMenu> {
  /// Returns the list of menu items based on [menuType].
  List<Widget> get menus => switch (widget.menuType) {
        CascadingMenuType.personal => [
            MenuItemButton(
              onPressed: () => widget.onCallback1(),
              child: Row(children: [
                const Icon(Icons.edit),
                Text(widget.onCallback1Name ?? "수정하기"),
              ]),
            ),
            MenuItemButton(
              onPressed: () => widget.onCallback2(),
              child: Row(children: [
                const Icon(Icons.delete_forever),
                Text(widget.onCallback2Name ?? "삭제하기"),
              ]),
            ),
          ],
        CascadingMenuType.community => [
            MenuItemButton(
              onPressed: () => widget.onCallback1(),
              child: Row(
                spacing: 5,
                children: [
                  const Icon(Icons.report_outlined),
                  Text(widget.onCallback1Name ?? "글 신고"),
                ],
              ),
            ),
            MenuItemButton(
              onPressed: () => widget.onCallback2(),
              child: Row(
                spacing: 5,
                children: [
                  const Icon(Icons.block_sharp),
                  Text(widget.onCallback2Name ?? "유저 차단"),
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
                    ?.onSurface, // Semi-transparent black
            size: widget.iconSize ?? 24,
          ),
        );
      },
    );
  }
}
