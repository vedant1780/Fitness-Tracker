import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/accout_tile_widget.dart';


class LinkedAccountsPage extends StatelessWidget {
  const LinkedAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Linked Accounts",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AccountTile(
              icon: Image.asset("assets/google.png", height: 28.h),
              name: "Google",
              status: "Connected",
              statusColor: Colors.grey[700]!,
            ),
    SizedBox(height: 17),
            AccountTile(
              icon: Image.asset("assets/apple.png", height: 28.h),
              name: "Apple",
              status: "Connected",
              statusColor: Colors.grey[700]!,
            ),
       SizedBox(height: 17.h),
            AccountTile(
              icon: Image.asset("assets/facebook.png", height: 28.h),
              name: "Facebook",
              status: "Connect",
              statusColor: Color(0xFF7a00ff),
            ),
        SizedBox(height: 17.h),
            AccountTile(
              icon: Image.asset("assets/twitter.png", height: 28),
              name: "Twitter",
              status: "Connect",
              statusColor: Color(0xFF7a00ff),
            ),
          ],
        ),
      ),
    );
  }
}

