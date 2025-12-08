import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

import '../../data/hive_service.dart';
import '../../data/prefs_hive_service.dart';
import '../../widgets/progress_calender.dart';
import '../../widgets/custom_dropdown.dart';
import '../../providers/activity_summary.dart';
import '../../data/activiy_hive.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  int selectedBar = 4;
  String _selectedRange = "This Week";
  String _selectedMetric = "Steps";
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    HiveActivityService.init();
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(activitySummaryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: InkWell(
            onTap: () => GoRouter.of(context).pushNamed('apphome'),
            child: Image.asset("assets/foot.png", height: 24.h, width: 24.w),
          ),
        ),
        title: Center(
          child: Text(
            "Report",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 21.sp,
              color: const Color(0xFF3C3C3C),
            ),
          ),
        ),
        actions: const [
          Icon(Icons.more_vert, color: Colors.black87),
          SizedBox(width: 12),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error loading data: $e")),
        data: (summary) {
          final box = Hive.box<Activity>('activityBox');
          final stepGoal = HiveService2.getPreference('stepGoal') ?? 10000;

          final chartDataBundle = _getChartData();
          final labels = chartDataBundle.keys.toList();
          final chartValues =
          chartDataBundle.values.map((e) => e.toDouble()).toList();

          final progress = _getProgressData(box, stepGoal, _selectedMonth);

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildStepsSummary(summary),
                SizedBox(height: 13.h),
                _buildStatisticsChart(chartValues, labels),
                SizedBox(height: 10.h),

                /// ✅ Functional Progress Calendar (with internal dropdown)
                ProgressCalendar(
                  year: _selectedMonth.year,
                  month: _selectedMonth.month,
                  progress: progress,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ✅ Calculate Monthly Progress (used by ProgressCalendar)
  Map<int, double> _getProgressData(
      Box<Activity> box, int stepGoal, DateTime month) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final progress = <int, double>{};

    for (int day = 1; day <= daysInMonth; day++) {
      final formatted = DateFormat('yyyy-MM-dd')
          .format(DateTime(month.year, month.month, day));
      final steps = box.values
          .where((a) => a.date == formatted)
          .fold<int>(0, (sum, a) => sum + a.steps);
      progress[day] = (steps / stepGoal).clamp(0.0, 1.0);
    }
    return progress;
  }

  /// ✅ Chart Data Generator
  Map<String, int> _getChartData() {
    final box = Hive.box<Activity>('activityBox');
    final now = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final weeklyTotals = <String, int>{};
    final monthlyTotals = <String, int>{};

    if (_selectedRange == "This Week") {
      final dayFormatter = DateFormat('EEE');
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final formattedDate = dateFormatter.format(date);
        final dayName = dayFormatter.format(date);
        int total = 0;

        for (var activity in box.values.where((a) => a.date == formattedDate)) {
          switch (_selectedMetric) {
            case "Steps":
              total += activity.steps;
              break;
            case "Time":
              total += activity.time;
              break;
            case "Calorie":
              total += activity.calories;
              break;
            case "Distance":
              total += activity.location.round();
              break;
          }
        }
        weeklyTotals[dayName] = total;
      }
      return weeklyTotals;
    } else {
      final currentMonth = now.month;
      final currentYear = now.year;
      final dayFormatter = DateFormat('dd');
      final monthlyActivities = box.values.where((activity) {
        final date = DateTime.parse(activity.date);
        return date.month == currentMonth && date.year == currentYear;
      });

      for (var a in monthlyActivities) {
        final day = dayFormatter.format(DateTime.parse(a.date));
        monthlyTotals.update(day, (v) {
          switch (_selectedMetric) {
            case "Steps":
              return v + a.steps;
            case "Time":
              return v + a.time;
            case "Calorie":
              return v + a.calories;
            case "Distance":
              return v + a.location.round();
            default:
              return v;
          }
        }, ifAbsent: () {
          switch (_selectedMetric) {
            case "Steps":
              return a.steps;
            case "Time":
              return a.time;
            case "Calorie":
              return a.calories;
            case "Distance":
              return a.location.round();
            default:
              return 0;
          }
        });
      }

      for (int i = 1; i <= now.day; i++) {
        final day = i.toString().padLeft(2, '0');
        monthlyTotals.putIfAbsent(day, () => 0);
      }
      return monthlyTotals;
    }
  }

  /// ✅ Steps Summary Card
  Widget _buildStepsSummary(ActivitySummary summary) {
    final hours = (summary.totalTime ~/ 60);
    final minutes = (summary.totalTime % 60);

    return Container(
      height: 210.h,
      margin: EdgeInsets.only(left: 16.w, top: 12.h, right: 17.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4.r, offset: Offset(0, 2.h))
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/unfilled foot.png",
                  height: 24.h, width: 24.w),
              SizedBox(width: 6.w),
              Text(
                "${summary.totalSteps}",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text("Total steps all the time",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
          SizedBox(height: 16.h),
          Divider(color: Colors.grey[300], thickness: 1.h),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildStat("assets/access_time.png", Colors.orange,
                  "${hours}h ${minutes}m", "time"),
              _verticalDivider(),
              _buildStat("assets/flame.png", Colors.red,
                  (summary.totalCalories).toStringAsFixed(0), "kcal"),
              _verticalDivider(),
              _buildStat("assets/location.png", Colors.green,
                  summary.totalLocation.toStringAsFixed(2), "km"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStat(String imagePath, Color color, String value, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imagePath, height: 26.h, color: color),
          SizedBox(height: 6.h),
          Text(value,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          SizedBox(height: 2.h),
          Text(label,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _verticalDivider() =>
      Container(height: 50.h, width: 1.w, color: Colors.grey[300]);

  /// ✅ Chart Section
  Widget _buildStatisticsChart(List<double> chartData, List<String> labels) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4.r, offset: Offset(0, 2.h))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Statistics",
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
              CustomDropdown(
                items: const ["Today", "This Week", "This Month"],
                initialValue: _selectedRange,
                onChanged: (value) {
                  setState(() => _selectedRange = value);
                },
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 220.h,
            child: SfCartesianChart(
              primaryXAxis:
              CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                interval: 2000,
                majorGridLines: const MajorGridLines(width: 0),
                axisLabelFormatter: (args) => ChartAxisLabel(
                  '${args.value ~/ 1000}k',
                  TextStyle(fontSize: 12.sp, color: Colors.black),
                ),
              ),
              tooltipBehavior:
              TooltipBehavior(enable: true, header: '', format: 'point.y'),
              series: <CartesianSeries<_ChartData, String>>[
                ColumnSeries<_ChartData, String>(
                  dataSource: List.generate(
                      chartData.length,
                          (i) => _ChartData(labels[i], chartData[i])),
                  xValueMapper: (_ChartData data, _) => data.day,
                  yValueMapper: (_ChartData data, _) => data.value,
                  pointColorMapper: (_ChartData data, index) =>
                  index == selectedBar
                      ? const Color(0xFF7a00ff)
                      : const Color(0xFFc297ff),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r)),
                  width: 0.7,
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTab("Steps", _selectedMetric == "Steps"),
              _buildTab("Time", _selectedMetric == "Time"),
              _buildTab("Calorie", _selectedMetric == "Calorie"),
              _buildTab("Distance", _selectedMetric == "Distance"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _selectedMetric = label),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF7a00ff) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp),
        ),
      ),
    );
  }

  /// ✅ Bottom Navigation
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF9C5BFE),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      currentIndex: 2,
      items: [
        _navItem('Home', 'us_home.png', 'apphome'),
        _navItem('Track', 'track.png', '/track'),
        _navItem('Report', 'selected_report.png', 'report'),
        _navItem('History', 'history.png', 'history'),
        _navItem('Account', 'account.png', 'acccountpage'),
      ],
    );
  }

  BottomNavigationBarItem _navItem(
      String label, String iconPath, String route) {
    return BottomNavigationBarItem(
      icon: InkWell(
        onTap: () => GoRouter.of(context).pushNamed(route),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Image.asset('assets/icons/$iconPath', height: 24.h),
        ),
      ),
      label: label,
    );
  }
}

class _ChartData {
  final String day;
  final double value;
  _ChartData(this.day, this.value);
}
