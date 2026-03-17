import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/notifications/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);
