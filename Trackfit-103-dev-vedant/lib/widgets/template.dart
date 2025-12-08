import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tarckfit/widgets/loader.dart';
import 'package:tarckfit/widgets/social.dart';
import 'package:tarckfit/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../providers/auth_provider.dart';

const themeColor = Color(0xFF661FCC);

class Template extends ConsumerStatefulWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;
  final String linktext;
  final VoidCallback onLinkTap;
  final TextStyle style;
  final bool isAlready;
  final String buttontext;
  final bool enabled;
  final VoidCallback? onPressed;
  final bool isFacebook;
  final bool isSeparated;

  const Template({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.text,
    required this.linktext,
    required this.onLinkTap,
    required this.style,
    this.isAlready = false,
    required this.buttontext,
    required this.enabled,
    this.onPressed,
    this.isFacebook = false,
    this.isSeparated = false,
  });

  @override
  ConsumerState<Template> createState() => _TemplateState();
}

class _TemplateState extends ConsumerState<Template> {
  bool _passwordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 🔹 Show loader
  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SpinningArcLoader(size: 55),
              SizedBox(height: 20.h),
              Text(
                message,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Helper: redirect user after auth
  Future<void> _redirectBasedOnFirestore(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!mounted) return;
    Navigator.pop(context); // close loader safely

    if (userDoc.exists && (userDoc.data()?['age'] != null)) {
      debugPrint("✅ Onboarding data found → redirecting to home");
      if (mounted) context.goNamed('apphome');
    } else {
      debugPrint("🆕 No onboarding data → redirecting to gender screen");
      if (mounted) context.goNamed('gender');
    }
  }

  // 🔹 Email/Password Auth
  Future<void> _handleEmailAuth() async {
    _showLoadingDialog(widget.isAlready ? "Signing up..." : "Signing in...");
    try {
      final auth = FirebaseAuth.instance;
      UserCredential userCredential;

      if (widget.isAlready) {
        userCredential = await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        userCredential = await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      final uid = userCredential.user?.uid;
      if (uid != null) {
        await _redirectBasedOnFirestore(uid);
      } else {
        if (mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not found")),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentication failed")),
      );
    }
  }

  // 🔹 Google Sign-In
  Future<void> _handleGoogleSignIn() async {
    _showLoadingDialog("Signing in with Google...");
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (mounted) Navigator.pop(context); // user canceled
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        if (mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google sign-in failed: No user data")),
        );
        return;
      }

      await _redirectBasedOnFirestore(user.uid);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint("❌ Google Sign-in error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // Auto-redirect if already signed in
    if (authState.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.goNamed('gender');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => GoRouter.of(context).goNamed("splash"),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title,
                  style: TextStyle(fontSize: 29.1.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 11.h),
              Text(widget.subtitle,
                  style: TextStyle(
                    color: const Color(0xFF838383),
                    fontSize: 16.9.sp,
                    fontWeight: FontWeight.w400,
                  )),
              SizedBox(height: 36.h),

              // 🔹 Email & Password Fields
              LabeledTextField(
                label: "Email",
                hintText: "Email",
                iconPath: "assets/icons/Image (5).png",
                controller: _emailController,
              ),
              SizedBox(height: 19.h),
              LabeledTextField(
                label: "Password",
                hintText: "Password",
                iconPath: "assets/icons/Image (6).png",
                controller: _passwordController,
                obscureText: !_passwordVisible,
                suffixIcon: IconButton(
                  icon: _passwordVisible
                      ? const Icon(Icons.visibility, color: themeColor)
                      : Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Image.asset("assets/icons/Image (7).png", height: 17.h),
                  ),
                  onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),

              // 🔹 Terms Checkbox
              SizedBox(height: 14.h),
              Row(
                children: [
                  Checkbox(
                    value: widget.value,
                    activeColor: themeColor,
                    checkColor: Colors.white,
                    side: BorderSide(color: themeColor, width: 3.w),
                    onChanged: widget.onChanged,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.8.sp,
                          color: const Color.fromRGBO(88, 88, 88, 1),
                        ),
                        children: [
                          TextSpan(text: widget.text),
                          TextSpan(
                            text: widget.linktext,
                            recognizer: TapGestureRecognizer()..onTap = widget.onLinkTap,
                            style: widget.style,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // 🔹 Sign Up / Sign In Link
              if (widget.isAlready)
                Padding(
                  padding: EdgeInsets.only(bottom: 36.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 17.2.sp,
                            color: const Color.fromRGBO(92, 92, 92, 1),
                          )),
                      GestureDetector(
                        onTap: () => GoRouter.of(context).pushNamed('signin'),
                        child: Text("Sign in",
                            style: TextStyle(
                              color: themeColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.6.sp,
                            )),
                      ),
                    ],
                  ),
                ),

              // 🔹 Social Buttons
              Row(
                children: const [
                  Expanded(child: Divider(color: Color(0xFFF6F6F6))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text("or",
                        style: TextStyle(
                            color: Color.fromRGBO(140, 141, 141, 1),
                            fontWeight: FontWeight.w400)),
                  ),
                  Expanded(child: Divider(color: Color(0xFFF6F6F6))),
                ],
              ),
              SizedBox(height: 26.h),

              SocialButton(
                text: "Continue with Google",
                iconPath: "assets/icons/Image (3).png",
                onPressed: _handleGoogleSignIn,
              ),
              SizedBox(height: 21.h),
              SocialButton(
                text: "Continue with Apple",
                iconPath: "assets/icons/Image (4).png",
                onPressed: () {},
              ),
              if (widget.isFacebook) ...[
                SizedBox(height: 21.h),
                SocialButton(
                  text: "Continue with Facebook",
                  iconPath: "assets/icons/Group 1000000938 (1).png",
                  onPressed: () {},
                ),
              ],
              SizedBox(height: 23.h),

              // 🔹 Submit Button
              ElevatedButton(
                onPressed: widget.enabled ? _handleEmailAuth : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  minimumSize: Size.fromHeight(58.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                child: Text(
                  widget.buttontext,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.4.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
