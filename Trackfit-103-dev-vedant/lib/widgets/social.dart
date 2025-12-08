import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size.fromHeight(58.h),
        side: const BorderSide(color: Color.fromRGBO(236, 236, 236, 1)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              iconPath,
              height: 24.h,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: const Color.fromRGBO(73, 73, 73, 1),
              fontWeight: FontWeight.w700,
              fontSize: 14.6.sp,
            ),
          ),
        ],
      ),
    );
  }
}
