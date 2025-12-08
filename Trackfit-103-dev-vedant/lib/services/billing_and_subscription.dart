import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillingAndSubscriptionPage extends StatelessWidget {
  const BillingAndSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87, size: 24.sp),
          onPressed: () => GoRouter.of(context).pushNamed('acccountpage'),
        ),
        title: Text(
          "Billing & Subscriptions",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        child: Column(
          children: [
            // Card with badge
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x15000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "TrackFit Premium",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // Price row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "\$49.99",
                            style: TextStyle(
                              fontSize: 42.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "/ year",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 18.h),
                      Divider(height: 1.h, color: const Color(0xFFE5E5E5)),
                      SizedBox(height: 12.h),

                      _buildBenefit("All Monthly Subscription benefits +"),
                      _buildBenefit(
                          "Exclusive access to premium workout programs and challenges."),
                      _buildBenefit(
                          "In-app coaching and personalized feedback from fitness experts (limited sessions)."),
                      _buildBenefit("Earn premium badges and rewards."),
                      _buildBenefit(
                          "Discounts on partner fitness products and services."),

                      SizedBox(height: 18.h),
                      Divider(height: 1.h, color: const Color(0xFFE5E5E5)),
                      SizedBox(height: 29.h),
                      Center(
                        child: Text(
                          "Your current plan",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7a00ff),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12.r),
                        bottomLeft: Radius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Save 17%",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 22.h),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
                children: [
                  const TextSpan(
                    text: "Your subscription will expire on Dec 22, 2025.\n"
                        "Renew or cancel your subscription ",
                  ),
                  TextSpan(
                    text: "here.",
                    style: TextStyle(
                      color: const Color(0xFF6C4EFF),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildBenefit(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: 18.sp, color: Colors.black87),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.sp, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
