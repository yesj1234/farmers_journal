import 'dart:typed_data';
import '../../../domain/model/journal.dart';
import '../../../presentation/components/journal_form_content.dart';
import '../../../presentation/components/journal_form_title.dart';
import '../../../presentation/components/layout_images/layout_images.dart';
import '../../../presentation/components/show_snackbar.dart';
import '../../../presentation/controller/journal/journal_form_controller.dart';
import '../../../presentation/pages/page_journal/image_type.dart';
import '../../../presentation/controller/journal/journal_controller.dart';
import '../../components/journal_form_date.dart';
import '../../components/weather_icon_builder.dart';
import '../../controller/weather/weather_controller.dart';
import '../../controller/weather/weather_controller_state.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// {@category Presentation}
/// A page that allows users to update an existing journal entry.
///
/// This page fetches a journal entry by its [id], allowing the user to modify
/// the title, content, date, and images before saving the updates.
/// {@category Presentation}
class PageUpdateJournal extends ConsumerStatefulWidget {
  /// Creates an instance of [PageUpdateJournal].
  ///
  /// Requires a non-null [id] to fetch the corresponding journal entry.
  const PageUpdateJournal({super.key, required this.id});

  /// The unique identifier of the journal entry to be updated.
  final String? id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PageUpdateJournalState();
}

class _PageUpdateJournalState extends ConsumerState<PageUpdateJournal> {
  late final Future<Journal> _journal;
  String? title;
  String? content;
  DateTime? date;
  double? temperature;

  int? weatherCode;

  Map<String, dynamic>? initialInfo;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final ValueNotifier<List<ImageType>> imageNotifier = ValueNotifier([]);
  bool isPublic = true;

