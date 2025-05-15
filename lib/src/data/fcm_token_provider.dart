import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'repositories/fcm_token_repository.dart';

final fcmTokenRepositoryProvider = Provider<FcmTokenRepository>((ref) {
  return FcmTokenRepository(
    FirebaseMessaging.instance,
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

final fcmTokenInitializerProvider = Provider<void>((ref) {
  final repo = ref.read(fcmTokenRepositoryProvider);
  repo.saveTokenToDatabase();
  repo.listenToTokenRefresh();
});
