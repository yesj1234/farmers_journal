import 'package:farmers_journal/presentation/controller/journal/pagination_controller.dart';
import 'package:farmers_journal/presentation/pages/page_main/day_view_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnGoingBottomWidget extends StatelessWidget {
  const OnGoingBottomWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverToBoxAdapter(
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(paginationControllerProvider);
            return state.maybeWhen(
              orElse: () => const SizedBox.shrink(),
              onGoingLoading: (items) => const Center(child: DayViewShimmer()),
              onGoingError: (items, e, st) => const Center(
                child: Column(
                  children: [
                    Icon(Icons.info),
                    SizedBox(height: 20),
                    Text(
                      "Something Went Wrong!",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
