import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvatarProfile extends ConsumerWidget {
  final double width;
  final double height;

  final VoidCallback onNavigateTap;
  const AvatarProfile({
    super.key,
    this.width = 10.0,
    this.height = 10.0,
    required this.onNavigateTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppUser?> user = ref.watch(userControllerProvider);
    return GestureDetector(
      onTap: onNavigateTap,
      child: SizedBox(
          width: width,
          height: height,
          child: user.when(
            data: (info) {
              return CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(info!.profileImage!),
              );
            },
            error: (e, st) {
              return const SizedBox.shrink();
            },
            loading: () {
              return const CircularProgressIndicator();
            },
          )),
    );
  }
}
