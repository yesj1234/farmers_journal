import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:farmers_journal/presentation/controller/user/user_controller.dart';

/// A form widget for creating content, including text input and image picking.
///
/// Displays the user's first plant's name and place if available.
/// Provides a text input field and an option to pick an image.
///
/// {@tool snippet}
/// ```dart
/// ContentForm(
///   controller: TextEditingController(),
///   onImagePick: () {
///     // Handle image picking
///   },
/// );
/// ```
/// {@end-tool}
class ContentForm extends ConsumerWidget {
  /// Creates a [ContentForm] widget.
  ///
  /// The [controller] parameter is required to control the text input field.
  /// The [onImagePick] parameter is required and is called when the image
  /// pick button is pressed.
  const ContentForm(
      {super.key, required this.controller, required this.onImagePick});

  final TextEditingController controller;
  final void Function() onImagePick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(userControllerProvider);
    AsyncValue<Widget> tag = userRef.whenData((appUser) {
      if (appUser!.plants.isNotEmpty) {
        return FittedBox(
          fit: BoxFit.fitWidth,
          child: Text.rich(
            overflow: TextOverflow.ellipsis,
            maxLines: null,
            TextSpan(
              text: '${appUser.plants.first.name}, ',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: appUser.plants.first.place,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });

    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 1.2,
      height: MediaQuery.sizeOf(context).height / 3.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tag.isLoading
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: tag.value!,
                ),
          Expanded(
            child: Stack(
              children: [
                TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: '글쓰기 시작...',
                    fillColor: Colors.white,
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  minLines: 5,
                  maxLines: null,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: onImagePick,
                    icon: const Icon(Icons.camera_alt_rounded, size: 40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
