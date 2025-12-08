import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/settings_switch_widget.dart';

class AccountAndSecurityPage extends StatefulWidget {
  const AccountAndSecurityPage({super.key});

  @override
  State<AccountAndSecurityPage> createState() => _AccountAndSecurityPageState();
}

class _AccountAndSecurityPageState extends State<AccountAndSecurityPage> {
  bool biometricEnabled = false;
  bool faceIdEnabled = false;
  bool smsEnabled = false;
  bool googleAuthEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Account & Security',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21.sp, // ✅ responsive font
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pushNamed('acccountpage');
          },
          icon: Icon(
            Icons.arrow_back,
            size: 22.sp, // ✅ responsive icon size
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Switches
            SettingSwitchTile(
              title: "Biometric ID",
              value: biometricEnabled,
              onChanged: (val) => setState(() => biometricEnabled = val),
            ),
            SettingSwitchTile(
              title: "Face ID",
              value: faceIdEnabled,
              onChanged: (val) => setState(() => faceIdEnabled = val),
            ),
            SettingSwitchTile(
              title: "SMS Authenticator",
              value: smsEnabled,
              onChanged: (val) => setState(() => smsEnabled = val),
            ),
            SettingSwitchTile(
              title: "Google Authenticator",
              value: googleAuthEnabled,
              onChanged: (val) => setState(() => googleAuthEnabled = val),
            ),

            // Change Password
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 10.h),
              child: SizedBox(
                height: 18.h,
                child: Row(
                  children: [
                    Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Device Management
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Device Management',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.sp,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Manage your account on the various devices \n you own.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Deactivate + Delete Account
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Deactivate Account
                Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Deactivate Account',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 18.sp,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Temporarily deactivate your account. Easily\nreactivate when you're ready.",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Delete Account
                Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Delete Account',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 18.sp,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Permanently remove your account and data\nProceed with caution.",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
