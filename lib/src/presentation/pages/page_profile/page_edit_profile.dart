import 'package:farmers_journal/src/presentation/components/avatar/avatar_profile.dart';
import 'package:farmers_journal/src/presentation/components/show_snackbar.dart';
import 'package:farmers_journal/src/presentation/controller/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// {@category Presentation}
class PageEditProfile extends ConsumerStatefulWidget {
  const PageEditProfile({super.key});

  @override
  ConsumerState<PageEditProfile> createState() => _PageProfileState();
}

class _PageProfileState extends ConsumerState<PageEditProfile> {
  BoxDecoration get floatingActionButtonDecoration => BoxDecoration(
        color: const Color.fromRGBO(184, 230, 185, 0.5),
        borderRadius: BorderRadius.circular(10),
      );

  TextStyle get floatingActionButtonTextStyle => const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      );

  String? newName;
  String? newNickName;
  bool isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();
  XFile? selectedImage;
  void pickImage() {
    _imagePicker
        .pickImage(source: ImageSource.gallery)
        .then((image) => setState(() {
              selectedImage = image;
            }));
  }

  void changeName(value) {
    newName = value;
  }

  void changeNickName(value) {
    newNickName = value;
  }

  void onSave() async {
    try {
      setState(() {
        isLoading = true;
      });
      await ref
          .read(userControllerProvider(null).notifier)
          .editProfile(
              name: newName, nickName: newNickName, profileImage: selectedImage)
          .then((v) {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          context.go('/main/profile');
        }
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (context.mounted) {
        showSnackBar(context, error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "프로필 수정",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Column(
              spacing: 10,
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: Stack(
                    children: [
                      Center(
                        child: selectedImage == null
                            ? AvatarProfile(
                                width: 100,
                                height: 100,
                                onNavigateTap: () {},
                              )
                            : SizedBox(
                                width: 100,
                                height: 100,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                    selectedImage!.path,
                                  ),
                                ),
                              ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: pickImage,
                          icon: Icon(
                            Icons.camera_alt_sharp,
                            color:
                                Theme.of(context).bannerTheme.backgroundColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const _UserName(),
                const SizedBox(height: 20),
                _ProfileForm(
                  onNameChange: changeName,
                  onNickNameChange: changeNickName,
                ),
                ElevatedButton(
                  onPressed: onSave,
                  style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(
                        150,
                        40,
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(Theme.of(context)
                        .buttonTheme
                        .colorScheme
                        ?.primaryContainer),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          "저장",
                          style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.onPrimary,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserName extends ConsumerWidget {
  const _UserName();
  TextStyle get displayNameTextStyle => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );
  TextStyle get subTextStyle => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(userControllerProvider(null));
    return userRef.maybeWhen(
        orElse: () => const SizedBox.shrink(),
        data: (value) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(value?.name ?? '', style: displayNameTextStyle),
                Text('${value?.nickName}', style: subTextStyle),
              ],
            ));
  }
}

class _ProfileForm extends ConsumerWidget {
  const _ProfileForm(
      {required this.onNameChange, required this.onNickNameChange});
  final void Function(String) onNameChange;
  final void Function(String) onNickNameChange;

  TextStyle get titleTextStyle => const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      );

  InputDecoration get inputDecoration => const InputDecoration(
        filled: false,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        hintStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userControllerProvider(null));
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 30,
      children: [
        TextFormField(
          initialValue: user.value?.name,
          onChanged: onNameChange,
          decoration: inputDecoration.copyWith(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 40),
            hintText: user.value?.name,
            labelText: '이름',
          ),
        ),
        TextFormField(
          initialValue: user.value?.nickName,
          onChanged: onNickNameChange,
          decoration: inputDecoration.copyWith(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 40),
            hintText: user.value?.nickName,
            labelText: '닉네임',
          ),
        )
      ],
    ));
  }
}
