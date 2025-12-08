import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'stat_item.dart';
import 'track_control_button.dart';

class SlidingStatsPanel extends StatelessWidget {
  final int steps;
  final double distance;
  final int calories;
  final Duration timeElapsed;
  final VoidCallback onStop;

  const SlidingStatsPanel({
    super.key,
    required this.steps,
    required this.distance,
    required this.calories,
    required this.timeElapsed,
    required this.onStop,
  });

  String get formattedTime {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final h = twoDigits(timeElapsed.inHours);
    final m = twoDigits(timeElapsed.inMinutes.remainder(60));
    return "$h h $m m";
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.30,
      minChildSize: 0.2,
      maxChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 8)
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  /// top handle
                  Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),

                  /// Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StatItem(
                        value: "$steps",
                        label: "steps",
                        image: 'assets/icons/Image (8).png',
                      ),
                      Container(width: 2.w, height: 100.h, color: Colors.grey[300]),
                      StatItem(
                        value: formattedTime,
                        label: "time",
                        image: 'assets/icons/Image (9).png',
                      ),
                      Container(width: 2.w, height: 100.h, color: Colors.grey[300]),
                      StatItem(
                        value: "$calories",
                        label: "kcal",
                        image: 'assets/icons/Image (10).png',
                      ),
                      Container(width: 2.w, height: 100.h, color: const Color.fromRGBO(224, 224, 224, 1)),
                      StatItem(
                        value: distance.toStringAsFixed(2),
                        label: "km",
                        image: 'assets/icons/Image (11).png',
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  /// Stop button
                  TrackControlButton(
                    text: "Stop",
                    isPrimary: false,
                    onPressed: onStop,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
