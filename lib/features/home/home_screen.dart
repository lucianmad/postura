import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:postura/core/models/posture_status_enum.dart';
import 'package:postura/core/widgets/stat_bar.dart';
import 'package:postura/features/history/history_providers.dart';
import 'package:postura/features/home/home_providers.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postureStreamStatus = ref.watch(postureStateProvider);
    final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final sessionsAsync = ref.watch(sessionLogProvider(dateStr));

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: postureStreamStatus.when(
          data: (state) {
            final postureState = PostureStatus.fromString(state.status);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: postureState.color,
                    ),
                    child: Center(
                      child: Text(
                        state.status,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight(900),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    DateFormat('dd/MM/yyyy HH:mm:ss').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        state.timestamp * 1000,
                      ),
                    ),
                  ),
                ),
                sessionsAsync.when(
                  data: (sessions) {
                    final totalDuration = sessions.fold(
                      0,
                      (sum, s) => sum + s.duration,
                    );

                    final neutralDuration = sessions
                        .where(
                          (s) =>
                              s.postureStatus.category ==
                              PostureCategory.neutral,
                        )
                        .fold(0, (sum, s) => sum + s.duration);

                    final activeDuration = totalDuration - neutralDuration;

                    final goodDuration = sessions
                        .where(
                          (s) =>
                              s.postureStatus.category == PostureCategory.good,
                        )
                        .fold(0, (sum, s) => sum + s.duration);

                    final badDuration = sessions
                        .where(
                          (s) =>
                              s.postureStatus.category == PostureCategory.bad,
                        )
                        .fold(0, (sum, s) => sum + s.duration);

                    final informationalDuration = sessions
                        .where(
                          (s) =>
                              s.postureStatus.category ==
                              PostureCategory.informational,
                        )
                        .fold(0, (sum, s) => sum + s.duration);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Today\'s summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sessions.isEmpty
                              ? 'No session data yet - start your device'
                              : '${activeDuration ~/ 60} min of active tracking',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 18),
                        StatBar(
                          label: 'Good',
                          duration: goodDuration,
                          total: activeDuration,
                          color: Colors.green,
                        ),
                        StatBar(
                          label: 'Bad',
                          duration: badDuration,
                          total: activeDuration,
                          color: Colors.red,
                        ),
                        StatBar(
                          label: 'Informational',
                          duration: informationalDuration,
                          total: activeDuration,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total tracked: ${totalDuration ~/ 60} min',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => CircularProgressIndicator(),
                  error: (err, stk) => Text(err.toString()),
                ),
              ],
            );
          },
          loading: () => CircularProgressIndicator(),
          error: (err, stack) => Text(err.toString()),
        ),
      ),
    );
  }
}
