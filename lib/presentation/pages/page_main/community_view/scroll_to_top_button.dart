import 'package:flutter/material.dart';

/// A floating button that appears when scrolling down and returns to the top when pressed.
///
/// This widget monitors the scroll position using a [ScrollController] and displays
/// an animated button when the user has scrolled past 40% of the screen height.
/// Tapping the button smoothly scrolls the view back to the top.
class ScrollToTopButton extends StatelessWidget {
  /// Creates a [ScrollToTopButton].
  ///
  /// The [scrollController] parameter is required to monitor and control scrolling.
  /// The [key] parameter is optional and passed to the superclass.
  const ScrollToTopButton({
    super.key,
    required this.scrollController,
  });

  /// The controller used to monitor scroll position and animate scrolling.
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      // Rebuild when scroll position changes
      animation: scrollController,
      builder: (context, child) {
        // Get current scroll offset
        double scrollOffset = scrollController.offset;

        return AnimatedSwitcher(
          // Smooth transition duration for button appearance/disappearance
          duration: const Duration(milliseconds: 300),
          // Scale animation for button entry/exit
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: scrollOffset > MediaQuery.sizeOf(context).height * 0.4
              ? IconButton(
                  icon: Icon(
                    Icons.keyboard_double_arrow_up_outlined,
                    size: 35, // Larger icon for better visibility
                    color: Theme.of(context).primaryColor, // Theme-based color
                  ),
                  onPressed: () async {
                    // Animate scroll back to top with smooth easing
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                )
              // Hide button when near top of scroll
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
