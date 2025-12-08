import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/activiy_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/hive_service.dart';

/// Model class for summarized totals
class ActivitySummary {
  final int totalSteps;
  final int totalTime;
  final double totalLocation;
  final int totalCalories;

  const ActivitySummary({
    required this.totalSteps,
    required this.totalTime,
    required this.totalLocation,
    required this.totalCalories,
  });
}

/// Riverpod StreamProvider — emits new totals automatically
final activitySummaryProvider = StreamProvider<ActivitySummary>((ref) async* {
  await HiveActivityService.init();
  final box = Hive.box<Activity>('activityBox');

  // Emit initial totals
  yield _calculateTotals(box);

  // Reactively update on box changes
  await for (final _ in box.watch()) {
    yield _calculateTotals(box);
  }
});

/// Helper to calculate totals from all stored Activity records
ActivitySummary _calculateTotals(Box<Activity> box) {
  final activities = box.values.toList();

  final totalSteps = activities.fold<int>(0, (sum, a) => sum + a.steps);
  final totalTime = activities.fold<int>(0, (sum, a) => sum + a.time);
  final totalCalories = activities.fold<int>(0, (sum, a) => sum + a.calories);
  final totalLocation = activities.fold<double>(0.0, (sum, a) => sum + a.location);

  return ActivitySummary(
    totalSteps: totalSteps,
    totalTime: totalTime,
    totalLocation: totalLocation,
    totalCalories: totalCalories,
  );
}
