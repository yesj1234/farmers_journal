import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmers_journal/src/domain/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../domain/model/journal.dart';
import '../../../controller/user/community_view_controller.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key, required this.journal});
  final Journal journal;

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
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
      error: (e, st) => GestureDetector(
          onTap: () {
            ref
                .read(communityViewControllerProvider.notifier)
                .getUserById(id: widget.journal.writer ?? '');
          },
          child: const _ErrorState()),
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
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.inversePrimary.withAlpha(255);
    final highlightColor = theme.colorScheme.onInverseSurface.withAlpha(255);
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circle Avatar placeholder
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            // Text placeholders
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + nickname line
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                // Plant + place line
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Error Avatar Icon
          CircleAvatar(
            radius: 25,
            backgroundColor: colorScheme.errorContainer,
            child: Icon(
              Icons.error_outline,
              color: colorScheme.onErrorContainer,
              size: 28,
            ),
          ),
          const SizedBox(width: 10),
          // Error Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Failed to load user info',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Tap to retry',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(130),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
