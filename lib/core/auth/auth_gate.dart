import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/auth/auth_providers.dart';
import 'package:postura/core/notifications/notification_providers.dart';
import 'package:postura/features/home/home_screen.dart';
import 'package:postura/features/login/login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStreamStatus = ref.watch(authStateProvider);
    return authStreamStatus.when(
      data: (user) {
        if (user != null) {
          ref.read(notificationServiceProvider).initialize(user.uid);
          return const MyHomePage();
        }
        return const LoginScreen();
      },
      error: (err, stack) => Text(err.toString()),
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