  Future<void> pickImage() async {
    XFile? _image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      imageNotifier.value = [...imageNotifier.value, XFileImage(_image)];
    }
  }

  Future<void> pickMultipleImages({required int limit}) async {
    List<XFile> _images = await _imagePicker.pickMultiImage(limit: limit);
    if (_images.isNotEmpty) {
      imageNotifier.value = [
        ...imageNotifier.value,
        ..._images.map((image) => XFileImage(image))
      ];
    }
  }

  void deleteImage(int id) {
    final updatedImages = List<ImageType>.from(imageNotifier.value)
      ..removeAt(id);
    imageNotifier.value = updatedImages;
  }

  @override
  void initState() {
    super.initState();
    _journal =
        ref.read(journalControllerProvider.notifier).getJournal(widget.id!);
    _journal.then((journal) {
      setState(() {
        titleController.text = journal.title ?? '';
        contentController.text = journal.content ?? '';
        date = journal.date;
        temperature = journal.temperature ?? 0;
        weatherCode = journal.weatherCode ?? -1;
        initialInfo = {'temperature': temperature, 'weatherCode': weatherCode};
        isPublic = journal.isPublic ?? true;
        imageNotifier.value =
            journal.images?.map((path) => UrlImage(path!)).toList() ?? [];
      });
      imageNotifier.addListener(() => _formKey.currentState?.validate());
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    imageNotifier.dispose();
    super.dispose();
  }

  Future<void> setWeather() async {
    ref
        .read(
            weatherControllerProvider(initialWeatherInfo: initialInfo).notifier)
        .setWeather(startDate: date!, endDate: date!); //
  }

  void onDatePicked(DateTime? value) {
    setState(() {
      date = value;
      setWeather();
    });
  }

  double? progress = 0;
  double totalTransferred = 0;
  Future<double> get totalBytesToUpload async {
    if (imageNotifier.value.isEmpty) {
      return 0.0;
    }
    final futureBytes = imageNotifier.value.map((img) {
      switch (img) {
        case UrlImage():
          return Future.value(Uint8List.fromList([0]));
        case XFileImage():
          return img.value.readAsBytes();
      }
    }).toList();
    final bytesList = await Future.wait(futureBytes);
    final bytes = bytesList.map((byte) => byte.length).toList();
    return bytes.fold<double>(0.0, (sum, byte) => sum + byte);
  }

  @override
  Widget build(BuildContext context) {
    final journalFormController = ref.watch(journalFormControllerProvider);
    final WeatherControllerState weatherController;
    if (initialInfo != null) {
      weatherController =
          ref.watch(weatherControllerProvider(initialWeatherInfo: initialInfo));
    } else {
      weatherController = ref.watch(weatherControllerProvider());
    }

    return FutureBuilder(
      future: _journal,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () => context.pop(true),
              ),
              actions: [
                TextButton(
                  onPressed: journalFormController.maybeWhen(
                      orElse: () {
                        return () async {
                          bool validated =
                              _formKey.currentState?.validate() ?? false;

                          if (validated) {
                            _formKey.currentState?.save();
                            try {
                              void Function(VoidCallback)? dialogSetState;
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      dialogSetState = setState;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                          value: progress,
                                        ),
                                      );
                                    });
                                  });
                              await ref
                                  .read(journalFormControllerProvider.notifier)
                                  .updateJournal(
                                      id: widget.id!,
                                      title: titleController.text,
                                      content: contentController.text,
                                      date: date ?? snapshot.data!.date!,
                                      images: imageNotifier.value,
                                      temperature: temperature,
                                      weatherCode: weatherCode,
                                      isPublic: isPublic,
                                      progressCallback: (
                                          {int? transferred,
                                          int? totalBytes}) async {
                                        final total = await totalBytesToUpload;
                                        if (transferred != null &&
                                            totalBytes != null) {
                                          totalTransferred += transferred;
                                          double newProgress =
                                              totalTransferred / total;
                                          dialogSetState!(() {
                                            progress = newProgress.clamp(0, 1);
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
                        };
                      },
                      loading: null),
                  child: const Text(
                    "완료",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              title: DateForm(
                initialDate: date ?? snapshot.data!.date!,
                datePicked: date,
                onDatePicked: onDatePicked,
              ),
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: LayoutBuilder(
                  builder: (context, viewport) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: viewport.maxHeight),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          child: AnimatedOpacity(
                                            opacity:
                                                weatherController.maybeWhen(
                                                    orElse: () => 0,
                                                    data: (_) => 1),
                                            duration:
                                                const Duration(seconds: 1),
                                            child: weatherController.maybeWhen(
                                                orElse: () {
                                              return AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                transitionBuilder:
                                                    (child, animation) {
                                                  return FadeTransition(
                                                      opacity: animation,
                                                      child: child);
                                                },
                                                child: WeatherIconBuilder(
                                                  key: const ValueKey(
                                                      'initialValue'),
                                                  temperature: snapshot
                                                      .data!.temperature!,
                                                  weatherCode: snapshot
                                                      .data!.weatherCode!,
                                                  iconSize: 24,
                                                ),
                                              );
                                            }, data: (info) {
                                              temperature = info['temperature'];
                                              weatherCode = info['weatherCode'];
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
                                                      '$date - ${info['temperature']} - ${info['weatherCode']}'),
                                                  temperature:
                                                      info['temperature'],
                                                  weatherCode:
                                                      info['weatherCode'],
                                                  iconSize: 24,
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 90,
                                          child: Row(
                                            children: [
                                              const Text('비공개'),
                                              Checkbox(
                                                value: isPublic,
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
                                ValueListenableBuilder(
                                    valueListenable: imageNotifier,
                                    builder: (context, images, child) {
                                      return images.isEmpty
                                          ? const SizedBox.shrink()
                                          : SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width -
                                                  42,
                                              height: images.length <= 5
                                                  ? MediaQuery.sizeOf(context)
                                                          .height /
                                                      5
                                                  : MediaQuery.sizeOf(context)
                                                          .height /
                                                      2.5,
                                              child: CustomImageWidgetLayout(
                                                images: images,
                                                onDelete: deleteImage,
                                                isEditMode: true,
                                                isImagesHidden: false,
                                              ),
                                            );
                                    }),
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
                                      _formKey.currentState?.save();
                                      try {
                                        if (imageNotifier.value.length >= 8) {
                                          throw (Exception(
                                              '사진은 최대 8장 까지 선택할 수 있습니다.'));
                                        }
                                        if (imageNotifier.value.length >= 7) {
                                          pickImage();
                                        } else {
                                          pickMultipleImages(
                                              limit: 8 -
                                                  imageNotifier.value.length);
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
                  },
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
