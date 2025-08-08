import 'dart:typed_data';
import '../../controller/journal/journal_form_controller_state.dart'
    as journal_form_controller_state;
import '../../controller/journal_image/journal_image_controller.dart';
import '../../controller/weather/weather_controller.dart';
import '../../components/journal_form_content.dart';
import '../../components/journal_form_date.dart';
import '../../components/journal_form_title.dart';
import '../../components/layout_images/layout_images.dart';
import '../../components/show_snackbar.dart';
import '../../components/weather_icon_builder.dart';
import '../../controller/journal/journal_controller.dart';
import '../../controller/journal/journal_form_controller.dart';
import '../../../presentation/pages/page_journal/image_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../../controller/weather/weather_controller_state.dart'
    as weather_controller_state;

// TODO: temperature UI update. show the lowest, highest, and mid temperature with horizontal graph. some research for the weather UI needed.
/// {@category Presentation}
class PageCreateJournal extends ConsumerStatefulWidget {
  const PageCreateJournal({super.key, this.initialDate});
  final DateTime? initialDate;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PageCreateJournal();
}

class _PageCreateJournal extends ConsumerState<PageCreateJournal> {
  final ValueNotifier<List<XFile>> imageNotifier = ValueNotifier([]);

  final _maxImageCount = 8;
  Future<void> pickImage() async {
    XFile? _image = await _imagePicker.pickImage(source: ImageSource.gallery);
    // instead of invoking setState, which rebuilds the entire widget tree,
    // this will only rebuild the widget that is necessary.
    if (_image != null) {
      imageNotifier.value = [...imageNotifier.value, _image];
    }
  }

  Future<void> pickMultipleImages({required int limit}) async {
    // List<XFile> _images = await _imagePicker.pickMultiImage(limit: limit);
    // if (_images.isNotEmpty) {
    //   imageNotifier.value = [...imageNotifier.value, ..._images];
    // }
    final List<AssetPathEntity> paths =
        await PhotoManager.getAssetPathList(type: RequestType.image);

    if (context.mounted) {
      showImagePickerModal(context: context, paths: paths);
    }
  }

