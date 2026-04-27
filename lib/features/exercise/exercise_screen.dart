import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postura/core/data/exercise_data.dart';
import 'package:postura/core/models/posture_status_enum.dart';

class ExerciseScreen extends StatelessWidget {
  final String postureType;
  const ExerciseScreen({super.key, required this.postureType});

  @override
  Widget build(BuildContext context) {
    final status = PostureStatus.fromString(postureType);
    final exercises = exerciseData[status] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(postureType)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time to stretch'),
            Text(
              'You\'ve been in $postureType posture for a considerable amount of time. Here are some exercises that can help.',
            ),
            const SizedBox(height: 20),
            if (exercises.isEmpty)
              const Center(
                child: Text('No exercises available for this posture type.'),
              ),
            ...exercises.map(
              (exercise) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(exercise.description),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Done - I finished the exercises'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
