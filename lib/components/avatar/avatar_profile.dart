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

  // 데이터의 에러처리와 실제로 그려지는 위젯의 에러처리를 분리해서 생각해야함.
  // 현재의 경우 데이터의 에러처리만 이루어지고 있기 때문에 만약 잘못된 URL이 넘어와도 어쨋든 값이 넘어왔기 때문에
  // 데이터 관점에선 에러가 없음. 따라서 AsyncError() 부분으로 넘어가지 않음.
  // 이를 개선하기 위해선 CircleAvatar보다는 렌더링단에서 에러를 처리해주는 다른 widget을 사용하는걸 고려하는 것이 좋아보임.
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
