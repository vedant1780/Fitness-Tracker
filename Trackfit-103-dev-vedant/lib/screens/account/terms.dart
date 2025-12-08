import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Terms of Services",
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
              "Effective Date: December 20, 2024",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            SizedBox(height: 33.h),
            Text(
              "1. Acceptance of Terms",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.9.sp),
            ),
            SizedBox(height: 11.h),
            Text(
              "By accessing or using TrackFit, you agree to be bound by these Terms of Service and our Privacy Policy. If you do not agree to these terms, you may not use TrackFit.",
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 28.h),
            Text(
              "2. Use of Services",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.9.sp),
            ),
            SizedBox(height: 11.h),
            Text(
              "You may use TrackFit for your personal, non-commercial use only. You may not modify, reproduce, distribute, or resell TrackFit or any content within TrackFit without our written permission.",
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 28.h),
            Text(
              "3. User Content",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.9.sp),
            ),
            SizedBox(height: 11.h),
            Text(
              "You retain ownership of any content you upload, submit, or display on TrackFit. By posting content, you grant us a worldwide, non-exclusive, royalty-free license to use, reproduce, modify, adapt, publish, translate, and distribute your content in any form.",
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 28.h),
            Text(
              "4. Intellectual Property",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.9.sp),
            ),
            SizedBox(height: 11.h),
            Text(
              "All content, features, and functionality within TrackFit are the exclusive property of TrackFit or its licensors and are protected by",
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
