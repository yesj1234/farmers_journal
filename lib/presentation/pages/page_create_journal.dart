import 'package:flutter/material.dart';

class PageCreateJournal extends StatelessWidget {
  const PageCreateJournal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create new journal page")),
      body: const SafeArea(
        child: Center(
          child: Text(""),
        ),
      ),
    );
  }
}
