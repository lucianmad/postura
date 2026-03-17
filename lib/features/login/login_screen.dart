import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/auth/auth_providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login screen'),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(authServiceProvider).signInWithGoogle();
                } catch (ex) {
                  print(ex.toString());
                }
              },
              child: Text('Button'),
            ),
          ],
        ),
      ),
    );
  }
}
