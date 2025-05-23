import 'dart:math' hide log;
import 'dart:typed_data';
import 'package:farmers_journal/notification.dart';
import 'package:farmers_journal/src/data/fcm_token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart'
    as kakao_auth;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../domain/interface/auth_interface.dart';
import '../../domain/model/user.dart';

/// {@category Data}
/// {@category Repository}
/// Implementation of [AuthRepository] using Firebase Authentication as the backend service.
///
/// This class provides authentication functionalities, such as signing in, signing up,
/// resetting passwords, and handling third-party authentication (Apple, Kakao).
///
/// It also interacts with Firebase Firestore to store and manage user data.
class FirebaseAuthRepository implements AuthRepository {
  /// Constructor that sets the language code for Firebase Authentication.
  ///
  /// Accepts an instance of [firebase_auth.FirebaseAuth] and a [Logger] instance.
  FirebaseAuthRepository.setLanguage(
      {required this.instance, required this.logger}) {
    instance.setLanguageCode('kr');
  }

  /// Logger instance for logging errors and info messages.
  final Logger logger;

  /// Firebase Authentication instance used for authentication operations.
  final firebase_auth.FirebaseAuth instance;

  /// Firestore instance to interact with the database.
  final _fireStore = FirebaseFirestore.instance;
  @override
  firebase_auth.User? getCurrentUser() {
    return instance.currentUser;
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await instance.currentUser?.delete();
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        rethrow; // 재인증 로직 호출
      } else {
        throw Exception('탈퇴과정에 문제가 있습니다. ${e.toString()}');
      }
    } catch (e) {
      logger.e(e);
      throw Exception('탈퇴과정에 문제가 있습니다. ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    String? errorMessage;
    try {
      await instance.sendPasswordResetEmail(email: email);
      logger.i('비밀번호 재설정 이메일이 전송되었습니다.');
    } on firebase_auth.FirebaseAuthException catch (error) {
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
      {required String email,
      required String password,
      required WidgetRef widgetRef}) async {
    String? errorMessage;
    try {
      await instance.signInWithEmailAndPassword(
          email: email, password: password);
      _handlePostLogin(widgetRef);
    } on firebase_auth.FirebaseAuthException catch (error) {
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
  Future<void> signOut(WidgetRef ref) async {
    try {
      await ref.read(fcmTokenRepositoryProvider).deleteTokenFromDatabase();
      await instance.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _createAppUser(
      {String? email,
      String? password,
      String? name,
      String? nickName,
      required String? uuid}) async {
    String? errorMessage;
    try {
      AppUser user = AppUser(
        id: uuid!,
        email: email ?? '',
        createdAt: Timestamp.now(),
        name: name ?? '이름 설정 필요',
        nickName: nickName,
        journals: [],
        plants: [],
        isInitialSettingRequired: true,
        profileImage: dotenv.env['DEFAULT_PROFILE_IMAGE'],
      );
      await _fireStore.collection('users').doc(uuid).set(user.toJson());
    } on firebase_auth.FirebaseAuthException catch (error) {
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

  @override
  Future<void> signInWithApple(WidgetRef widgetRef) async {
    try {
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final firebase_auth.OAuthCredential credential =
          firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await firebase_auth.FirebaseAuth.instance
          .signInWithCredential(credential);
      var docSnapshot = await _fireStore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      if (!docSnapshot.exists) {
        final NumberFormat formatter = NumberFormat('00000');
        final random = Random();
        await _createAppUser(
            email: appleCredential.email,
            name: appleCredential.givenName ??
                'Farmer${formatter.format(random.nextInt(10001))}',
            nickName: 'Anonymous Farmer',
            uuid: userCredential.user?.uid);

        await userCredential.user
            ?.updateProfile(displayName: '${appleCredential.email}');
      }
      _handlePostLogin(widgetRef);
    } on SignInWithAppleAuthorizationException catch (appleError) {
      throw Exception(
          'SignInWithAppleAuthorizationException Authentication failed: ${appleError.message}'); // 에러를 던짐
    } catch (error) {
      throw Exception('Apple Authentication failed: $error');
    }
  }

  @override
  Future<void> signInWithKakaoTalk(WidgetRef widgetRef) async {
    var provider = firebase_auth.OAuthProvider("oidc.kakao");
    try {
      // Login with kakao auth sdk
      kakao_auth.OAuthToken? token;
      if (await kakao_auth.isKakaoTalkInstalled()) {
        token = await kakao_auth.UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await kakao_auth.UserApi.instance.loginWithKakaoAccount();
      }
      firebase_auth.OAuthCredential credential = provider.credential(
          idToken: token.idToken, accessToken: token.accessToken);

      firebase_auth.UserCredential userCredential =
          await instance.signInWithCredential(credential);
      var kakaoUser = await kakao_auth.UserApi.instance.me();

      var docSnapshot = await _fireStore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      if (!docSnapshot.exists) {
        final NumberFormat formatter = NumberFormat('00000');
        final random = Random();
        await _createAppUser(
            email: kakaoUser.kakaoAccount?.email,
            name: kakaoUser.kakaoAccount?.name ??
                formatter.format(random.nextInt(10001)),
            nickName: 'Anonymous Farmer',
            uuid: userCredential.user?.uid);

        await userCredential.user?.updateProfile(
            displayName: '${kakaoUser.kakaoAccount?.profile?.nickname}');

        await instance.signOut();
        await instance.signInWithCredential(credential);
      }
      _handlePostLogin(widgetRef);
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<void> signUpWithEmail(
      {required String email, required String password, String? name}) async {
    try {
      firebase_auth.UserCredential userCredential = await instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await _createAppUser(
          email: email,
          password: password,
          name: name,
          nickName: 'Anonymous Farmer',
          uuid: userCredential.user?.uid);
      await instance.currentUser?.updateDisplayName(name);
      await instance.currentUser?.sendEmailVerification();
    } catch (error) {
      throw Exception(error);
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

  Future<void> _handlePostLogin(WidgetRef ref) async {
    FlutterLocalNotification.saveTokenToDatabase();
  }
}
