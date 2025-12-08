import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final String iconPath;
  final bool obscureText;
  final TextEditingController controller;
  final Widget? suffixIcon;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.iconPath,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.9.sp, // responsive font size
            color: const Color.fromRGBO(64, 64, 64, 1),
          ),
        ),
        SizedBox(height: 9.h), // responsive height
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(250, 250, 250, 1),
            hintText: hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.1.sp, // responsive font size
              color: const Color.fromRGBO(179, 179, 179, 1),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.w), // responsive padding
              child: Image.asset(iconPath, height: 17.h), // responsive height
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r), // responsive radius
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
