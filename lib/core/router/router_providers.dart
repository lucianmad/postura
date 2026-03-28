import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:postura/core/auth/auth_providers.dart';
import 'package:postura/core/router/router.dart';
import 'package:postura/features/calibration/calibration_screen.dart';
import 'package:postura/features/history/history_screen.dart';
import 'package:postura/features/home/home_screen.dart';
import 'package:postura/features/login/login_screen.dart';
import 'package:postura/features/settings/settings_screen.dart';
import 'package:postura/features/shell/shell_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isLoggedIn = authState.value != null;
      final isOnLoginPage = state.matchedLocation == '/login';

      if (!isLoggedIn && !isOnLoginPage) return '/login';
      if (isLoggedIn && isOnLoginPage) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) {
          return ShellScreen(child: child);
        },
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
    ],
  );
});
