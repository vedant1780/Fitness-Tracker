import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen>
    with SingleTickerProviderStateMixin {
  String selectedGender = "";
  late AnimationController _animationController;
  late Animation<double> _manAnimation;
  late Animation<double> _womanAnimation;
  late Animation<Alignment> _manAlignmentAnimation;
  late Animation<Alignment> _womanAlignmentAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Initial animations
    _manAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _womanAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // ✅ Start with man on left, woman on right
    _manAlignmentAnimation = Tween<Alignment>(
      begin: const Alignment(-0.7, 0),
      end: const Alignment(-0.7, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _womanAlignmentAnimation = Tween<Alignment>(
      begin: const Alignment(0.7, 0),
      end: const Alignment(0.7, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });

    if (gender == "Man") {
      _manAnimation = Tween<double>(begin: _manAnimation.value, end: 1.2).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _womanAnimation = Tween<double>(begin: _womanAnimation.value, end: 0.8).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _manAlignmentAnimation = Tween<Alignment>(
        begin: _manAlignmentAnimation.value,
        end: Alignment.center,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _womanAlignmentAnimation = Tween<Alignment>(
        begin: _womanAlignmentAnimation.value,
        end: const Alignment(1.2, 0),
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
    } else {
      _manAnimation = Tween<double>(begin: _manAnimation.value, end: 0.8).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _womanAnimation = Tween<double>(begin: _womanAnimation.value, end: 1.2).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _manAlignmentAnimation = Tween<Alignment>(
        begin: _manAlignmentAnimation.value,
        end: const Alignment(-1.2, 0),
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _womanAlignmentAnimation = Tween<Alignment>(
        begin: _womanAlignmentAnimation.value,
        end: Alignment.center,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
    }

    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top progress bar
            _buildProgressBar(),

            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select Your",
                  style: TextStyle(
                    fontSize: 28.6.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  " Gender",
                  style: TextStyle(
                    fontSize: 28.6.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(150, 79, 255, 1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              "Let's start by understanding you.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.6.sp,
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(height: 30.h),

            // Gender Selection Container (Fixed height to avoid overflow)
            SizedBox(
              height: 0.55.sh, // 55% of screen height
              width: double.infinity,
              child: Stack(
                children: [
                  // Man
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Align(
                        alignment: _manAlignmentAnimation.value,
                        child: Transform.scale(
                          scale: _manAnimation.value,
                          child: _buildGenderCard(
                            "Man",
                            "assets/images/gender_man.png",
                            selectedGender == "Man",
                          ),
                        ),
                      );
                    },
                  ),

                  // Woman
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Align(
                        alignment: _womanAlignmentAnimation.value,
                        child: Transform.scale(
                          scale: _womanAnimation.value,
                          child: _buildGenderCard(
                            "Woman",
                            "assets/images/gender_woman.png",
                            selectedGender == "Woman",
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Spacer(),

            // Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        GoRouter.of(context).pushNamed("onboarding");
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF7F27FF),
                        side: const BorderSide(color: Colors.transparent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        backgroundColor: const Color.fromRGBO(245, 238, 255, 1),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        var box = Hive.box('userPrefs');
                        await box.put('gender', selectedGender); // Store selected gender
                        print("Saved gender: $selectedGender");
                        GoRouter.of(context).pushNamed("onboarding");
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF7F27FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black87),
      onPressed: () async {
        try {
          final auth = FirebaseAuth.instance;
          final currentUser = auth.currentUser;
          final googleSignIn = GoogleSignIn();

          // ✅ Check if user is signed in via Google
          final googleAccount = await googleSignIn.signInSilently();

          if (googleAccount != null) {
            // User signed in with Google
            await googleSignIn.disconnect();
            await auth.signOut();
            print("🔒 Logged out from Google account.");
          } else {
            // User signed in with Email/Password
            await auth.signOut();
            print("🔒 Logged out from Email/Password account.");
          }

          // ✅ Clear local Hive data
          final box = await Hive.openBox('userPrefs');
          await box.clear();

          // ✅ Navigate back to welcome or root screen
          if (context.mounted) {
            GoRouter.of(context).go('/');
          }

          print("✅ Logged out successfully and cleared all data.");
        } catch (e) {
          print("❌ Error during logout: $e");
        }
      },
    ),


          SizedBox(width: 32.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(10.r),
                value: 1 / 6,
                backgroundColor: Colors.black12,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(150, 79, 255, 1),
                ),
                minHeight: 17.h,
              ),
            ),
          ),
          SizedBox(width: 32.w),
          Text(
            '1/6',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16.9.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 Fixed version with responsive sizing
  Widget _buildGenderCard(String gender, String imagePath, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectGender(gender),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isSelected ? 0.5.sw : 0.38.sw,
            height: isSelected ? 0.45.sh : 0.38.sh,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected) ...[
                  Positioned(
                    top: 0.12.sh,
                    child: Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(150, 79, 255, 1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: ClipOval(
                      child: Container(
                        width: 0.4.sw,
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(150, 79, 255, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                if (!isSelected)
                  Positioned(
                    bottom: 0,
                    child: ClipOval(
                      child: Container(
                        width: 0.35.sw,
                        height: 40.h,
                        decoration: const BoxDecoration(color: Colors.black12),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  child: Image.asset(
                    imagePath,
                    height: isSelected ? 0.42.sh : 0.35.sh,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            gender,
            style: TextStyle(
              fontSize: isSelected ? 20.sp : 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}