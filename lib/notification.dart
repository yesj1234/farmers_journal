import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/gorouter_config.dart';
import 'package:farmers_journal/src/data/fcm_token_provider.dart';
import 'package:farmers_journal/src/presentation/controller/journal/journal_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';

class FlutterLocalNotification {
  // Private constructor. Prevents creating new instance from outside.
  // This is to implement FlutterNotification class with singleton pattern.
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static init(WidgetRef ref) async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    FirebaseMessaging.onMessage.listen(_handleForeGroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      if (kDebugMode) {
        debugPrint("Notification opened: ${message.notification?.title}");
      }
      // Write code that redirect to the journal detail page.
      // a single journal can be retrieved through
      final String journalId = message.data['journalId'];
      try {
        final journal = await ref
            .read(journalControllerProvider.notifier)
            .getJournal(journalId);
        // Write code that redirects the user to the Journal detail page.
        router.goNamed('journal-detail',
            pathParameters: {"journalId": journalId}, extra: journal);
      } catch (error) {
        if (kDebugMode) {
          debugPrint(
              "Error occured while fetching journal with journalId $journalId");
          debugPrint("Error: $error}");
        }
      }

      ref.read(fcmTokenInitializerProvider);
    });
    try {
      await saveTokenToDatabase();
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Remote notification foreground handler
  static Future<void> _handleForeGroundMessage(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic> data = message.data; // data holds 'journalId'
    if (kDebugMode) {
      debugPrint('incoming foreground notification: ${data.toString()}');
    }
    await cancelNotification();
    await requestNotificationPermission();
    await showNotification(
        title: data['title'] ?? '', message: data['value'] ?? '');
  }

  // Remote notification background handler
  static Future<void> backgroundHandler(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic> data = message.data;
    if (kDebugMode) {
      debugPrint('incoming background notification ${data.toString()}');
    }
    await cancelNotification();
    await requestNotificationPermission();
    await showNotification(
        title: data['title'] ?? '', message: data['value'] ?? '');
  }

  static Future<void> saveTokenToDatabase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final token = await FirebaseMessaging.instance.getToken();

    final tokensRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tokens')
        .doc(token);

    await tokensRef.set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(), // Optional: for audit
      'platform': Platform.operatingSystem,
    });
  }

  static Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static requestNotificationPermission() {
    // Use generic to target specific platform.
    // iOS:IOSFlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Android:AndroidFlutterLocalNotificationsPlugin
    // flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //     AndroidFlutterLocalNotificationsPlugin>()
    //     ?.requestNotificationsPermission();
  }

  static Future<void> showNotification(
      {required String title, required message}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: false,
    );
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      badgeNumber: 1,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0, title, message, notificationDetails);
  }
}
