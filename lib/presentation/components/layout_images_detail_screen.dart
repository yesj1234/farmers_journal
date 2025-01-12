import 'dart:io';

import 'package:farmers_journal/presentation/pages/page_journal/image_type.dart';
import 'package:flutter/material.dart';

class LayoutImagesDetailScreen extends StatelessWidget {
  const LayoutImagesDetailScreen({
    super.key,
    required this.tags,
  });
  final List<UrlImage> tags;
  @override
  Widget build(BuildContext context) {
    final heroWidgets = tags
        .map(
          (path) => Hero(
            tag: path.value,
            child: Image.network(path.value),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: PageView(
          children: heroWidgets,
        ),
      ),
    );
  }
}
