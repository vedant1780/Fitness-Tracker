import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Screen41 extends StatefulWidget {
  const Screen41({super.key});

  @override
  State<Screen41> createState() => _Screen41State();
}

class _Screen41State extends State<Screen41> {
  bool isMonthly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xffF5F5F5),
        leading: Icon(Icons.arrow_back, size: 30.sp),
        centerTitle: true,
        title: Text(
          "Review Summary",
          style: GoogleFonts.inter(fontSize: 21.8.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 17.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(17.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6.r,
                            offset: Offset(0, 3.h),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "TrackFit Premium",
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff464646),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          /// Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                isMonthly ? "\$4.99" : "\$49.99",
                                style: GoogleFonts.inter(
                                  fontSize: 42.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Padding(
                                padding: EdgeInsets.only(bottom: 6.h),
                                child: Text(
                                  isMonthly ? "/month" : "/year",
                                  style: GoogleFonts.inter(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Divider(thickness: 1),
                          SizedBox(height: 16.h),

                          /// Features list
                          Column(
                            children:
                            (isMonthly ? _monthlyFeatures() : _yearlyFeatures())
                                .map((text) => _buildFeatureRow(text))
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                    /// Save Tag (only for yearly)
                    if (!isMonthly)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Color(0xff7B20FE),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(14.r),
                              bottomLeft: Radius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            "Save 17%",
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Text(
              "Selected Payment Method",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 16.3.sp,
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 23.w),
            child: Container(
              height: 95.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Row(
                children: [
                  SizedBox(width: 24.w),
                  Image.asset("assets/master_card.png", height: 60.h, width: 60.w),
                  SizedBox(width: 16.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Master Card",
                        style: GoogleFonts.inter(
                          fontSize: 16.2.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4B4B4B),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        "---------..-- 1679",
                        style: GoogleFonts.inter(
                          fontSize: 10.8.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 75.w),
                  Text(
                    "Change",
                    style: GoogleFonts.inter(
                      fontSize: 16.6.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff7A1FFE),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 25.h),
            color: Colors.white,
            child: SizedBox(
              width: 382.w,
              child: MaterialButton(
                height: 58.h,
                onPressed: () {},
                color: Color(0xff7A1FFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
                child: Text(
                  "Confirm Payment - \$49.99",
                  style: GoogleFonts.inter(
                    fontSize: 16.2.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffDCC5FD),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/right.png", height: 14.h, width: 19.w),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _monthlyFeatures() => [
    "All Free Version benefits +",
    "Set personalized goals and track progress.",
    "Access detailed workout routines and training plans.",
    "Join community challenges and compete with friends.",
    "Advanced data insights and reports.",
    "Ad-free experience.",
  ];

  List<String> _yearlyFeatures() => [
    "All Free Version benefits +",
    "Exclusive access to premium workout programs and challenges.",
    "In-app coaching and personalized feedback from fitness experts (limited sessions).",
    "Earn premium badges and rewards.",
    "Discounts on partner fitness products and services.",
  ];
}
