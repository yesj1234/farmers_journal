// packages
import '../../controller/user/user_controller.dart';
import '../../pages/page_main/top_nav.dart';
import 'package:flutter/material.dart';

//Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers.dart';
// custom components
import '../../components/button/button_create_post.dart';
// enums
import 'package:farmers_journal/enums.dart';

import '../../../../controller.dart';
import 'community_view/scroll_to_top_button.dart';
import 'content.dart' show Content;

class PageMain extends ConsumerStatefulWidget {
  const PageMain({super.key});

  Icon get selectedIcon =>
      const Icon(Icons.check_outlined, key: ValueKey('selected'));
  TextStyle get selectedText => const TextStyle(fontWeight: FontWeight.bold);

  @override
  ConsumerState<PageMain> createState() => _PageMainState();
}

class _PageMainState extends ConsumerState<PageMain> {
  final ScrollController scrollController = ScrollController();
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainView = ref.watch(mainViewFilterProvider);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              edgeOffset: 80,
              onRefresh: () async {
                if (mainView == MainView.community) {
                  ref.invalidate(paginationControllerProvider);
                } else if (mainView == MainView.day) {
                  ref.invalidate(dayViewControllerProvider);
                } else if (mainView == MainView.week) {
                  ref.invalidate(weekViewControllerProvider);
                }
              },
              child: CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  SliverPersistentHeader(
                    delegate: _TopNavDelegate(),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Stack(children: [
                        Content(
                          scrollController: scrollController,
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ScrollToTopButton(scrollController: scrollController),
            )
          ],
        ),
      ),
      floatingActionButton: ButtonCreatePost(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFFF2F2F2),
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        height: 68,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _BottomNavigationItem(
                  currentMainView: mainView,
                  view: MainView.day,
                  icon: const Icon(Icons.calendar_view_day),
                  title: "일간",
                  selectedIcon: widget.selectedIcon,
                  selectedText: widget.selectedText),
            ),
            Expanded(
              child: _BottomNavigationItem(
                  currentMainView: mainView,
                  view: MainView.week,
                  icon: const Icon(Icons.calendar_view_week),
                  title: "주간",
                  selectedIcon: widget.selectedIcon,
                  selectedText: widget.selectedText),
            ),
            const Spacer(),
            Expanded(
              child: _BottomNavigationItem(
                  currentMainView: mainView,
                  view: MainView.month,
                  icon: const Icon(Icons.calendar_month),
                  title: "월간",
                  selectedIcon: widget.selectedIcon,
                  selectedText: widget.selectedText),
            ),
            Expanded(
              child: _BottomNavigationItem(
                  currentMainView: mainView,
                  view: MainView.community,
                  icon: const Icon(Icons.people),
                  title: "커뮤니티",
                  selectedIcon: widget.selectedIcon,
                  selectedText: widget.selectedText),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopNavDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 30;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / (maxExtent - minExtent);

    return Opacity(
      opacity: 1 - progress.clamp(0, 1),
      child: TopNav(),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

/// {@category Presentation}
/// The main page widget that consumes Riverpod providers.
///
/// Displays the navigation, content sections, and a floating action button for creating posts.
class PageMainPrev extends ConsumerWidget {
  /// Creates a [PageMainPrev] widget.
  const PageMainPrev({super.key});

  Icon get selectedIcon =>
      const Icon(Icons.check_outlined, key: ValueKey('selected'));
  TextStyle get selectedText => const TextStyle(fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(userControllerProvider(null));
    final mainView = ref.watch(mainViewFilterProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SafeArea(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: TopNav(),
              ),
              // Expanded(child: Content(scrollController: ,)),
            ],
          ),
        ),
      ),
      floatingActionButton: ButtonCreatePost(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFFF2F2F2),
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        height: 68,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _BottomNavigationItem(
                  currentMainView: mainView,
                  view: MainView.day,
                  icon: const Icon(Icons.calendar_view_day),
                  title: "일간",
                  selectedIcon: selectedIcon,
                  selectedText: selectedText),
            ),
            Expanded(
              child: _BottomNavigationItem(
                  currentMainView: mainView,
                  view: MainView.week,
                  icon: const Icon(Icons.calendar_view_week),
                  title: "주간",
                  selectedIcon: selectedIcon,
                  selectedText: selectedText),
            ),
            const Spacer(),
            Expanded(
              child: _BottomNavigationItem(
                  currentMainView: mainView,
                  view: MainView.month,
                  icon: const Icon(Icons.calendar_month),
                  title: "월간",
                  selectedIcon: selectedIcon,
                  selectedText: selectedText),
            ),
            Expanded(
              child: _BottomNavigationItem(
                  currentMainView: mainView,
                  view: MainView.community,
                  icon: const Icon(Icons.people),
                  title: "커뮤니티",
                  selectedIcon: selectedIcon,
                  selectedText: selectedText),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavigationItem extends ConsumerWidget {
  const _BottomNavigationItem({
    required this.currentMainView,
    required this.view,
    required this.icon,
    required this.title,
    required this.selectedIcon,
    required this.selectedText,
  });
  final MainView currentMainView;
  final MainView view;
  final String title;
  final Icon icon;
  final Icon selectedIcon;
  final TextStyle selectedText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => ref.read(mainViewFilterProvider.notifier).changeDateFilter(
            view,
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: currentMainView == view ? selectedIcon : icon,
          ),
          Text(title, style: currentMainView == view ? selectedText : null)
        ],
      ),
    );
  }
}
