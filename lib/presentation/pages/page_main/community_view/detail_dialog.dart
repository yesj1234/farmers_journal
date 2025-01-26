import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:farmers_journal/presentation/components/card/card_single.dart';
import 'package:farmers_journal/presentation/controller/journal/journal_controller.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/presentation/show_delete_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class DataStateDialog extends StatelessWidget {
  final AppUser info;
  final Journal journalInfo;

  const DataStateDialog({
    super.key,
    required this.info,
    required this.journalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.7,
        height: MediaQuery.sizeOf(context).height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(info.profileImage!),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.name!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        info.nickName!,
                        style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Consumer(builder: (context, ref, child) {
                    final userInfo = ref.read(userControllerProvider);
                    return userInfo.value!.id == journalInfo.writer
                        ? MyCascadingMenu(
                            menuType: CascadingMenuType.personal,
                            onCallBack1: () =>
                                context.go('/update/${journalInfo.id}'),
                            onCallBack2: () => showDeleteAlertDialog(
                              context,
                              () => ref
                                  .read(journalControllerProvider.notifier)
                                  .deleteJournal(id: journalInfo.id as String),
                            ),
                          )
                        : MyCascadingMenu(
                            menuType: CascadingMenuType.community,
                            onCallBack1: () {},
                            onCallBack2: () {},
                          );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '${journalInfo.plant}, ',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: journalInfo.place,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  if (journalInfo.title!.isNotEmpty)
                    Text(
                      journalInfo.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (journalInfo.content!.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      child: SingleChildScrollView(
                        child: Text(
                          journalInfo.content!,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerLoadingStateDialog extends StatelessWidget {
  const ShimmerLoadingStateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.7,
        height: MediaQuery.sizeOf(context).height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer for profile row
              Row(
                children: [
                  _shimmerCircle(size: 50),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerRectangle(width: 120, height: 16),
                      const SizedBox(height: 8),
                      _shimmerRectangle(width: 80, height: 14),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Shimmer for content placeholder
              _shimmerRectangle(width: 200, height: 16),
              const SizedBox(height: 10),
              _shimmerRectangle(width: double.infinity, height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerRectangle({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _shimmerCircle({required double size}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class ErrorStateDialog extends StatelessWidget {
  const ErrorStateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(height: 10),
            Text(
              "Error occurred while loading data!",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
