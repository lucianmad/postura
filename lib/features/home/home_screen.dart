import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:postura/core/models/posture_status_enum.dart';
import 'package:postura/core/theme/app_theme.dart';
import 'package:postura/core/widgets/stat_bar.dart';
import 'package:postura/features/history/history_providers.dart';
import 'package:postura/features/home/home_providers.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postureStreamStatus = ref.watch(postureStateProvider);
    final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final sessionsAsync = ref.watch(sessionLogProvider(dateStr));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Postura',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                _greeting(),
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              postureStreamStatus.when(
                data: (state) {
                  final postureState = PostureStatus.fromString(state.status);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: 220,
                          width: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: postureState.color,
                            boxShadow: [
                              BoxShadow(
                                color: postureState.color.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 40,
                                spreadRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              postureState.displayName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.good,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm:ss').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                state.timestamp * 1000,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text(err.toString()),
              ),
              const SizedBox(height: 32),
              sessionsAsync.when(
                data: (sessions) {
                  final totalDuration = sessions.fold(
                    0,
                    (sum, s) => sum + s.duration,
                  );
                  final neutralDuration = sessions
                      .where(
                        (s) =>
                            s.postureStatus.category == PostureCategory.neutral,
                      )
                      .fold(0, (sum, s) => sum + s.duration);
                  final activeDuration = totalDuration - neutralDuration;
                  final goodDuration = sessions
                      .where(
                        (s) => s.postureStatus.category == PostureCategory.good,
                      )
                      .fold(0, (sum, s) => sum + s.duration);
                  final badDuration = sessions
                      .where(
                        (s) => s.postureStatus.category == PostureCategory.bad,
                      )
                      .fold(0, (sum, s) => sum + s.duration);
                  final informationalDuration = sessions
                      .where(
                        (s) =>
                            s.postureStatus.category ==
                            PostureCategory.informational,
                      )
                      .fold(0, (sum, s) => sum + s.duration);

                  final worstPosture = sessions
                      .where(
                        (s) => s.postureStatus.category == PostureCategory.bad,
                      )
                      .fold<Map<PostureStatus, int>>({}, (map, s) {
                        map[s.postureStatus] =
                            (map[s.postureStatus] ?? 0) + s.duration;
                        return map;
                      });
                  final dominantBad = worstPosture.isNotEmpty
                      ? (worstPosture.entries.toList()
                              ..sort((a, b) => b.value.compareTo(a.value)))
                            .first
                            .key
                      : null;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Today\'s summary',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${totalDuration ~/ 60} min',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sessions.isEmpty
                                ? 'No session data yet - start your device'
                                : '${activeDuration ~/ 60} min of active tracking',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          StatBar(
                            label: 'Good',
                            duration: goodDuration,
                            total: activeDuration,
                            color: AppColors.good,
                          ),
                          const SizedBox(height: 8),
                          StatBar(
                            label: 'Bad',
                            duration: badDuration,
                            total: activeDuration,
                            color: AppColors.bad,
                          ),
                          const SizedBox(height: 8),
                          StatBar(
                            label: 'Informational',
                            duration: informationalDuration,
                            total: activeDuration,
                            color: AppColors.info,
                          ),
                          if (dominantBad != null) ...[
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => context.go(
                                  '/exercises/${dominantBad.name}',
                                ),
                                child: const Text(
                                  'See recommended exercises ->',
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, stk) => Text(err.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
