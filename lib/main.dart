import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/router/router_providers.dart';
import 'package:postura/core/theme/app_theme.dart';
import 'package:postura/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  String? initialLocation;
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    final postureType = initialMessage.data['postureType'];
    if (postureType != null) {
      initialLocation = '/exercises/$postureType';
    }
  }

  runApp(ProviderScope(child: MyApp(initialLocation: initialLocation)));
}

class MyApp extends ConsumerWidget {
  final String? initialLocation;
  const MyApp({super.key, this.initialLocation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Postura',
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider(initialLocation)),
      theme: AppTheme.darkTheme,
    );
  }
}
