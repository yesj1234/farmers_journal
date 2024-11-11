import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_journal/firestorage_service.dart';

/// TODO
/// 2. consider the user has update the profile image. (foreground image url must change)
class AvatarProfile extends ConsumerWidget {
  final double width;
  final double height;

  const AvatarProfile({
    super.key,
    this.width = 10.0,
    this.height = 10.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<String> defaultImageURL = ref.watch(defaultImageProvider);
    return SizedBox(
      width: width,
      height: height,
      child: CircleAvatar(
        backgroundImage: switch (defaultImageURL) {
          AsyncData(:final value) => NetworkImage(value),
          AsyncError() => const AssetImage('assets/avatars/default.png'),
          _ => const AssetImage('assets/avatars/default.png'),
        },
      ),
    );
  }
}
