import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/data/interfaces.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository.setLanguage({required this.instance}) {
    instance.setLanguageCode('kr');
  }

  final FirebaseAuth instance;
  final _fireStore = FirebaseFirestore.instance;
  @override
  User? getCurrentUser() {
    return instance.currentUser;
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await instance.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        rethrow; // 재인증 로직 호출
      } else {
        throw Exception('탈퇴과정에 문제가 있습니다. ${e.toString()}');
      }
    } catch (e) {
      print(e);
      throw Exception('탈퇴과정에 문제가 있습니다. ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    String? errorMessage;
    try {
      await instance.sendPasswordResetEmail(email: email);
      print('비밀번호 재설정 이메일이 전송되었습니다.');
    } on FirebaseAuthException catch (error) {
      String? errorMessage;

      switch (error.code) {
        case 'auth/user-not-found':
          errorMessage = '해당 이메일로 가입된 사용자가 없습니다.';
          break;
        case 'auth/invalid-email':
          errorMessage = '유효하지 않은 이메일입니다.';
          break;
        default:
          errorMessage = error.message ?? '알 수 없는 오류가 발생했습니다.';
      }
    } catch (error) {
      errorMessage = '알 수 없는 오류가 발생했습니다.';
    }
    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    String? errorMessage;
    try {
      await instance.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'user-not-found':
          errorMessage = '해당 이메일로 가입된 사용자가 없습니다.';
          break;
        case 'wrong-password':
          errorMessage = '비밀번호가 올바르지 않습니다.';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일입니다.';
          break;
        case 'invalid-credential':
          errorMessage = '비밀번호가 올바르지 않거나 유효하지 않은 이메일입니다.';
          break;
        default:
          errorMessage = error.message ?? '알 수 없는 오류가 발생했습니다.';
      }
      throw Exception(errorMessage);
    } catch (error) {
      errorMessage = '알 수 없는 오류가 발생했습니다.';
    }
    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await instance.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signUpWithEmail(
      {required String email, required String password, String? name}) async {
    String? errorMessage;

    try {
      UserCredential userCredential = await instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await instance.currentUser?.updateDisplayName(name);
      await instance.currentUser?.sendEmailVerification();
      AppUser user = AppUser(
        email: email,
        createdAt:
            Timestamp.fromDate(userCredential.user!.metadata.creationTime!),
        journals: [],
        plants: [],
        isInitialSettingRequired: true,
      );
      await _fireStore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(user.toJson());
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'weak-password':
          errorMessage = '취약한 패스워드입니다. 최소 6자리 이상의 문자를 입력하세요.';
          break;
        case 'email-already-in-use':
          errorMessage = '이미 사용 중인 이메일입니다. 다른 이메일을 입력하세요.';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일입니다.';
          break;
        case 'network-request-failed':
          errorMessage = '인터넷 연결 상태를 확인해주세요.';
          break;
        default:
          errorMessage = error.message ?? '';
      }
      throw Exception(errorMessage);
    } catch (error) {
      if (errorMessage!.isNotEmpty) {
        throw Exception(errorMessage);
      } else {
        throw Exception(error);
      }
    }
  }

  Future<String> _uploadImage(Uint8List bytes) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef =
        FirebaseStorage.instance.ref().child("profile_images/$fileName");

    UploadTask uploadTask = storageRef.putData(bytes);

    TaskSnapshot snapshot = await uploadTask;

    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  @override
  Future<void> setProfileImage({required Uint8List bytes}) async {
    try {
      String photoURL = await _uploadImage(bytes);
      await instance.currentUser?.updatePhotoURL(photoURL);
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<void> setProfileName({required String name}) async {
    try {
      await instance.currentUser?.updateDisplayName(name);
    } catch (error) {
      throw Exception(error);
    }
  }
}
