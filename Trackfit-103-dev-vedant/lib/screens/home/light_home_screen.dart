import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tarckfit/data/prefs_hive_service.dart';
import 'package:tarckfit/widgets/StepSpeedometer.dart';
import '../../data/hive_service.dart';
import '../../providers/activity_summary.dart';
import '../../providers/tracking_provider.dart'; // ✅ your Hive activity service

class HomeScreen extends ConsumerStatefulWidget {
  bool isPaused = false;
  HomeScreen({super.key, this.isPaused = false});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedPeriod = 'week'; // ✅ new variable to toggle between week & month

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(activitySummaryProvider);
    final isTracking = ref.watch(trackingStateProvider);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).push('/apphome');
            },
            child: Image.asset("assets/icons/foot.png", height: 24.h, width: 24.w),
          ),
        ),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Home',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 21.5.sp,
                ),
              ),
            ),
            PopupMenuButton(
              iconSize: 25.sp,
              iconColor: Colors.black,
              onSelected: (value) {
                if (value == 1) {
                  print(value);
                }
              },
              itemBuilder: (context) {
                return [const PopupMenuItem(value: 1, child: Text("Home"))];
              },
            ),
          ],
        ),
      ),
      body: summaryAsync.when(
        data: (summary) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StepSpeedometer(
                  steps: summary.totalSteps,
                  goal: (HiveService2.getPreference('stepGoal') ?? 6000) as int,
                  //isPaused: !isTracking,
                ),
                SizedBox(height: 16.h),
                _buildSummaryCards(summary),
                SizedBox(height: 16.h),
                _buildYourProgress(), // ✅ dynamically switches between week & month
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// ✅ Summary Cards
  Widget _buildSummaryCards(ActivitySummary summary) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _buildSummaryCard(
              'assets/icons/clock.png',
              _formatTime(summary.totalTime),
              'time',
            ),
          ),
          Expanded(
            child: _buildSummaryCard(
              'assets/icons/fire.png',
              (summary.totalCalories).toStringAsFixed(0),
              'kcal',
              isBordered: true,
            ),
          ),
          Expanded(
            child: _buildSummaryCard(
              'assets/icons/location.png',
              summary.totalLocation.toStringAsFixed(2),
              'km',
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  Widget _buildSummaryCard(
      String icon,
      String value,
      String label, {
        bool isBordered = false,
      }) {
    return Container(
      decoration: isBordered
          ? BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.black26, width: 1.w),
          right: BorderSide(color: Colors.black26, width: 1.w),
        ),
      )
          : null,
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(icon, height: 24.h),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(fontSize: 20.7.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15.1.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Weekly or Monthly Progress
  Widget _buildYourProgress() {
    final stepGoal = HiveService2.getPreference('stepGoal') ?? 6000;
    final weeklySteps = HiveActivityService.getWeeklyStepTotals();
    final monthlySteps = HiveActivityService.getMonthlyStepTotals(); // ✅ new
    final data =
    selectedPeriod == 'week' ? weeklySteps : monthlySteps; // switch logic

    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color.fromRGBO(236, 236, 237, 1),
                  width: 1.w,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Your Progress',
                  style: TextStyle(fontSize: 17.2.sp, fontWeight: FontWeight.bold),
                ),
                _buildWeekDropdown(), // ✅ now toggles between week & month
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data.entries.map((entry) {
                final label = entry.key;
                final steps = entry.value;
                final progress = (steps / stepGoal).clamp(0.0, 1.0);
                final isToday = _isToday(label);

                return _buildDailyProgress(
                  day: label,
                  date: selectedPeriod == 'week'
                      ? _getDateForDay(label)
                      : label, // show date number or day name
                  progress: progress,
                  isToday: isToday,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Helper: convert weekday name to date
  String _getDateForDay(String weekday) {
    final now = DateTime.now();
    final todayWeekday = now.weekday;
    final targetWeekday = _weekdayToInt(weekday);
    final difference = targetWeekday - todayWeekday;
    final targetDate = now.add(Duration(days: difference));
    return targetDate.day.toString();
  }

  int _weekdayToInt(String weekday) {
    switch (weekday) {
      case 'Mon':
        return 1;
      case 'Tue':
        return 2;
      case 'Wed':
        return 3;
      case 'Thu':
        return 4;
      case 'Fri':
        return 5;
      case 'Sat':
        return 6;
      case 'Sun':
        return 7;
      default:
        return DateTime.now().weekday;
    }
  }

  bool _isToday(String weekday) {
    final todayWeekday = DateFormat('EEE').format(DateTime.now());
    return todayWeekday == weekday;
  }

  /// ✅ Dropdown to toggle between week and month
  Widget _buildWeekDropdown() {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = selectedPeriod == 'week' ? 'month' : 'week';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(color: const Color.fromRGBO(236, 236, 237, 1)),
        ),
        child: Row(
          children: <Widget>[
            Text(
              selectedPeriod == 'week' ? 'This Week' : 'This Month',
              style: TextStyle(
                color: const Color.fromRGBO(91, 91, 91, 1),
                fontSize: 12.4.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyProgress({
    required String day,
    required String date,
    required double progress,
    bool isToday = false,
  }) {
    final color = Colors.grey.shade300;
    final textColor = isToday
        ? const Color.fromRGBO(127, 39, 255, 1)
        : const Color.fromRGBO(142, 142, 142, 1);
    final progressColor = const Color.fromRGBO(127, 39, 255, 1);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3.5.w,
                  backgroundColor: color,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
                Center(
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: textColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            day,
            style: TextStyle(
              color: textColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF9C5BFE),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      currentIndex: 0,
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 6.h, top: 6.h),
            child: Image.asset('assets/icons/home_icon.png', height: 24.h),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 6.h, top: 6.h),
            child: InkWell(
              onTap: () {
                GoRouter.of(context).go("/track");
              },
              child: Image.asset('assets/icons/track.png', height: 24.h),
            ),
          ),
          label: 'Track',
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () {
              GoRouter.of(context).pushNamed("report");
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 6.h, top: 6.h),
              child: Image.asset('assets/icons/report.png', height: 24.h),
            ),
          ),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () {
              GoRouter.of(context).pushNamed('history');
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 6.h, top: 6.h),
              child: Image.asset('assets/icons/history.png', height: 24.h),
            ),
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('acccountpage');
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 6.h, top: 6.h),
              child: Image.asset('assets/icons/account.png', height: 24.h),
            ),
          ),
          label: 'Account',
        ),
      ],
    );
  }
}
