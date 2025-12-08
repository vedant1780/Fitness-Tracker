import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Center part
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/Image.png',
                      width: 100.w, // ✅ responsive width
                      height: 100.w, // ✅ responsive height
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Text(
                    "You're All Set!",
                    style: TextStyle(
                      fontSize: 24.sp, // ✅ responsive font
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      "Your password has been successfully updated.",
                      style: TextStyle(
                        fontSize: 14.sp, // ✅ responsive font
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom button
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A2BE2), // Purple
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r), // ✅ responsive radius
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.h), // ✅ responsive padding
                  ),
                  onPressed: () {
                    GoRouter.of(context).pushNamed("signin");
                  },
                  child: Text(
                    "Go to Homepage",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp, // ✅ responsive font
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
