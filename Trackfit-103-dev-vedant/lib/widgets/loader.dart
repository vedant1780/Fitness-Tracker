import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpinningArcLoader extends StatefulWidget {
  final double size;

  const SpinningArcLoader({super.key, this.size = 50});

  @override
  State<SpinningArcLoader> createState() => _SpinningArcLoaderState();
}

class _SpinningArcLoaderState extends State<SpinningArcLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.w,
      height: widget.size.w,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 6.28319, // 2π
            child: CustomPaint(painter: _ArcPainter()),
          );
        },
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = SweepGradient(
      colors: [
        Colors.white,
        const Color(0xFFB084F9),
        const Color(0xFF7B3DE8),
        const Color(0xFF7B3DE8),
        Colors.white,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.r;

    const startAngle = 0.0;
    const sweepAngle = 3.14 * 1.7;

    canvas.drawArc(rect.deflate(3.r), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
