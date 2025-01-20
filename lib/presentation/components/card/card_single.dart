import 'dart:developer';

import 'package:flutter/material.dart';

class TextPortion extends StatelessWidget {
  final double horizontalPadding;
  final double verticalPadding;
  final Widget? child;

  const TextPortion({
    super.key,
    required this.child,
    required this.horizontalPadding,
    required this.verticalPadding,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        child: child);
  }
}

class DatePortion extends StatelessWidget {
  final double horizontalPadding;
  final double verticalPadding;
  final DateTime date;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double fontSize;
  final bool editable;
  const DatePortion(
      {super.key,
      required this.horizontalPadding,
      required this.verticalPadding,
      required this.date,
      required this.onEdit,
      required this.onDelete,
      required this.fontSize,
      this.editable = true});

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
      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_formatDate(date)}',
            style: textStyle,
          ),
          editable
              ? Flexible(
                  child: MyCascadingMenu(onEdit: onEdit, onDelete: onDelete),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class MyCascadingMenu extends StatefulWidget {
  const MyCascadingMenu(
      {super.key, required this.onEdit, required this.onDelete});
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<StatefulWidget> createState() => _MyCascadingMenuState();
}

class _MyCascadingMenuState extends State<MyCascadingMenu> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: () => widget.onEdit(),
          child: const Row(children: [
            Icon(Icons.edit),
            Text('수정하기'),
          ]),
        ),
        MenuItemButton(
          onPressed: () => widget.onDelete(),
          child: const Row(children: [
            Icon(
              Icons.delete_forever,
            ),
            Text(
              '삭제하기',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ]),
        ),
      ],
      builder: (
        context,
        controller,
        child,
      ) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: const Icon(
            Icons.more_horiz,
            size: 20,
          ),
        );
      },
    );
  }
}
