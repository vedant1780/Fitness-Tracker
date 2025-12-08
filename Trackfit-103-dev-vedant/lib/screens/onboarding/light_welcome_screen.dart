import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../widgets/loader.dart';
import '../../providers/auth_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SpinningArcLoader(size: 55),
                SizedBox(height: 20.h),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
    _showLoadingDialog(context, "Signing in with Google...");
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Navigator.pop(context); // user canceled
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 🔹 Sign in with Firebase
      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      Navigator.pop(context); // Close loading dialog

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User info not found")),
        );
        return;
      }

      // 🔹 Check Firestore for onboarding data
      final docRef =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnap = await docRef.get();

      if (docSnap.exists && (docSnap.data()?['age'] != 0)) {
        // ✅ Existing user with onboarding data → go home
        debugPrint("✅ Onboarding data found. Redirecting to home...");
        if (context.mounted) {
          context.goNamed('apphome');
        }
      } else {
        // 🆕 New user or missing onboarding → go to onboarding
        debugPrint("🆕 No onboarding data. Redirecting to gender screen...");
        if (context.mounted) {
          context.goNamed('gender');
        }
      }
    } catch (e) {
      Navigator.pop(context);
      debugPrint("❌ Google Sign-in error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // ✅ FIX: Don’t push every frame — just check once when authenticated
    if (authState.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        final docSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnap.exists && (docSnap.data()?['age'] != null)) {
          if (context.mounted) context.goNamed('apphome');
        } else {
          if (context.mounted) context.goNamed('gender');
        }
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ UI unchanged
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 32.h),
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
              child: Image.asset(
                'assets/images/trackfit_logo.png',
                height: 65.h,
              ),
            ),
            SizedBox(height: 32.h),
            Column(
              children: [
                Text(
                  'Let\'s Get Started!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.6.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Let\'s dive into your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.6.sp,
                    color: const Color.fromRGBO(139, 139, 139, 1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSocialButton(
                  icon: 'assets/images/google.png',
                  text: 'Continue with Google',
                  onPressed: () => _handleGoogleSignIn(context, ref),
                ),
                SizedBox(height: 12.h),
                _buildSocialButton(
                  icon: 'assets/images/apple.png',
                  text: 'Continue with Apple',
                  onPressed: () {},
                ),
                SizedBox(height: 12.h),
                _buildSocialButton(
                  icon: 'assets/images/facebook.png',
                  text: 'Continue with Facebook',
                  onPressed: () {},
                ),
                SizedBox(height: 12.h),
                _buildSocialButton(
                  icon: 'assets/images/twitter.png',
                  text: 'Continue with Twitter',
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed("signup");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F27FF),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    side: const BorderSide(
                      color: Color.fromRGBO(143, 66, 255, 1.0),
                    ),
                  ),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.4.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                OutlinedButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed("signin");
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40.h),
                    backgroundColor: const Color(0xFFF5EEFF),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    side: const BorderSide(color: Color(0xFFF5EEFF)),
                  ),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color: const Color.fromRGBO(150, 80, 255, 1.0),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 48.h),
            Text(
              'Privacy Policy Terms of Service',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5.sp,
                color: const Color.fromRGBO(139, 139, 139, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        side: const BorderSide(color: Color.fromRGBO(235, 235, 236, 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(icon, height: 23.h),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.6.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: 23.w),
        ],
      ),
    );
  }
}
