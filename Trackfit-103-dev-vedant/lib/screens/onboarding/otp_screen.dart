import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarckfit/screens/onboarding/password.dart';

class Screen20 extends StatefulWidget {
  const Screen20({super.key});

  @override
  State<Screen20> createState() => _Screen20State();
}

class _Screen20State extends State<Screen20> {
  final List<TextEditingController> otpControllers =
  List.generate(4, (_) => TextEditingController());
  int secondsRemaining = 60;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
        startCountdown();
      }
    });
  }

  Widget buildOtpBox(int index) {
    return Container(
      width: 70.w,
      height: 70.w,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      child: Center(
        child: TextField(
          controller: otpControllers[index],
          autofocus: index == 0,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.inter(fontSize: 24.sp),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
              BorderSide(color: const Color(0xFF7F27FF), width: 4.w),
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < otpControllers.length - 1) {
              FocusScope.of(context).nextFocus();
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).previousFocus();
            }

            bool allFilled = otpControllers
                .every((controller) => controller.text.isNotEmpty);

            if (allFilled) {
              String otp = otpControllers.map((c) => c.text).join();
              debugPrint("Entered OTP: $otp");

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewPasswordScreen(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, size: 24.sp),
        ),
      ),
      body: SafeArea( // ✅ Added SafeArea here
        maintainBottomViewPadding: true, // keeps layout spacing identical
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 178.h,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 21.h, left: 25.w),
                    child: Row(
                      children: [
                        Text(
                          "Enter OTP Code",
                          style: GoogleFonts.inter(
                            fontSize: 29.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Image.asset(
                          "assets/lock.png",
                          height: 30.h,
                          width: 30.w,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 25.h, left: 25.w, right: 25.w),
                    child: SizedBox(
                      height: 87.h,
                      width: 366.w,
                      child: Text(
                        "Check your email inbox for a one-time passcode (OTP) from TrackFit. Enter the code below to continue.",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color: const Color(0xFF868686),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, buildOtpBox),
            ),
            SizedBox(height: 30.h),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You can resend the code in ',
                    style: GoogleFonts.inter(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF868686),
                    ),
                  ),
                  Text(
                    '$secondsRemaining ',
                    style: GoogleFonts.inter(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7F27FF),
                    ),
                  ),
                  Text(
                    'seconds ',
                    style: GoogleFonts.inter(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF868686),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(342.w, 48.h),
                  backgroundColor: const Color(0xFF7F27FF),
                  foregroundColor: Colors.white,
                ),
                onPressed: secondsRemaining == 0
                    ? () {
                  setState(() {
                    secondsRemaining = 60;
                    startCountdown();
                  });
                }
                    : null,
                child: Text(
                  "Resend Code",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
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

// ✅ Dummy next page for testing navigation
class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("✅ OTP Verified! Welcome Next Page"),
      ),
    );
  }
}
