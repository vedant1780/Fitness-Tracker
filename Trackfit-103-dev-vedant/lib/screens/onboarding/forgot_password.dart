import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'otp_screen.dart';

class Screen19 extends StatefulWidget {
  const Screen19({super.key});

  @override
  State<Screen19> createState() => _Screen19State();
}

class _Screen19State extends State<Screen19> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // keeps layout fixed
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(onTap:(){GoRouter.of(context).pushNamed("signin");},child: Icon(Icons.arrow_back, size: 24.sp)),
      ),
      body: SafeArea( // ✅ Added SafeArea here
        maintainBottomViewPadding: true, // keeps padding behavior consistent
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
                        Expanded(
                          child: Text(
                            "Forgot Your Password ?",
                            style: GoogleFonts.inter(
                              fontSize: 29.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Image.asset(
                          "assets/key.png",
                          height: 32.h,
                          width: 32.w,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25.h),
                    child: SizedBox(
                      height: 87.h,
                      width: 366.w,
                      child: Text(
                        "Enter the email associated with your TrackFit account below. We'll send you a one-time passcode (OTP) to reset your password.",
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
            SizedBox(
              height: 126.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.h, left: 25.w),
                    child: Text(
                      "Your Registered Email",
                      style: GoogleFonts.inter(
                        fontSize: 16.3.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF525252),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 19.w, top: 20.h, right: 19.w),
                    child: TextField(
                      controller: emailController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Image.asset(
                            "assets/email.png",
                            height: 20.h,
                            width: 20.w,
                          ),
                        ),
                        hintText: "Enter your email",
                        hintStyle: GoogleFonts.inter(fontSize: 14.sp),
                        filled: true,
                        fillColor: const Color(0xfff9f9f9),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              child: SizedBox(
                height: 66.h,
                width: 389.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F27FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Screen20()),
                    );
                  },
                  child: Text(
                    "Send OTP Code",
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
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
