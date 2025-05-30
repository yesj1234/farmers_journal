import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'repositories/fcm_token_repository.dart';

part 'fcm_token_provider.g.dart';

@riverpod
FcmTokenRepository fcmTokenRepository(Ref ref) {
  return FcmTokenRepository(
    FirebaseMessaging.instance,
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
}

@riverpod
void fcmTokenInitializer(Ref ref) {
  final repo = ref.read(fcmTokenRepositoryProvider);
  repo.saveTokenToDatabase();
  repo.listenToTokenRefresh();
}
