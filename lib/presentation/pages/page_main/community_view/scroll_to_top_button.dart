import 'package:flutter/material.dart';

class ScrollToTopButton extends StatelessWidget {
  const ScrollToTopButton({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: scrollController,
        builder: (context, child) {
          double scrollOffset = scrollController.offset;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: scrollOffset > MediaQuery.of(context).size.height * 0.5
                ? IconButton(
                    icon: Icon(
                      Icons.keyboard_double_arrow_up_outlined,
                      size: 35,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () async {
                      scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    })
                : const SizedBox.shrink(),
          );
        });
  }
}
