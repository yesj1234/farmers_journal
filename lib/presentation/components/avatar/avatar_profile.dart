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

  // 데이터의 에러처리와 실제로 그려지는 위젯의 에러처리를 분리해서 생각해야함.
  // 현재의 경우 데이터의 에러처리만 이루어지고 있기 때문에 만약 잘못된 URL이 넘어와도 어쨋든 값이 넘어왔기 때문에
  // 데이터 관점에선 에러가 없음. 따라서 AsyncError() 부분으로 넘어가지 않음.
  // 이를 개선하기 위해선 CircleAvatar보다는 렌더링단에서 에러를 처리해주는 다른 widget을 사용하는걸 고려하는 것이 좋아보임.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppUser?> user = ref.watch(userControllerProvider);
    return GestureDetector(
      onTap: onNavigateTap,
      child: SizedBox(
        width: width,
        height: height,
        child: user.isLoading
            ? const CircularProgressIndicator()
            : CircleAvatar(
                backgroundImage: switch (user) {
                AsyncData(:final value) =>
                  (value != null && value.profileImage!.isNotEmpty)
                      ? CachedNetworkImageProvider(value.profileImage!)
                      : const AssetImage('assets/avatars/default.png'),
                AsyncError() => const AssetImage('assets/avatars/default.png'),
                _ => const AssetImage('assets/avatars/default.png'),
              }),
      ),
    );
  }
}
