import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812), // base design size
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: TearDropFill(
                fillPercent: 0.65,
                scale: 1.2,
                waveHeight: 15,
              ),
            ),
          ),
        );
      },
    ),
  );
}

/// Reusable TearDrop widget
class TearDropFill extends StatefulWidget {
  final double fillPercent;
  final double scale;
  final double waveHeight;

  const TearDropFill({
    super.key,
    required this.fillPercent,
    this.scale = 1.0,
    this.waveHeight = 10,
  });

  @override
  State<TearDropFill> createState() => _TearDropFillState();
}

class _TearDropFillState extends State<TearDropFill>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _fillController;
  late Animation<double> _fillAnimation;

  double currentFill = 0.0;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animateTo(widget.fillPercent);
  }

  @override
  void didUpdateWidget(covariant TearDropFill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fillPercent != widget.fillPercent) {
      _animateTo(widget.fillPercent);
    }
  }

  void _animateTo(double target) {
    _fillController.reset();
    _fillAnimation = Tween<double>(begin: currentFill, end: target)
        .animate(CurvedAnimation(parent: _fillController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {
          double oscillation = 0.015 * sin(3 * pi * _fillController.value);
          currentFill = _fillAnimation.value + oscillation;
        });
      });
    _fillController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseSize = Size(160.w, 190.h); // Responsive base size
    final scaledSize = Size(
      baseSize.width * widget.scale,
      baseSize.height * widget.scale,
    );

    return CustomPaint(
      size: scaledSize,
      painter: TearDropBorderPainter(),
      child: ClipPath(
        clipper: TearDropClipper(),
        child: Stack(
          children: [
            // Glassy empty part background
            Container(
              width: scaledSize.width,
              height: scaledSize.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
            // Subtle inner radial shade
            Container(
              width: scaledSize.width,
              height: scaledSize.height,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    Colors.grey.shade500.withOpacity(0.25),
                    Colors.grey.shade100.withOpacity(0.05),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
            // Water animation
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  size: scaledSize,
                  painter: WavePainter(
                    animationValue: _waveController.value,
                    fillPercent: currentFill.clamp(0.0, 1.0),
                    waveHeight: widget.waveHeight.h,
                  ),
                );
              },
            ),
            // Glass highlight overlay
            IgnorePointer(
              child: CustomPaint(
                size: scaledSize,
                painter: GlassHighlightPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Teardrop Clipper
class TearDropClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(size.width / 2, size.height * 0.02);

    path.quadraticBezierTo(
      size.width * -0.12, size.height * 0.45,
      size.width * 0.25, size.height * 0.72,
    );

    path.quadraticBezierTo(
      size.width * 0.50, size.height * 0.9,
      size.width * 0.75, size.height * 0.72,
    );

    path.quadraticBezierTo(
      size.width * 1.12, size.height * 0.45,
      size.width / 2, size.height * 0.02,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

/// Outer glass border
class TearDropBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = TearDropClipper().getClip(size);

    Paint borderPaint = Paint()
      ..color = Colors.grey.shade200.withOpacity(1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25.w  // responsive
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 12.sp);

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Glass highlight overlay
class GlassHighlightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = TearDropClipper().getClip(size);

    Paint highlightPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.8),
          Colors.white.withOpacity(0.004),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0;

    canvas.drawPath(path, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Realistic Wave Painter
class WavePainter extends CustomPainter {
  final double animationValue;
  final double fillPercent;
  final double waveHeight;

  WavePainter({
    required this.animationValue,
    required this.fillPercent,
    required this.waveHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double baseHeight = size.height * (1.0 - fillPercent);

    Paint wavePaint1 = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue.shade400, Colors.blue.shade700],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Paint wavePaint2 = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue.shade200.withOpacity(0.9), Colors.blue.shade600.withOpacity(0.6)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path wavePath1 = Path();
    wavePath1.moveTo(0, size.height);
    wavePath1.lineTo(0, baseHeight);

    Path wavePath2 = Path();
    wavePath2.moveTo(0, size.height);
    wavePath2.lineTo(0, baseHeight);

    for (double x = 0; x <= size.width; x++) {
      double variation = 0.8 + 0.2 * sin((2 * pi / size.width) * x);
      double y1 = waveHeight * variation * sin((2 * pi / size.width) * x + 2 * pi * animationValue) + baseHeight;
      double y2 = waveHeight * variation * sin((2 * pi / size.width) * x - 2 * pi * animationValue + pi) + baseHeight;

      wavePath1.lineTo(x, y1);
      wavePath2.lineTo(x, y2);
    }

    wavePath1.lineTo(size.width, size.height);
    wavePath1.close();

    wavePath2.lineTo(size.width, size.height);
    wavePath2.close();

    canvas.drawPath(wavePath1, wavePaint1);
    canvas.drawPath(wavePath2, wavePaint2);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
