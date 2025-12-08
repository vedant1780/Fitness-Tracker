import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/activiy_hive.dart';
import '../../data/hive_service.dart';

class Screen34 extends StatefulWidget {
  const Screen34({super.key});

  @override
  State<Screen34> createState() => _Screen34State();
}

class _Screen34State extends State<Screen34> {
  Map<String, List<Map<String, dynamic>>> historyData = {};

  @override
  void initState() {
    super.initState();
    _loadHistoryFromHive();
  }

  Future<void> _loadHistoryFromHive() async {
    final grouped = HiveActivityService.getGroupedSortedActivities();
    final Map<String, List<Map<String, dynamic>>> converted = {};

    final now = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(now);

    // ✅ Sort date keys descending (latest date first)
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    for (final date in sortedKeys) {
      final activities = grouped[date]!;
      String displayDate;

      if (date == todayKey) {
        displayDate = "Today";
      } else {
        final parsed = DateFormat('yyyy-MM-dd').parse(date);
        displayDate = DateFormat('EEEE,MMM dd,yyyy').format(parsed);
      }

      // ✅ Reverse each day's activity list (latest first)
      final reversedActivities = activities.reversed.toList();

      converted[displayDate] = reversedActivities.map((a) {
        return {
          "steps": a.steps,
          "time": a.time.toString(),
          "calories": a.calories,
          "location": a.location.toString(),
        };
      }).toList();
    }

    setState(() {
      historyData = converted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyKeys = historyData.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 26.w),
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('apphome');
            },
            child: Image.asset("assets/app.png", height: 24.h, width: 23.w),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24.w),
            child: Icon(Icons.more_vert, size: 22.sp),
          ),
        ],
        backgroundColor: const Color(0xfff4f4f4),
        title: Text("History", style: GoogleFonts.inter(fontSize: 18.sp)),
        centerTitle: true,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: historyData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: historyKeys.length,
        itemBuilder: (BuildContext context, int outerIndex) {
          final date = historyKeys[outerIndex];
          final entries = historyData[date]!;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffADAEAE),
                  ),
                ),
                SizedBox(height: 13.h),
                ListView.builder(
                  itemCount: entries.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int innerIndex) {
                    final entry = entries[innerIndex];
                    final entryKey =
                        "$date-${entry["steps"]}-${entry["time"]}-${entry["calories"]}-${entry["location"]}";

                    return Slidable(
                      key: ValueKey(entryKey),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          CustomSlidableAction(
                            onPressed: (_) async {
                              final activities = HiveActivityService.getActivitiesByDate(
                                DateFormat('yyyy-MM-dd').format(
                                  date == "Today"
                                      ? DateTime.now()
                                      : DateFormat('EEEE,MMM dd,yyyy').parse(date),
                                ),
                              );

                              if (activities.isNotEmpty) {
                                await activities.first.delete();
                              }

                              setState(() {
                                entries.removeAt(innerIndex);
                                if (entries.isEmpty) {
                                  historyData.remove(date);
                                }
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.white,
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  duration: const Duration(seconds: 6),
                                  content: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset("assets/delete.png",
                                              height: 21.h, width: 19.w),
                                          SizedBox(width: 12.w),
                                          Text(
                                            'History has been deleted',
                                            style: GoogleFonts.inter(
                                                fontSize: 14.sp,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (!historyData.containsKey(date)) {
                                              historyData[date] = [];
                                            }
                                            historyData[date]!.add(entry);
                                          });
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xFF8A56F9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20.r),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                              vertical: 8.h),
                                        ),
                                        child: Text('Undo',
                                            style: GoogleFonts.inter(
                                                fontSize: 14.sp,
                                                color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            backgroundColor: const Color(0xfff6e4e1),
                            borderRadius: BorderRadius.circular(8.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/delete.png",
                                    height: 21.h, width: 19.w),
                                SizedBox(height: 4.h),
                                Text(
                                  "Delete",
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 19.w, vertical: 22.h),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  _iconText("assets/steps.png",
                                      entry["steps"].toString()),
                                  _iconText("assets/time.png",
                                      entry["time"].toString(),
                                      isTime: true),
                                  _iconText("assets/calorie.png",
                                      entry["calories"].toString()),
                                  _iconText("assets/location.png",
                                      entry["location"].toString()),
                                ],
                              ),
                            ),
                            if (innerIndex < entries.length - 1)
                              Divider(
                                thickness: 1.h,
                                height: 1.h,
                                endIndent: 20.w,
                                indent: 20.w,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _iconText(String assetPath, String value, {bool isTime = false}) {
    String formattedValue;

    if (isTime) {
      final totalMinutes = int.tryParse(value);
      if (totalMinutes != null) {
        final hours = totalMinutes ~/ 60;
        final minutes = totalMinutes % 60;
        formattedValue = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
      } else {
        formattedValue = value;
      }
    } else if (assetPath.contains('location')) {
      final distance = double.tryParse(value);
      formattedValue =
      distance != null ? distance.toStringAsFixed(2) : value;
    } else {
      formattedValue = int.tryParse(value) != null
          ? NumberFormat.decimalPattern().format(int.parse(value))
          : value;
    }

    return Row(
      children: [
        Image.asset(assetPath, height: 19.h, width: 16.w),
        SizedBox(width: 8.w),
        Text(
          formattedValue,
          style:
          GoogleFonts.inter(fontSize: 16.6.sp, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF9C5BFE),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      currentIndex: 3,
      items: [
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () {
              GoRouter.of(context).pushNamed('apphome');
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 6.h, top: 6.h),
              child: Image.asset('assets/icons/us_home.png', height: 24.h),
            ),
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
                child: Image.asset('assets/icons/track.png', height: 24.h)),
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
              child:
              Image.asset('assets/icons/report.png', height: 24.h),
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
              child: Image.asset('assets/icons/selected_history.png',
                  height: 24.h),
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
              child:
              Image.asset('assets/icons/account.png', height: 24.h),
            ),
          ),
          label: 'Account',
        ),
      ],
    );
  }
}
