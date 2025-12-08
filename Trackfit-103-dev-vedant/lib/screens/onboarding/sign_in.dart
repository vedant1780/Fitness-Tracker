import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarckfit/widgets/template.dart';

const themeColor = Color(0xFF661FCC);

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignInPage> {
  bool _agree = false;

  @override
  Widget build(BuildContext context) {
    return Template(
      title: "Welcome back! 👋",
      subtitle: "Sign in to continue your fitness journey.",
      value: _agree,
      onChanged: (val) => setState(() => _agree = val ?? false),
      text: 'Remember me  ',
      linktext: 'Forgot Password?',
      onLinkTap: () {
        GoRouter.of(context).pushNamed("forgot");
      },
      style: TextStyle(
        color: themeColor,
        fontWeight: FontWeight.w700,
        fontSize: 15.8.sp, // ✅ responsive font
      ),
      isSeparated: true,
      buttontext: 'Sign in',
      enabled: true,
      isFacebook: true,
    );
  }
}
