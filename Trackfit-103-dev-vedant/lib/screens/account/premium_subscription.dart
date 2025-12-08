import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Screen38 extends StatefulWidget {
  const Screen38({super.key});

  @override
  State<Screen38> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<Screen38> {
  bool isMonthly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            GoRouter.of(context).pushNamed('acccountpage');
          },
          child: Icon(Icons.arrow_back, size: 28.sp, color: Colors.black),
        ),
        title: Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            "Upgrade Plan",
            style: GoogleFonts.inter(
              fontSize: 22.3.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffF6F6F6),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            /// Toggle Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggle("Monthly", true),
                SizedBox(width: 8.w),
                _buildToggle("Yearly", false),
              ],
            ),
            SizedBox(height: 28.h),

            /// Subscription Card
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
                        offset: const Offset(0, 3),
                      )
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
                          color: const Color(0xff464646),
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
                      Divider(thickness: 1, height: 1.h),
                      SizedBox(height: 16.h),

                      /// Features list
                      Column(
                        children: (isMonthly
                            ? _monthlyFeatures()
                            : _yearlyFeatures())
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff7B20FE),
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

            const Spacer(),

            /// Bottom Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 24.h,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7B20FE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                  onPressed: () {
                    GoRouter.of(context).pushNamed('paymentmethods');
                  },
                  child: Text(
                    isMonthly
                        ? "Continue - \$4.99 / month"
                        : "Continue - \$49.99 / year",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Toggle button builder
  Widget _buildToggle(String label, bool monthly) {
    final selected = monthly == isMonthly;
    return GestureDetector(
      onTap: () => setState(() => isMonthly = monthly),
      child: Container(
        width: 160.w,
        height: 42.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF7F27FF) : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14.6.sp,
          ),
        ),
      ),
    );
  }

  /// Feature row widget
  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/right.png",
            height: 14.h,
            width: 19.w,
          ),
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

  /// Monthly features list
  List<String> _monthlyFeatures() => [
    "All Free Version benefits +",
    "Set personalized goals and track progress.",
    "Access detailed workout routines and training plans.",
    "Join community challenges and compete with friends.",
    "Advanced data insights and reports.",
    "Ad-free experience.",
  ];

  /// Yearly features list
  List<String> _yearlyFeatures() => [
    "All Free Version benefits +",
    "Exclusive access to premium workout programs and challenges.",
    "In-app coaching and personalized feedback from fitness experts (limited sessions).",
    "Earn premium badges and rewards.",
    "Discounts on partner fitness products and services.",
  ];
}
