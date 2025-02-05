import 'package:farmers_journal/presentation/controller/journal/pagination_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoMoreItems extends ConsumerWidget {
  const NoMoreItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paginationControllerProvider);
    return SliverToBoxAdapter(
      child: state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          data: (items) {
            final noMoreItems =
                ref.read(paginationControllerProvider.notifier).noMoreItems;
            return noMoreItems
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text.rich(
                      TextSpan(
                        text: "일지가 더 존재하지 않습니다.",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink();
          }),
    );
  }
}
