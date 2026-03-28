import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/auth/auth_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Settings page'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(authServiceProvider).signOut();
                } catch (ex) {
                  print(ex.toString());
                }
              },
              child: Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
