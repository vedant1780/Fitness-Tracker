import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> contacts = [
      {"title": "Customer Support", "icon": "assets/icons/Image (25).png"},
      {"title": "Website", "icon": "assets/icons/Image (24).png"},
      {"title": "WhatsApp", "icon": "assets/icons/Image (20).png"},
      {"title": "Facebook", "icon": "assets/icons/Image (21).png"},
      {"title": "X (Formerly Twitter)", "icon": "assets/icons/Image (22).png"},
      {"title": "Instagram", "icon": "assets/icons/Image (23).png"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 22.sp, // ✅ responsive icon size
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Contact Support",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22.sp, // ✅ responsive font size
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w), // ✅ responsive padding
        itemCount: contacts.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h), // ✅ responsive spacing
        itemBuilder: (context, index) {
          final item = contacts[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r), // ✅ responsive border radius
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6.r, // ✅ responsive blur
                  offset: Offset(0, 3.h), // ✅ responsive shadow offset
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              leading: Image.asset(
                item["icon"]!,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
              ),
              title: Text(
                item["title"],
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp, // ✅ responsive font size
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp, // ✅ responsive trailing icon
              ),
              onTap: () {
                // TODO: handle tap actions
              },
            ),
          );
        },
      ),
    );
  }
}
