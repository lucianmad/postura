import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:postura/core/router/navigation_key.dart';

class NotificationService {
  NotificationService();

  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSub;

  Future<void> initialize(String uid) async {
    await FirebaseMessaging.instance.requestPermission();
    final token = await FirebaseMessaging.instance.getToken();

    if (token == null) {
      throw Exception('No FCM token provided');
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fcmToken': token,
    }, SetOptions(merge: true));

    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen((
      newToken,
    ) {
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fcmToken': newToken,
      }, SetOptions(merge: true));
    });

    await _onMessageSub?.cancel();
    _onMessageSub = FirebaseMessaging.onMessage.listen((message) {
      _handleMessage(message);
    });

    await _onMessageOpenedAppSub?.cancel();
    _onMessageOpenedAppSub = FirebaseMessaging.onMessageOpenedApp.listen((
      message,
    ) {
      _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    final postureType = message.data['postureType'];
    if (postureType != null) {
      navigatorKey.currentContext?.go('/exercises/$postureType');
    }
  }
}
