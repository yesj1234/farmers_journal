import 'package:farmers_journal/components/avatar/avatar_profile.dart';
import 'package:flutter/material.dart';

class ProfileBanner extends StatelessWidget {
  const ProfileBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 90,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(174, 189, 175, 0.5),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          AvatarProfile(
            width: 60,
            height: 60,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Anonymous",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "anonymous@gmail.com",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
