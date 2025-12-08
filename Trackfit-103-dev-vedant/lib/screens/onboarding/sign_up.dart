import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarckfit/widgets/template.dart';

const themeColor = Color(0xFF661FCC);

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _agree = false;

  @override
  Widget build(BuildContext context) {
    return Template(
      title: "Join TrackFit Today 👤",
      subtitle: "Create your account and start tracking your steps.",
      value: _agree,
      onChanged: (val) => setState(() => _agree = val ?? false),
      text: 'I agree to TrackFit',
      linktext: ' Terms & Conditions.',
      onLinkTap: () {
        GoRouter.of(context).pushNamed('terms');
      },
      style: TextStyle(
        color: themeColor,
        fontWeight: FontWeight.w400,
        fontSize: 16.9.sp, // ✅ responsive font size
      ),
      isAlready: true,
      buttontext: 'Sign up',
      enabled: _agree,
    );
  }
}