  void deleteImage(int id) {
    final updateImages = List<XFile>.from(imageNotifier.value)..removeAt(id);
    imageNotifier.value = updateImages;
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  double? temperature;
  int? weatherCode;
  bool isPublic = false;

  late DateTime date;

  Future<void> setWeather() async {
    ref.read(weatherControllerProvider().notifier).setWeather(
        startDate: date,
        endDate: date); // updates the weather controller state.
  }

  void onDatePicked(DateTime value) {
    setState(() {
      date = value;
      setWeather();
    });
  }

  @override
  void initState() {
    super.initState();
    date = widget.initialDate ?? DateTime.now();
    imageNotifier.addListener(() => _formKey.currentState?.validate());
  }

  @override
  void dispose() {
    imageNotifier.dispose();
    super.dispose();
  }

  double? progress = 0;
  double totalTransferred = 0;
  Future<double> get totalBytesToUpload async {
    final futureBytes =
        imageNotifier.value.map((img) => img.readAsBytes()).toList();
    List<Uint8List> bytesList = await Future.wait(futureBytes);
    final bytes = bytesList.map((byte) => byte.length).toList();
    return bytes.fold<double>(0.0, (sum, byte) => sum + byte);
  }

  @override
  Widget build(BuildContext context) {
    final journalFormController = ref.watch(journalFormControllerProvider);
    final weatherController = ref.watch(weatherControllerProvider());
    final journalImageController = ref.watch(journalImageControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop('/main')),
        actions: [
          TextButton(
            onPressed: () {
              switch (journalFormController) {
                case journal_form_controller_state.Loading():
                  return;
                default:
                  () async {
                    _formKey.currentState?.validate();
                    if (imageNotifier.value.isNotEmpty ||
                        titleController.text.trim().isNotEmpty ||
                        contentController.text.trim().isNotEmpty) {
                      _formKey.currentState?.save();
                      try {
                        void Function(VoidCallback)? dialogSetState;
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              dialogSetState =
                                  setState; // store the reference to dialogSetState.
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                  value: progress,
                                ),
                              );
                            });
                          },
                        );

                        await ref
                            .read(journalFormControllerProvider.notifier)
                            .createJournal(
                                title: titleController.text,
                                content: contentController.text,
                                date: date,
                                images: imageNotifier.value,
                                isPublic: isPublic,
                                temperature: temperature,
                                weatherCode: weatherCode,
                                progressCallback: (
                                    {int? transferred, int? totalBytes}) async {
                                  final total = await totalBytesToUpload;
                                  if (transferred != null &&
                                      totalBytes != null) {
                                    totalTransferred += transferred;
                                    double newProgress =
                                        totalTransferred / total;
                                    dialogSetState!(() {
                                      progress = newProgress.clamp(
                                          0, 1); // Ensure it stays within 0-1
                                    });
                                  }
                                })
                            .then(
                          (_) {
                            ref.invalidate(journalControllerProvider);
                            if (context.mounted) {
                              context.pop();
                              context.pop();
                            }
                          },
                          onError: (e, st) {
                            if (context.mounted) {
                              showSnackBar(
                                context,
                                e.toString(),
                              );
                            }
                          },
                        );
                      } catch (error) {
                        if (context.mounted) {
                          showSnackBar(context, error.toString());
                        }
                      }
                    }
                  }();
              }
            },
            child: const _CompleteButton(),
          ),
        ],
        title: DateForm(
          initialDate: date,
          datePicked: widget.initialDate ?? date,
          onDatePicked: onDatePicked,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: LayoutBuilder(builder: (context, viewport) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: viewport.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: AnimatedOpacity(
                                      opacity: switch (weatherController) {
                                        weather_controller_state.Data(
                                          :final weatherInfo
                                        ) =>
                                          1.0,
                                        _ => 0.0,
                                      },
                                      duration: const Duration(seconds: 1),
                                      child: switch (weatherController) {
                                        weather_controller_state.Data(
                                          :final weatherInfo
                                        ) =>
                                          () {
                                            temperature =
                                                weatherInfo['temperature'];
                                            weatherCode =
                                                weatherInfo['weatherCode'];
                                            return AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              transitionBuilder:
                                                  (child, animation) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                              child: WeatherIconBuilder(
                                                key: ValueKey(
                                                    '$date - ${weatherInfo['temperature']} - ${weatherInfo['weatherCode']}'),
                                                temperature:
                                                    weatherInfo['temperature'],
                                                weatherCode:
                                                    weatherInfo['weatherCode'],
                                                iconSize: 24,
                                              ),
                                            );
                                          }(),
                                        _ => const SizedBox.shrink(),
                                      }),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: Row(
                                    children: [
                                      const Text('비공개'),
                                      Checkbox(
                                        value: !isPublic,
                                        onChanged: (_) {
                                          setState(() {
                                            isPublic = !isPublic;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        journalImageController.isEmpty
                            ? const SizedBox.shrink()
                            : AnimatedOpacity(
                                duration: const Duration(seconds: 1),
                                opacity:
                                    journalImageController.isNotEmpty ? 1 : 0,
                                child: SizedBox(
                                  key: ValueKey(journalImageController.length),
                                  width: MediaQuery.sizeOf(context).width - 42,
                                  height: journalImageController.length <= 5
                                      ? MediaQuery.sizeOf(context).height / 5
                                      : MediaQuery.sizeOf(context).height / 2.5,
                                  child: CustomImageWidgetLayout(
                                    images: journalImageController
                                        .map((item) => EntityImage(item))
                                        .toList(),
                                    onDelete: (int index) => ref
                                        .read(journalImageControllerProvider
                                            .notifier)
                                        .onDelete(index),
                                    isEditMode: true,
                                    isImagesHidden: false,
                                  ),
                                ),
                              ),
                        // ValueListenableBuilder(
                        //     valueListenable: imageNotifier,
                        //     builder: (context, images, child) {
                        //       final imagesLayout = images.isNotEmpty
                        //           ? SizedBox(
                        //               key: ValueKey(images.length),
                        //               width:
                        //                   MediaQuery.sizeOf(context).width - 42,
                        //               height: images.length <= 5
                        //                   ? MediaQuery.sizeOf(context).height /
                        //                       5
                        //                   : MediaQuery.sizeOf(context).height /
                        //                       2.5,
                        //               child: CustomImageWidgetLayout(
                        //                 images: images
                        //                     .map((item) => XFileImage(item))
                        //                     .toList(),
                        //                 onDelete: deleteImage,
                        //                 isEditMode: true,
                        //                 isImagesHidden: false,
                        //               ),
                        //             )
                        //           : const SizedBox.shrink();
                        //       return AnimatedOpacity(
                        //         duration: const Duration(seconds: 1),
                        //         opacity: images.isNotEmpty ? 1 : 0,
                        //         child: imagesLayout,
                        //       );
                        //     }),
                        TitleForm(
                          titleController: titleController,
                          contentController: contentController,
                          notifier: imageNotifier,
                        ),
                        Expanded(
                          flex: 3,
                          child: ContentForm(
                            controller: contentController,
                            onImagePick: () async {
                              try {
                                if (imageNotifier.value.length >=
                                    _maxImageCount) {
                                  throw (Exception('사진은 최대 8장 까지 선택할 수 있습니다.'));
                                }
                                if (imageNotifier.value.length >=
                                    _maxImageCount - 1) {
                                  pickImage();
                                } else {
                                  pickMultipleImages(
                                    limit: _maxImageCount -
                                        imageNotifier.value.length,
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  showSnackBar(context, e.toString());
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  const _CompleteButton();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "완료",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

void showImagePickerModal(
    {required BuildContext context, required List<AssetPathEntity> paths}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ImagePickerModal(paths: paths));
}

class _ImagePickerModal extends ConsumerStatefulWidget {
  const _ImagePickerModal({super.key, required this.paths});
  final List<AssetPathEntity> paths;

  @override
  ConsumerState<_ImagePickerModal> createState() => _ImagePickerModalState();
}

class _ImagePickerModalState extends ConsumerState<_ImagePickerModal> {
  late AssetPathEntity _currentPath;
  Future<List<AssetEntity>>? _futureImages;

  @override
  void initState() {
    super.initState();
    _currentPath = widget.paths.first;
    _loadImages();
  }

  void _loadImages() {
    _futureImages = _currentPath.getAssetListPaged(page: 0, size: 10);
  }

  void _onTagSelected(AssetPathEntity path) {
    setState(() {
      _currentPath = path;
      _loadImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tags = widget.paths
        .map((path) => TextButton(
            onPressed: () => _onTagSelected(path), child: Text(path.name)))
        .toList();
    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      color: Colors.amber,
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: tags,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AssetEntity>>(
              future: _futureImages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No images found.");
                } else {
                  return SizedBox(
                    height: 400,
                    child: GridView.count(
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                        crossAxisCount: 4,
                        children: snapshot.data!
                            .map((entity) => GestureDetector(
                                  onTap: () => ref
                                      .read(journalImageControllerProvider
                                          .notifier)
                                      .onAssetTap(entity),
                                  child: AssetEntityImage(
                                    entity,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ))
                            .toList()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
