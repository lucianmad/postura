import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:postura/core/data/exercise_data.dart';
import 'package:postura/core/models/posture_status_enum.dart';
import 'package:postura/core/theme/app_theme.dart';

class ExerciseScreen extends StatelessWidget {
  final String postureType;
  const ExerciseScreen({super.key, required this.postureType});

  @override
  Widget build(BuildContext context) {
    final status = PostureStatus.fromString(postureType);
    final exercises = exerciseData[status] ?? [];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: status.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: status.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Time to stretch!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Recommended exercises for ${status.displayName}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: exercises.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sentiment_satisfied_outlined,
                            size: 48,
                            color: AppColors.neutral,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No exercises available',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: exercises.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: AppColors.accent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        exercise.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  exercise.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Done — I\'ve stretched!'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
