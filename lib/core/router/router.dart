import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/auth/auth_providers.dart';
import 'package:postura/core/notifications/notification_providers.dart';
import 'package:postura/core/providers/device_providers.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (previous, next) {
      final user = next.value;
      if (user != null && previous?.value == null) {
        _ref.read(notificationServiceProvider).initialize(user.uid);
      }
      notifyListeners();
    });

    _ref.listen(deviceIdProvider, (previous, next) {
      notifyListeners();
    });

    final currentUser = _ref.read(authStateProvider).value;
    if (currentUser != null) {
      _ref.read(notificationServiceProvider).initialize(currentUser.uid);
    }
  }
}
