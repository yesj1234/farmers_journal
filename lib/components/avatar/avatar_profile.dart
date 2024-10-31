import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// TODO
/// 1. consider the case when the device is offline. (backgroundImage - imageProvider)
/// 2. consider the user has update the profile image. (foreground image url must change)
class ButtonProfileAvatar extends StatefulWidget {
  final double width;
  final double height;

  const ButtonProfileAvatar({
    super.key,
    this.width = 30.0,
    this.height = 30.0,
  });

  @override
  State<StatefulWidget> createState() {
    return _ButtonProfileAvatar();
  }
}

class _ButtonProfileAvatar extends State<ButtonProfileAvatar> {
  String? defaultProfileImageURL;
  Future<void> _getDefaultProfileImageURL() async {
    final storageRef = FirebaseStorage.instance.ref();
    final String url = await storageRef.child('/farmer.png').getDownloadURL();

    debugPrint(defaultProfileImageURL);

    setState(() {
      defaultProfileImageURL = url;
      debugPrint(defaultProfileImageURL);
    });
  }

  @override
  void initState() {
    super.initState();
    _getDefaultProfileImageURL();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CircleAvatar(
        foregroundImage: defaultProfileImageURL != null
            ? NetworkImage(defaultProfileImageURL!)
            : null,
      ),
    );
  }
}
