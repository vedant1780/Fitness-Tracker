import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Screen43 extends StatefulWidget {
  const Screen43({super.key});

  @override
  State<Screen43> createState() => _Screen43State();
}

class _Screen43State extends State<Screen43> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/1.png",
              height: 169.h,
            ),
            SizedBox(
              height: 128.h,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    "Congratulations!",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700, fontSize: 29.sp),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "You've Upgraded to TrackFit Yearly Premium",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400, fontSize: 16.6.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Divider(indent: 21.w, endIndent: 21.w),
            SizedBox(
              height: 313.h,
              child: Padding(
                padding: EdgeInsets.only(left: 115.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25.h),
                    Text(
                      "Benefits Unlocked:",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700, fontSize: 21.sp),
                    ),
                    SizedBox(height: 25.h),
                    _buildBenefit("Detailed Reports"),
                    SizedBox(height: 23.h),
                    _buildBenefit("Personalised Insights"),
                    SizedBox(height: 23.h),
                    _buildBenefit("Exclusive Challenges"),
                    SizedBox(height: 23.h),
                    _buildBenefit("Ad-free Experience"),
                    SizedBox(height: 23.h),
                    _buildBenefit("Priority Support"),
                  ],
                ),
              ),
            ),
            Divider(indent: 21.w, endIndent: 21.w),
            SizedBox(height: 21.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 33.w),
              child: Text(
                "Get ready to take your fitness journey to the next level with TrackFit Premium!",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400, fontSize: 16.6.sp),
              ),
            ),
            SizedBox(height: 20.h),
            Divider(indent: 21.w, endIndent: 21.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
              color: Colors.white,
              child: SizedBox(
                width: 382.w,
                child: MaterialButton(
                  height: 58.h,
                  onPressed: () {
                    GoRouter.of(context).pushNamed('apphome');
                  },
                  color: const Color(0xff7A1FFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                  child: Text(
                    "Start Exploring Premium Features",
                    style: GoogleFonts.inter(
                      fontSize: 16.2.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffDCC5FD),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          "assets/right.png",
          height: 14.h,
          width: 19.w,
        ),
        SizedBox(width: 14.w),
        Text(
          text,
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w400, fontSize: 16.6.sp),
        ),
      ],
    );
  }
}
