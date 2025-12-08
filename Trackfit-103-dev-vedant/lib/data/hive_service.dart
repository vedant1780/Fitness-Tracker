import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'activiy_hive.dart';

class HiveActivityService {
  static const String _boxName = 'activityBox';

  /// Open the Hive box (should be called once, e.g., in main())
  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Activity>(_boxName);
    }
  }

  /// Get the Hive box
  static Box<Activity> get box => Hive.box<Activity>(_boxName);

  /// Add a new activity entry
  static Future<void> addActivity(Activity activity) async {
    final box = Hive.box<Activity>(_boxName);
    await box.add(activity);
  }
  /// Load the provided historyData into Hive for testing and sorting
  static Future<void> loadCustomSampleData() async {
    final box = Hive.box<Activity>(_boxName);
    await box.clear(); // optional: clear old data

    final Map<String, List<Map<String, dynamic>>> historyData = {
      "Today": [
        {"steps": 7892, "time": "135", "calories": 560, "location": "6.8"},
      ],
      "Wednesday,Oct 1,2025": [
        {"steps": 820, "time": "15", "calories": 60, "location": "0.7"},
      ],
      "Thursday,Oct 2,2025": [
        {"steps": 940, "time": "18", "calories": 70, "location": "0.8"},
      ],
      "Friday,Oct 3,2025": [
        {"steps": 720, "time": "12", "calories": 55, "location": "0.6"},
      ],
      "Saturday,Oct 4,2025": [
        {"steps": 650, "time": "10", "calories": 50, "location": "0.5"},
      ],
      "Sunday,Oct 5,2025": [
        {"steps": 880, "time": "16", "calories": 65, "location": "0.7"},
      ],
      "Monday,Oct 6,2025": [
        {"steps": 910, "time": "17", "calories": 70, "location": "0.8"},
      ],
      "Tuesday,Oct 7,2025": [
        {"steps": 740, "time": "13", "calories": 58, "location": "0.6"},
      ],
      "Wednesday,Oct 8,2025": [
        {"steps": 660, "time": "12", "calories": 54, "location": "0.5"},
      ],
      "Thursday,Oct 9,2025": [
        {"steps": 930, "time": "18", "calories": 72, "location": "0.8"},
      ],
      "Friday,Oct 10,2025": [
        {"steps": 850, "time": "15", "calories": 60, "location": "0.7"},
      ],
      "Saturday,Oct 11,2025": [
        {"steps": 780, "time": "14", "calories": 58, "location": "0.6"},
      ],
      "Sunday,Oct 12,2025": [
        {"steps": 890, "time": "17", "calories": 65, "location": "0.7"},
      ],
      "Monday,Oct 13,2025": [
        {"steps": 970, "time": "19", "calories": 75, "location": "0.8"},
      ],
      "Tuesday,Oct 14,2025": [
        {"steps": 820, "time": "16", "calories": 63, "location": "0.7"},
      ],
      "Wednesday,Oct 15,2025": [
        {"steps": 940, "time": "18", "calories": 70, "location": "0.8"},
      ],
      "Thursday,Oct 16,2025": [
        {"steps": 670, "time": "11", "calories": 50, "location": "0.5"},
      ],
      "Friday,Oct 17,2025": [
        {"steps": 880, "time": "15", "calories": 64, "location": "0.7"},
      ],
      "Saturday,Oct 18,2025": [
        {"steps": 930, "time": "17", "calories": 68, "location": "0.8"},
      ],
      "Sunday,Oct 19,2025": [
        {"steps": 720, "time": "13", "calories": 55, "location": "0.6"},
      ],
      "Monday,Oct 20,2025": [
        {"steps": 950, "time": "18", "calories": 72, "location": "0.8"},
      ],
      "Tuesday,Oct 21,2025": [
        {"steps": 880, "time": "15", "calories": 65, "location": "0.7"},
      ],
      "Wednesday,Oct 22,2025": [
        {"steps": 810, "time": "14", "calories": 60, "location": "0.6"},
      ],
      "Thursday,Oct 23,2025": [
        {"steps": 730, "time": "12", "calories": 53, "location": "0.5"},
      ],
      "Friday,Oct 24,2025": [
        {"steps": 960, "time": "19", "calories": 75, "location": "0.8"},
      ],
      "Saturday,Oct 25,2025": [
        {"steps": 870, "time": "16", "calories": 65, "location": "0.7"},
      ],
      "Sunday,Oct 26,2025": [
        {"steps": 790, "time": "14", "calories": 60, "location": "0.6"},
      ],
      "Monday,Oct 27,2025": [
        {"steps": 900, "time": "17", "calories": 68, "location": "0.7"},
      ],
      "Tuesday,Oct 28,2025": [
        {"steps": 650, "time": "11", "calories": 48, "location": "0.5"},
      ],
      "Wednesday,Oct 29,2025": [
        {"steps": 870, "time": "15", "calories": 63, "location": "0.7"},
      ],
      "Thursday,Oct 30,2025": [
        {"steps": 910, "time": "17", "calories": 69, "location": "0.8"},
      ],
      "Friday,Oct 31,2025": [
        {"steps": 990, "time": "20", "calories": 78, "location": "0.9"},
      ],
      "Saturday,Nov 1,2025": [
        {"steps": 6123, "time": "118", "calories": 480, "location": "5.9"},
        {"steps": 3200, "time": "60", "calories": 250, "location": "2.7"},
      ],
      "Sunday,Nov 2,2025": [
        {"steps": 4321, "time": "95", "calories": 390, "location": "4.2"},
      ],
      "Monday,Nov 3,2025": [
        {"steps": 8056, "time": "140", "calories": 620, "location": "7.5"},
      ],
      "Tuesday,Nov 4,2025": [
        {"steps": 7560, "time": "130", "calories": 580, "location": "7.1"},
      ],
      "Wednesday,Nov 5,2025": [
        {"steps": 6890, "time": "125", "calories": 545, "location": "6.4"},
      ],
      "Thursday,Nov 6,2025": [
        {"steps": 7203, "time": "128", "calories": 555, "location": "6.9"},
      ],
      "Friday,Nov 7,2025": [
        {"steps": 8560, "time": "145", "calories": 630, "location": "7.8"},
      ],
      "Saturday,Nov 8,2025": [
        {"steps": 9350, "time": "160", "calories": 670, "location": "8.4"},
      ],
      "Sunday,Nov 9,2025": [
        {"steps": 4020, "time": "75", "calories": 350, "location": "3.9"},
      ],
      "Monday,Nov 10,2025": [
        {"steps": 7764, "time": "133", "calories": 590, "location": "7.2"},
      ],
      "Tuesday,Nov 11,2025": [
        {"steps": 6540, "time": "120", "calories": 520, "location": "6.1"},
      ],
      "Wednesday,Nov 12,2025": [
        {"steps": 8095, "time": "140", "calories": 615, "location": "7.3"},
      ],
      "Thursday,Nov 13,2025": [
        {"steps": 7230, "time": "127", "calories": 560, "location": "6.6"},
      ],
      "Friday,Nov 14,2025": [
        {"steps": 9021, "time": "150", "calories": 650, "location": "8.0"},
      ],
      "Saturday,Nov 15,2025": [
        {"steps": 9600, "time": "165", "calories": 710, "location": "8.7"},
      ],
      "Sunday,Nov 16,2025": [
        {"steps": 4200, "time": "82", "calories": 370, "location": "4.0"},
      ],
      "Monday,Nov 17,2025": [
        {"steps": 7854, "time": "135", "calories": 580, "location": "7.0"},
      ],
      "Tuesday,Nov 18,2025": [
        {"steps": 8123, "time": "140", "calories": 610, "location": "7.4"},
      ],
      "Wednesday,Nov 19,2025": [
        {"steps": 7432, "time": "128", "calories": 560, "location": "6.7"},
      ],
      "Thursday,Nov 20,2025": [
        {"steps": 6920, "time": "115", "calories": 500, "location": "6.0"},
      ],
      "Friday,Nov 21,2025": [
        {"steps": 9050, "time": "150", "calories": 640, "location": "8.2"},
      ],
      "Saturday,Nov 22,2025": [
        {"steps": 9550, "time": "160", "calories": 700, "location": "8.5"},
      ],
      "Sunday,Nov 23,2025": [
        {"steps": 5100, "time": "90", "calories": 410, "location": "4.6"},
      ],
      "Monday,Nov 24,2025": [
        {"steps": 7650, "time": "130", "calories": 570, "location": "6.8"},
      ],
      "Tuesday,Nov 25,2025": [
        {"steps": 8400, "time": "145", "calories": 620, "location": "7.5"},
      ],
      "Wednesday,Nov 26,2025": [
        {"steps": 7300, "time": "125", "calories": 560, "location": "6.5"},
      ],
      "Thursday,Nov 27,2025": [
        {"steps": 6789, "time": "110", "calories": 495, "location": "5.9"},
      ],
      "Friday,Nov 28,2025": [
        {"steps": 9100, "time": "152", "calories": 650, "location": "8.3"},
      ],
      "Saturday,Nov 29,2025": [
        {"steps": 9700, "time": "166", "calories": 720, "location": "8.8"},
      ],
      "Sunday,Nov 30,2025": [
        {"steps": 4200, "time": "80", "calories": 360, "location": "4.1"},
      ],
    };


    final now = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-dd');

    for (var entry in historyData.entries) {
      late String formattedDate;

      if (entry.key == "Today") {
        formattedDate = dateFormatter.format(now);
      } else {
        // Parse keys like “Saturday,Dec 21,2024”
        try {
          final parsed = DateFormat('EEEE,MMM dd,yyyy').parse(entry.key);
          formattedDate = dateFormatter.format(parsed);
        } catch (_) {
          formattedDate = dateFormatter.format(now);
        }
      }

      for (var data in entry.value) {
        final activity = Activity(
          date: formattedDate,
          steps: data['steps'],
          time: int.tryParse(data['time'].toString()) ?? 0,
          calories: data['calories'],
          location: double.tryParse(data['location'].toString()) ?? 0.0,
        );
        await box.add(activity);
      }
    }
  }

  /// Fetch all activities grouped and sorted by date (latest first)
  static Map<String, List<Activity>> getGroupedSortedActivities() {
    final box = Hive.box<Activity>(_boxName);
    final List<Activity> allActivities = box.values.toList();

    Map<String, List<Activity>> grouped = {};
    for (var activity in allActivities) {
      grouped.putIfAbsent(activity.date, () => []).add(activity);
    }

    // Sort by date descending
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // latest first

    Map<String, List<Activity>> sortedGrouped = {
      for (var key in sortedKeys) key: grouped[key]!
    };

    return sortedGrouped;
  }

  /// Fetch all stored activities
  static List<Activity> getAllActivities() {
    final box = Hive.box<Activity>(_boxName);
    return box.values.toList();
  }

  /// Get activities by date (format: yyyy-MM-dd)
  static List<Activity> getActivitiesByDate(String date) {
    final box = Hive.box<Activity>(_boxName);
    return box.values.where((activity) => activity.date == date).toList();
  }

  /// Delete an activity by key
  static Future<void> deleteActivity(dynamic key) async {
    final box = Hive.box<Activity>(_boxName);
    await box.delete(key);
  }

  /// Clear all activities (use carefully!)
  static Future<void> clearAll() async {
    final box = Hive.box<Activity>(_boxName);
    await box.clear();
  }

  /// Update an existing activity
  static Future<void> updateActivity(Activity updatedActivity) async {
    final box = Hive.box<Activity>(_boxName);
    if (updatedActivity.isInBox) {
      await updatedActivity.save();
    }
  }
  /// 🟢 Get total steps for a given date (format: yyyy-MM-dd)
  static int getTotalStepsForDate(String date) {
    final box = Hive.box<Activity>(_boxName);
    final dailyActivities =
    box.values.where((activity) => activity.date == date).toList();

    int totalSteps = dailyActivities.fold(0, (sum, activity) => sum + activity.steps);
    return totalSteps;
  }

  /// 🟡 Get total steps for today
  static int getTodayTotalSteps() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return getTotalStepsForDate(today);
  }

  /// 🔵 Get step totals for the last 7 days (week-wise)
  static Map<String, int> getWeeklyStepTotals() {
    final box = Hive.box<Activity>(_boxName);
    final now = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final dayFormatter = DateFormat('EEE'); // e.g. Mon, Tue, Wed

    Map<String, int> weeklyTotals = {};

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final formattedDate = dateFormatter.format(date);
      final dayName = dayFormatter.format(date);

      final totalSteps = box.values
          .where((activity) => activity.date == formattedDate)
          .fold<int>(0, (sum, a) => sum + a.steps);

      weeklyTotals[dayName] = totalSteps;
    }

    return weeklyTotals; // e.g. {Mon: 3200, Tue: 4500, Wed: 5600, ...}
  }

  /// 🟣 Get step totals grouped by each day of the current month
  static Map<String, int> getMonthlyStepTotals() {
    final box = Hive.box<Activity>(_boxName);
    final now = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final dayFormatter = DateFormat('dd'); // e.g. 01, 02, 03

    Map<String, int> monthlyTotals = {};

    // Filter activities for this month only
    final monthlyActivities = box.values.where((activity) {
      final date = DateTime.parse(activity.date);
      return date.month == now.month && date.year == now.year;
    }).toList();

    // Group by date and sum steps
    for (var activity in monthlyActivities) {
      final day = dayFormatter.format(DateTime.parse(activity.date));
      monthlyTotals.update(day, (v) => v + activity.steps, ifAbsent: () => activity.steps);
    }

    // Ensure all days up to today exist (fill missing with 0)
    for (int i = 1; i <= now.day; i++) {
      final day = i.toString().padLeft(2, '0');
      monthlyTotals.putIfAbsent(day, () => 0);
    }

    return monthlyTotals; // e.g. {"01": 3000, "02": 4000, "03": 0, ...}
  }

}
