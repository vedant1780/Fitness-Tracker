import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const themeColor = Color(0xFF661FCC);

class TrackControlButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const TrackControlButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? themeColor : const Color.fromRGBO(245, 238, 255, 1),
        foregroundColor: isPrimary ? const Color.fromRGBO(222, 199, 253, 1) : themeColor,
        minimumSize: Size.fromHeight(58.h), // responsive height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.r), // responsive radius
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: isPrimary ? 15.1.sp : 15.4.sp, // responsive font size
        ),
      ),
    );
  }
}
