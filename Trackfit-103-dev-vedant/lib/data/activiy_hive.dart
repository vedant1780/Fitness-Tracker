import 'package:hive/hive.dart';
part 'activiy_hive.g.dart';

@HiveType(typeId: 0)
class Activity extends HiveObject {
  @HiveField(0)
  String date; // yyyy-MM-dd

  @HiveField(1)
  int steps;

  @HiveField(2)
  int time; // in minutes

  @HiveField(3)
  int calories;

  @HiveField(4)
  double location;

  Activity({
    required this.date,
    required this.steps,
    required this.time,
    required this.calories,
    required this.location,
  });
}