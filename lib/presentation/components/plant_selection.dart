import 'package:farmers_journal/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlantSelection2 extends ConsumerStatefulWidget {
  const PlantSelection2({super.key, required this.onChange});
  final void Function(String) onChange;

  @override
  ConsumerState<PlantSelection2> createState() => _PlantSelection2State();
}

class _PlantSelection2State extends ConsumerState<PlantSelection2> {
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
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          leading: const Icon(Icons.search),
          onTap: () {
            controller.openView();
          },
          onChanged: (value) {
            widget.onChange(value);
            controller.openView();
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        Map<String, List<dynamic>> suggestions = ref
            .read(hsCodeRepositoryProvider)
            .findMatchingVariety(input: controller.text);
        final varietySuggestions = suggestions['variety']?.map((suggestion) {
              return ListTile(
                title: Text(suggestion.toString()),
                onTap: () {
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
                    "${controller.text}의 품종",
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
    );
  }
}

class PlantSelection extends StatelessWidget {
  const PlantSelection(
      {super.key, required this.onChange, required this.onFieldSubmitted});
  final void Function(String) onChange;
  final void Function(String) onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlantTextField(
              onFieldSubmitted: onFieldSubmitted, onChange: onChange),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class PlantTextField extends StatefulWidget {
  const PlantTextField(
      {super.key, required this.onFieldSubmitted, required this.onChange});
  final void Function(String) onFieldSubmitted;
  final void Function(String) onChange;
  @override
  State<PlantTextField> createState() => _PlantTextFieldState();
}

class _PlantTextFieldState extends State<PlantTextField> {
  InputDecoration get inputDecoration => const InputDecoration(
        labelText: "작물 선택",
        fillColor: Colors.transparent,
        isDense: true,
      );
  final TextEditingController textEditingController = TextEditingController();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
              validator: (inputValue) {
                if (inputValue == null) {
                  return 'Null not allowed';
                }
                if (inputValue.isEmpty) {
                  return 'Empty value not allowed';
                }
                return null;
              },
              onChanged: widget.onChange,
              controller: textEditingController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (String text) {
                widget.onFieldSubmitted(text);
              },
              decoration: inputDecoration),
        ),
        InkWell(
          onTap: () {
            widget.onFieldSubmitted(textEditingController.text);
          },
          child: const Icon(Icons.check),
        )
      ],
    );
  }
}
