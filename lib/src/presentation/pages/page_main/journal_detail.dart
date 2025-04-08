import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmers_journal/component.dart';
import 'package:farmers_journal/src/domain/model/user.dart';
import 'package:farmers_journal/src/presentation/pages/page_journal/image_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/model/journal.dart';
import '../../components/layout_images/layout_images_detail_screen.dart';
import '../../components/show_alert_dialog.dart';
import '../../components/show_snackbar.dart';
import '../../controller/journal/journal_controller.dart';
import '../../controller/journal/pagination_controller.dart';
import '../../controller/journal/report_controller.dart';
import '../../controller/user/community_view_controller.dart';
import '../../controller/user/user_controller.dart';
import 'community_view/detail_dialog.dart';

class JournalDetail extends StatelessWidget {
  const JournalDetail({super.key, required this.journal});
  final Journal? journal;
  @override
  Widget build(BuildContext context) {
    final appBar = SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Consumer(builder: (context, ref, child) {
            final userInfo = ref.read(userControllerProvider);
            return userInfo.value!.id == journal!.writer
                ? MyCascadingMenu(
                    menuType: CascadingMenuType.personal,
                    onCallBack1: () =>
                        context.push('/update/${journal!.id}').then((value) {
                      if (value == true && context.mounted) {
                        context.pop();
                      }
                    }),
                    onCallBack2: () {
                      showMyAlertDialog(
                        context: context,
                        type: AlertDialogType.delete,
                        cb: () {
                          ref
                              .read(journalControllerProvider.notifier)
                              .deleteJournal(id: journal!.id as String);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  )
                : MyCascadingMenu(
                    menuType: CascadingMenuType.community,
                    onCallBack1: () {
                      showReportDialog(
                          context: context,
                          journalId: journal!.id!,
                          onConfirm: (String? value) {
                            try {
                              ref
                                  .read(journalControllerProvider.notifier)
                                  .reportJournal(
                                    id: journal!.id!,
                                    userId: userInfo.value!.id,
                                    reason: value ?? '',
                                  );
                              ref
                                  .read(reportControllerProvider.notifier)
                                  .createReport(
                                    journalId: journal!.id!,
                                    writerId: userInfo.value!.id,
                                    reason: value ?? '',
                                  );
                              showSnackBar(context,
                                  "신고가 정상적으로 처리되었습니다. 적절한 조치를 취하겠습니다.");
                            } catch (error) {
                              showSnackBar(context,
                                  "신고 요청 처리에 문제가 발생했습니다. 불편을 드려 죄송하며 빠르게 해결하겠습니다. 잠시 후 다시 시도해 주세요.");
                            }
                            Navigator.pop(context);
                          });
                    },
                    onCallBack2: () => showMyAlertDialog(
                        context: context,
                        type: AlertDialogType.block,
                        cb: () {
                          ref
                              .read(userControllerProvider.notifier)
                              .blockUser(id: journal!.writer!);
                          ref.invalidate(communityViewControllerProvider);
                          Navigator.pop(context);
                          ref.invalidate(paginationControllerProvider);
                          showSnackBar(context, "차단되었습니다.");
                        }),
                  );
          })
        ],
      ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, viewport) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: viewport.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      journal!.images!.isEmpty
                          ? const SizedBox.shrink()
                          : SizedBox(
                              height: MediaQuery.sizeOf(context).height / 2.4,
                              child: ImageCarousel(
                                  journal:
                                      journal!), // This ImageCarousel Is a stack that occupies from the top of the screen.
                            ),
                      SizedBox(
                        height: 55,
                        child: _UserProfile(journal: journal!),
                      ),
                      journal!.title!.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: _JournalTitle(title: journal!.title!),
                            ),
                      journal!.content!.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child:
                                  _JournalContent(content: journal!.content!),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          appBar,
        ],
      ),
    );
  }
}

class _JournalTitle extends StatelessWidget {
  const _JournalTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _JournalContent extends StatelessWidget {
  const _JournalContent({super.key, required this.content});
  final String content;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Text(content),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key, required this.journal});
  final Journal journal;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel>
    with SingleTickerProviderStateMixin {
  late final PageController _pageViewController;
  late final TabController _tabController;

  /// Opacity transition curve for hero animations.
  static const opacityCurve = Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: 0);
    _tabController = TabController(
        initialIndex: 0, length: widget.journal.images!.length, vsync: this);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageView = PageView(
      controller: _pageViewController,
      onPageChanged: _handlePageViewChanged,
      children: widget.journal.images!
          .map(
            (url) => GestureDetector(
              onTap: () async {
                final currentIndex = _tabController.index;
                final newIndex = await Navigator.of(context).push<int>(
                  PageRouteBuilder(
                    maintainState: true,
                    opaque: false,
                    transitionsBuilder: (context, animation, _, child) =>
                        Opacity(
                            opacity: opacityCurve.transform(animation.value),
                            child: child),
                    pageBuilder: (
                      context,
                      _,
                      __,
                    ) =>
                        DetailScreenPageView(
                      tags: widget.journal.images!
                          .map((url) => UrlImage(url!))
                          .toList(),
                      initialIndex: _tabController.index,
                    ),
                  ),
                );
                if (newIndex != currentIndex && newIndex != null) {
                  _pageViewController.jumpToPage(newIndex);
                  _tabController.index = newIndex;
                }
              },
              child: Hero(
                tag: url!,
                transitionOnUserGestures: true,
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
          .toList(),
    );

    return Stack(
      children: [
        pageView,
        Align(
          alignment: Alignment.bottomCenter,
          child: PageIndicator(
            tabController: _tabController,
          ),
        ),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
  }
}

class _UserProfile extends ConsumerStatefulWidget {
  const _UserProfile({super.key, required this.journal});
  final Journal journal;

  @override
  ConsumerState<_UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<_UserProfile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(communityViewControllerProvider.notifier)
          .getUserById(id: widget.journal.writer!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(communityViewControllerProvider);

    return userInfo.when(
      data: (info) => _DataState(
        userInfo: info,
        plant: widget.journal.plant,
        place: widget.journal.place,
      ),
      loading: () => const _ShimmerLoadingState(),
      error: (e, st) => const _ErrorState(),
      initial: () => const _ShimmerLoadingState(),
    );
  }
}

class _DataState extends StatelessWidget {
  const _DataState(
      {super.key,
      required this.place,
      required this.plant,
      required this.userInfo});
  final AppUser userInfo;
  final String? place;
  final String? plant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: CachedNetworkImageProvider(userInfo.profileImage!),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    text: '${userInfo.name!} ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: userInfo.nickName!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withAlpha((0.5 * 255).toInt())),
                      )
                    ]),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 90,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: '$plant, ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                        TextSpan(
                            text: place,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _ShimmerLoadingState extends StatelessWidget {
  const _ShimmerLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("LoadingState");
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Error state");
  }
}
