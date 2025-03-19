import 'package:farmers_journal/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {@category Presentation}
/// A widget that allows users to search and select plant varieties and subcategories.
///
/// Uses [SearchAnchor] and [SearchController] to provide a dynamic search experience.
/// Integrates with Riverpod to fetch plant-related data for suggestions.
class PlantSelection extends ConsumerStatefulWidget {
  /// Creates a [PlantSelection] widget.
  ///
  /// [onChange] is called when the user selects a suggestion or modifies the search.
  /// [autoFocus] determines whether the search field gains focus automatically.
  const PlantSelection({
    super.key,
    required this.onChange,
    this.autoFocus = false,
  });

  /// Callback function triggered when the selected plant name changes.
  final void Function(String) onChange;

  /// Determines if the search field should automatically gain focus.
  final bool? autoFocus;
  @override
  ConsumerState<PlantSelection> createState() => _PlantSelection2State();
}

class _PlantSelection2State extends ConsumerState<PlantSelection> {
  /// Controller for managing the search input and its behavior.
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
          autoFocus: widget.autoFocus!,
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

            /// Builds a list of suggestions for varieties.
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

            /// Builds a list of suggestions for subcategories.
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
