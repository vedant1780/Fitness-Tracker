import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const themeColor = Color(0xFF661FCC);

class StatItem extends StatelessWidget {
  final String image;
  final String value;
  final String label;

  const StatItem({
    super.key,
    required this.image,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          height: 24.h,
          width: 24.w,
        ),
        SizedBox(height: 16.h),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20.2.sp,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: const Color.fromRGBO(143, 143, 144, 1),
            fontSize: 14.5.sp,
          ),
        ),
      ],
    );
  }
}
