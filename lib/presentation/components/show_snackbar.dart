import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, Widget child) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: child,
    ),
  );
}
