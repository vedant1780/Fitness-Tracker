import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:tarckfit/screens/account/FAQ.dart';
import 'package:tarckfit/screens/account/privacy.dart';
import 'package:tarckfit/screens/account/terms.dart';
import 'contact_support.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {"title": "FAQ", "widget": const FAQScreen()},
      {"title": "Contact Support", "widget": const ContactSupportScreen()},
      {"title": "Privacy Policy", "widget": const PrivacyPolicyScreen()},
      {"title": "Terms of Service", "widget": const TermsOfServiceScreen()},
      {"title": "Partner"},
      {"title": "Job Vacancy"},
      {"title": "Accessibility"},
      {"title": "Feedback"},
      {"title": "About us"},
      {"title": "Rate us"},
      {"title": "Visit Our Website"},
      {"title": "Follow us on Social Media"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 22.sp, // ✅ responsive icon
          ),
          onPressed: () {
            GoRouter.of(context).pushNamed('acccountpage');
          },
        ),
        title: Text(
          "Help & Support",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 19.sp, // ✅ responsive font size
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final item = options[index];
          return ListTile(
            title: Text(
              item["title"],
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17.sp, // ✅ responsive font size
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.sp, // ✅ responsive icon size
            ),
            onTap: item["widget"] != null
                ? () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item["widget"]),
            )
                : null,
          );
        },
      ),
    );
  }
}
