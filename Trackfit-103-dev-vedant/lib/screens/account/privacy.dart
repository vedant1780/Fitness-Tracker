import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18.8.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Effective Date: December 19, 2024",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16.9.sp),
            ),
            SizedBox(height: 33.h),
            Text(
              "1. Information Collection and Use:",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18.2.sp),
            ),
            SizedBox(height: 13.h),
            Text(
              "• We collect personal information such as name, email address, age, gender, height, weight, and fitness data (e.g.step count, activity duration) to provide and improve our services.",
              style: TextStyle(fontSize: 16.9.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              "• Your information is used to personalize your experience, track your fitness activity, provide insights and recommendations, and communicate with you about our services.",
              style: TextStyle(fontSize: 16.9.sp),
            ),
            SizedBox(height: 28.h),
            Text(
              "2. Data Sharing and Disclosure:",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18.2.sp),
            ),
            SizedBox(height: 11.h),
            Text(
              "• We do not sell, rent, or share your personal information with third parties for marketing purposes.",
              style: TextStyle(fontSize: 16.9.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              "• We may share your information with service providers who assist us in providing our services, but they are contractually obligated to protect your information.",
              style: TextStyle(fontSize: 16.9.sp),
            ),
            SizedBox(height: 3.h),
            Text(
              "• We may also share aggregated or anonymized data for research or analytical purposes.",
              style: TextStyle(fontSize: 16.9.sp),
            ),
          ],
        ),
      ),
    );
  }
}
