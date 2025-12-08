import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tarckfit/screens/account/water_tracker_settings.dart';
import 'package:tarckfit/widgets/droplet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Screen47 extends StatefulWidget {
  const Screen47({super.key});

  @override
  State<Screen47> createState() => _Screen47State();
}

class _Screen47State extends State<Screen47> {
  final List<String> days = ["16", "17", "18", "19", "20", "21", "22"];
  final List<double> values = [3000, 2750, 1200, 4000, 1800, 2400, 3200];

  int? touchedIndex;

  double currentIntake = 1750;
  double dailyGoal = 4000;
  bool isDrinking = false;

  Future<void> startDrinking() async {
    if (isDrinking) return;
    setState(() => isDrinking = true);

    double targetIntake = (currentIntake + 250).clamp(0, dailyGoal);
    while (currentIntake < targetIntake) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        currentIntake = (currentIntake + 25).clamp(0, dailyGoal);
      });
    }

    setState(() => isDrinking = false);
  }

  @override
  Widget build(BuildContext context) {
    double percentage = (currentIntake / dailyGoal) * 100;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        leading: InkWell(
            onTap: () {
              GoRouter.of(context).pushNamed('acccountpage');
            },
            child: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp)),
        title: Text(
          "Water Tracker",
          style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 27.w),
            child: InkWell(
              child: Image.asset(
                "assets/icons/settings.png",
                height: 25.h,
                width: 25.w,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Screen49()),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12.h, left: 24.w, right: 19.w),
        child: Column(
          children: [
            Container(
              height: 458.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 25.h),
                  TearDropFill(fillPercent: percentage / 100, scale: 1.4),
                  Text("${percentage.toStringAsFixed(0)}%",
                      style: GoogleFonts.inter(
                          fontSize: 27.5.sp, fontWeight: FontWeight.w600)),
                  SizedBox(height: 15.h),
                  Text("${currentIntake.toInt()} / ${dailyGoal.toInt()} ml",
                      style: GoogleFonts.inter(fontSize: 15.7.sp)),
                  SizedBox(height: 15.h),
                  SizedBox(
                    height: 50.h,
                    width: 160.w,
                    child: ElevatedButton(
                      onPressed: startDrinking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDrinking
                            ? const Color(0xffF5F5F5)
                            : const Color(0xff7F27FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.r),
                          side: isDrinking
                              ? const BorderSide(
                              color: Color(0xff7F27FF), width: 2)
                              : BorderSide.none,
                        ),
                      ),
                      child: Text(
                        isDrinking ? "Drinking..." : "Drink",
                        style: GoogleFonts.inter(
                          fontSize: 13.5.sp,
                          color: isDrinking
                              ? const Color(0xff7F27FF)
                              : const Color(0xffD9BFFE),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            Container(
              height: 280.h,
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final chartHeight = 175.h;
                  final chartWidth = constraints.maxWidth - 40.w;
                  final barSpace = chartWidth / values.length;

                  return Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 50.h),
                          SizedBox(
                            height: chartHeight,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 4000,
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  handleBuiltInTouches: false,
                                  touchCallback: (event, response) {
                                    if (response != null &&
                                        response.spot != null &&
                                        event.isInterestedForInteractions) {
                                      setState(() {
                                        touchedIndex =
                                            response.spot!.touchedBarGroupIndex;
                                      });
                                    } else {
                                      setState(() {
                                        touchedIndex = null;
                                      });
                                    }
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40.w,
                                      interval: 1000,
                                      getTitlesWidget: (value, meta) {
                                        if (value % 1000 == 0) {
                                          return Text("${value ~/ 1000}k",
                                              style: TextStyle(fontSize: 12.sp));
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value.toInt() >= 0 &&
                                            value.toInt() < days.length) {
                                          return Text(days[value.toInt()],
                                              style: TextStyle(fontSize: 12.sp));
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                  rightTitles:
                                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles:
                                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                barGroups: values
                                    .asMap()
                                    .map((i, val) => MapEntry(
                                  i,
                                  BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: val,
                                        width: 30.w,
                                        color: touchedIndex == i
                                            ? const Color(0xff7F27FF)
                                            : const Color(0xffc297ff),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12.r),
                                          topRight: Radius.circular(12.r),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                                    .values
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (touchedIndex != null)
                        Positioned(
                          left: (touchedIndex! * barSpace) + (barSpace / 2) + 17.w,
                          bottom: (values[touchedIndex!] / 4000 * chartHeight),
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xff7F27FF),
                            ),
                            child: Container(
                              height: 45.h,
                              width: 35.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: Text(
                                    "${values[touchedIndex!].toInt()}\nml",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff7F27FF),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
