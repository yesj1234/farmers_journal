import 'package:farmers_journal/src/data/providers.dart';
import 'package:farmers_journal/src/presentation/components/avatar/avatar_profile.dart';
import 'package:farmers_journal/src/presentation/controller/auction/auction_controller.dart';
import 'package:farmers_journal/src/presentation/controller/user/user_controller.dart';
import 'package:farmers_journal/src/presentation/pages/page_statistics/auction_price.dart';
import 'package:farmers_journal/src/presentation/pages/page_statistics/journal_record.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

class PageStatistics extends ConsumerWidget {
  const PageStatistics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(userControllerProvider(null));
    final auctionPricesRef = ref.watch(auctionControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "통계",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 75,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  const SizedBox.shrink(),
                  AvatarProfile(
                    width: 60,
                    height: 60,
                    onNavigateTap: () => context.go('/main/profile'),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          userRef.value?.name ?? 'UserName',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        userRef.value?.nickName ?? '',
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                const JournalRecord(),
                // const SizedBox(height: 10),
                // auctionPricesRef.maybeWhen(
                //     data: (data) => Center(
                //           child: SizedBox(
                //               height: 150,
                //               width: 230,
                //               child: CandlestickChart()),
                //         ),
                //     orElse: () {
                //       return const SizedBox.shrink();
                //     })
              ],
            )
          ],
        ),
      ),
    );
  }
}
