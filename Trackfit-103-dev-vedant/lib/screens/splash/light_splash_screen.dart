import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 5 seconds then navigate
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.go('/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color brandPurple = Color.fromRGBO(127, 39, 255, 1);

    return Scaffold(
      backgroundColor: brandPurple,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(64.w), // responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 32.h), // responsive height
              Column(
                children: [
                  Image.asset(
                    'assets/images/trackfit_logo_white.png',
                    height: 130.h, // responsive height
                  ),
                  SizedBox(height: 32.h), // responsive spacing
                  Text(
                    'TrackFit',
                    style: TextStyle(
                      color: const Color.fromRGBO(245, 238, 255, 1),
                      fontSize: 36.7.sp, // responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16.w), // responsive padding
                child: ArcLoader(size: 75.w), // responsive size
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArcLoader extends StatefulWidget {
  final double size;

  const ArcLoader({super.key, this.size = 60});

  @override
  State<ArcLoader> createState() => _ArcLoaderState();
}

class _ArcLoaderState extends State<ArcLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: CustomPaint(
            size: Size(widget.size.w, widget.size.w), // responsive size
            painter: _ArcPainter(strokeWidth: 8.w), // responsive stroke
          ),
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double strokeWidth;

  _ArcPainter({this.strokeWidth = 8});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.width / 2) - strokeWidth / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // 280 degrees arc
    final arcAngle = 280 * math.pi / 180;

    canvas.drawArc(
      rect,
      0, // start angle
      arcAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) => false;
}
