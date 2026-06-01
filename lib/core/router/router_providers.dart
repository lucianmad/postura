import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:postura/core/auth/auth_providers.dart';
import 'package:postura/core/providers/device_providers.dart';
import 'package:postura/core/router/navigation_key.dart';
import 'package:postura/core/router/router.dart';
import 'package:postura/features/calibration/calibration_screen.dart';
import 'package:postura/features/exercise/exercise_screen.dart';
import 'package:postura/features/history/history_screen.dart';
import 'package:postura/features/home/home_screen.dart';
import 'package:postura/features/login/login_screen.dart';
import 'package:postura/features/pairing/pairing_screen.dart';
import 'package:postura/features/settings/settings_screen.dart';
import 'package:postura/features/shell/shell_screen.dart';

final routerProvider = Provider.family<GoRouter, String?>((
  ref,
  initialLocation,
) {
  final notifier = RouterNotifier(ref);
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation ?? '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isLoggedIn = authState.value != null;
      final location = state.matchedLocation;

      if (!isLoggedIn) {
        if (location == '/login') return null;
        return '/login';
      }

      final deviceAsync = ref.read(deviceIdProvider);

      if (deviceAsync.isLoading) return null;

      final hasDevice = deviceAsync.value != null;

      if (location == '/login') {
        return hasDevice ? '/' : '/pairing';
      }

      if (location == '/pairing' && hasDevice) return '/';

      if (!hasDevice && location != '/pairing') return '/pairing';

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/pairing',
        builder: (context, state) => const PairingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const MyHomePage()),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/calibration',
            builder: (context, state) => const CalibrationScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/exercises/:postureType',
        builder: (context, state) {
          final postureType = state.pathParameters['postureType']!;
          return ExerciseScreen(postureType: postureType);
        },
      ),
    ],
  );
});
