import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmTokenRepository {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FcmTokenRepository(this._messaging, this._firestore, this._auth);

  Future<void> saveTokenToDatabase() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final token = await _messaging.getToken();
    if (token == null) return;

    final tokenRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tokens')
        .doc(token);

    await tokenRef.set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }

  void listenToTokenRefresh() {
    _messaging.onTokenRefresh.listen((token) async {
      await saveTokenToDatabase();
    });
  }

  Future<void> deleteTokenFromDatabase() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final token = await _messaging.getToken();
    if (token == null) return;

    final tokenRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tokens')
        .doc(token);
    await _messaging.deleteToken(); // invalidate the token locally
    await tokenRef.delete();
  }
}
