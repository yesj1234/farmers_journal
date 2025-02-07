import 'package:farmers_journal/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlantSelection extends ConsumerStatefulWidget {
  const PlantSelection({super.key, required this.onChange});
  final void Function(String) onChange;

  @override
  ConsumerState<PlantSelection> createState() => _PlantSelection2State();
}

class _PlantSelection2State extends ConsumerState<PlantSelection> {
  SearchController searchController = SearchController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: searchController,
      viewOnChanged: (value) {
        widget.onChange(value);
      },
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          leading: const Icon(Icons.search),
          onTap: () {
            controller.openView();
          },
          onChanged: (value) {
            controller.openView();
          },
        );
      },
      suggestionsBuilder:
          (BuildContext context, SearchController controller) async {
        final hsCodeRef = ref.read(hsCodeRepositoryProvider);
        return hsCodeRef.when(
          data: (ref) {
            final suggestions = ref.findMatchingVariety(input: controller.text);
            final varietySuggestions =
                suggestions['variety']?.map((suggestion) {
                      return ListTile(
                        title: Text(suggestion.toString()),
                        onTap: () {
                          widget.onChange(suggestion);
                          setState(() {
                            controller.closeView(suggestion);
                          });
                        },
                      );
                    }).toList() ??
                    [];

            final subCategorySuggestions =
                suggestions['subCategory']?.map((suggestion) {
                      return ListTile(
                        title: Text(suggestion.toString()),
                        onTap: () {
                          widget.onChange(suggestion);
                          setState(() {
                            controller.closeView(suggestion);
                          });
                        },
                      );
                    }).toList() ??
                    [];

            return [
              subCategorySuggestions.isEmpty
                  ? const SizedBox.shrink()
                  : ListTile(
                      title: Text(
                        "'${controller.text}'가 포함된 품목의 품종",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              ...subCategorySuggestions,
              varietySuggestions.isEmpty
                  ? const SizedBox.shrink()
                  : ListTile(
                      title: Text(
                        "'${controller.text}'가 포함된 품종",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              ...varietySuggestions,
            ];
          },
          error: (e, st) {
            return [ListTile(title: Text(e.toString()))];
          },
          loading: () {
            return const [SizedBox.shrink()];
          },
        );
      },
    );
  }
}
