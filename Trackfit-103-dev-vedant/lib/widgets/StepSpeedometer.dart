import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/tracking_provider.dart'; // <-- your tracking provider

class StepSpeedometer extends ConsumerStatefulWidget {
  final int steps;
  final int goal;

  const StepSpeedometer({
    super.key,
    required this.steps,
    required this.goal,
  });

  @override
  ConsumerState<StepSpeedometer> createState() => _StepSpeedometerState();
}

class _StepSpeedometerState extends ConsumerState<StepSpeedometer> {
  double _lastPercent = 0.0; // stores progress when paused

  @override
  Widget build(BuildContext context) {
    final isTracking = ref.watch(trackingStateProvider);
    double percent;

    if (!isTracking) {
      // freeze progress when paused
      percent = _lastPercent;
    } else {
      percent = widget.steps / widget.goal;
      if (percent > 1) percent = 1;
      _lastPercent = percent;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: CustomPaint(
        size: Size(320.w, 320.w),
        painter: _SpeedometerPainter(percent),
        child: SizedBox(
          width: 320.w,
          height: 320.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 8.h),
              Text(
                "Steps",
                style: TextStyle(
                  fontSize: 16.6.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "${widget.steps}",
                style: TextStyle(
                  fontSize: 45.9.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "/${widget.goal}",
                style: TextStyle(
                  fontSize: 15.4.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 32.h),

              /// 🔹 Play / Pause button
              GestureDetector(
                onTap: () {
                  final notifier = ref.read(trackingStateProvider.notifier);
                  notifier.state = !isTracking;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isTracking
                            ? "Tracking paused"
                            : "Tracking started",
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(127, 39, 255, 1),
                      width: 2.w,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: isTracking
                      ? Icon(
                    Icons.pause,
                    color: const Color.fromRGBO(127, 39, 255, 1),
                    size: 32.sp,
                  )
                      : Icon(
                    Icons.play_arrow,
                    color: const Color.fromRGBO(127, 39, 255, 1),
                    size: 32.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeedometerPainter extends CustomPainter {
  final double percent;

  _SpeedometerPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 25.w;
    final strokeWidth = 27.w;

    // Background arc
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(227, 226, 226, 1),
          Color.fromARGB(255, 226, 225, 225),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Progress arc (same color always)
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromRGBO(127, 39, 255, 1),
          Color.fromRGBO(127, 39, 255, 1),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = pi * 0.70;
    const sweepAngle = pi * 1.60;

    // Draw arcs
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle, false, backgroundPaint);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle * percent, false, progressPaint);

    // Tick marks
    final tickPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.5.w;

    const tickCount = 15;
    for (int i = 0; i < tickCount; i++) {
      final tickAngle = startAngle + (sweepAngle / (tickCount - 1)) * i;
      final startTick = Offset(
        center.dx + cos(tickAngle) * (radius - 30.w),
        center.dy + sin(tickAngle) * (radius - 30.w),
      );
      final endTick = Offset(
        center.dx + cos(tickAngle) * (radius - 35.w),
        center.dy + sin(tickAngle) * (radius - 35.w),
      );
      canvas.drawLine(startTick, endTick, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
