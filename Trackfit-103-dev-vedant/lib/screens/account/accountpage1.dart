import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tarckfit/providers/auth_provider.dart';
import 'package:tarckfit/screens/account/preferences.dart';
import 'package:tarckfit/screens/account/water_tracker.dart';
import 'package:tarckfit/screens/onboarding/sign_in.dart';

class AccountPage1 extends ConsumerStatefulWidget {
  const AccountPage1({super.key});

  @override
  ConsumerState<AccountPage1> createState() => _AccountPage1State();
}

class _AccountPage1State extends ConsumerState<AccountPage1> {
  int _selectedIndex = 0;

  void _showLogoutPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 295.h,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Divider(thickness: 1.h),
                    ),
                    Padding(
                      padding: EdgeInsets.all(29.w),
                      child: Text(
                        "Are you sure you want to log out?",
                        style: TextStyle(
                          fontSize: 18.3.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Divider(thickness: 1.h),
                    ),
                    SizedBox(height: 16.h),

                    /// Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 182.w,
                          height: 58.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5EEFF),
                            borderRadius: BorderRadius.circular(26.r),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: themeColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          width: 182.w,
                          height: 58.h,
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(26.r),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              Navigator.pop(context); // Close bottom sheet first
                              await FirebaseAuth.instance.signOut();
                              await GoogleSignIn().signOut();
                              GoRouter.of(context).goNamed('splash');
                            },
                            child: Text(
                              "Yes, Logout",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFE0CBFE),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // If not authenticated, show loading or redirect (though AuthWrapper should prevent this)
    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (authState.value == null) {
      // Optional: Redirect to sign-in if somehow reached here
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed('splash');
      });
      return const Scaffold(body: Center(child: Text('Redirecting...')));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavigationBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).push('/apphome');
            },
            child: Image.asset("assets/icons/foot.png", height: 24.h, width: 24.w),
          ),
        ),
        title: Center(
          child: Text(
            "Account",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 21.sp,
              color: const Color(0xFF3C3C3C),
            ),
          ),
        ),
        actions: [
          Icon(Icons.more_vert, color: Colors.black87, size: 24.sp),
          SizedBox(width: 12.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              /// Upgrade Plan
              Card(
                color: const Color(0xFF7C23FE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ListTile(
                  onTap: () {
                    GoRouter.of(context).pushNamed('planupgrade');
                  },
                  leading: Image.asset("assets/images/crown.png", height: 40.h),
                  title: Text(
                    "Upgrade Plan Now!",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                  subtitle: Text(
                    "Enjoy all the benefits and explore more possibilities",
                    style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              /// Level Info
              Card(
                color: const Color(0xFFF5F5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ListTile(
                  onTap: () {
                    GoRouter.of(context).pushNamed('achievements');
                  },
                  leading: Image.asset("assets/images/batch.png", height: 40.h),
                  title: Text(
                    "Level 9",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
                  ),
                  subtitle: Text(
                    "You are rising star! Keep going!",
                    style: TextStyle(color: Colors.black54, fontSize: 13.sp),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              /// Trackers
              Card(
                color: const Color(0xFFF5F5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    InkWell(
                      child: SettingsTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Screen47()),
                          );
                        },
                        icon: Icons.water_drop,
                        iconColor: Colors.blue,
                        title: "Water Tracker",
                      ),
                    ),
                    SettingsTile(
                      onTap: () {
                        GoRouter.of(context).push('/weighttracker');
                      },
                      icon: Icons.monitor_weight,
                      iconColor: Colors.orange,
                      title: "Weight Tracker",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              /// Settings
              Column(
                children: [
                  SettingsTile(
                    icon: Icons.settings,
                    title: "Preferences",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PreferencesScreen()),
                      );
                    },
                  ),
                  SettingsTile(
                    onTap: () {
                      GoRouter.of(context).pushNamed('personalinfo');
                    },
                    icon: Icons.person_outline,
                    title: "Personal Info",
                  ),
                  SettingsTile(
                    onTap: () {
                      GoRouter.of(context).pushNamed('accpay');
                    },
                    icon: Icons.credit_card,
                    title: "Payment Methods",
                  ),
                  SettingsTile(
                    onTap: () {
                      GoRouter.of(context).pushNamed('billingandsubs');
                    },
                    icon: Icons.star_border,
                    title: "Billing & Subscriptions",
                  ),
                  SettingsTile(
                    onTap: () {
                      GoRouter.of(context).pushNamed('accountsandsecurity');
                    },
                    icon: Icons.security,
                    title: "Account & Security",
                  ),
                  SettingsTile(
                    onTap: () {
                      GoRouter.of(context).pushNamed('linkedaccounts');
                    },
                    icon: Icons.compare_arrows,
                    title: "Linked Accounts",
                  ),
                  SettingsTile(
                    onTap: () {
                      GoRouter.of(context).pushNamed('appappear');
                    },
                    icon: Icons.remove_red_eye_outlined,
                    title: "App Appearance",
                  ),
                  SettingsTile(
                    onTap: () {
                      GoRouter.of(context).pushNamed('dataanalytics');
                    },
                    icon: Icons.bar_chart,
                    title: "Data & Analytics",
                  ),
                  SettingsTile(
                    onTap: () {
                      GoRouter.of(context).pushNamed('helpandsupp');
                    },
                    icon: Icons.help_outline,
                    title: "Help & Support",
                  ),
                  SettingsTile(
                    icon: Icons.logout,
                    title: "Logout",
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: _showLogoutPopup,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF9C5BFE),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      currentIndex: 4,
      items: [
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () {
              GoRouter.of(context).pushNamed('apphome');
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Image.asset('assets/icons/us_home.png', height: 24.h),
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: InkWell(
              onTap: () {
                GoRouter.of(context).go("/track");
              },
              child: Image.asset('assets/icons/track.png', height: 24.h),
            ),
          ),
          label: 'Track',
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () {
              GoRouter.of(context).pushNamed("report");
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Image.asset('assets/icons/report.png', height: 24.h),
            ),
          ),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () {
              GoRouter.of(context).pushNamed('history');
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Image.asset('assets/icons/history.png', height: 24.h),
            ),
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('acccountpage');
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Image.asset('assets/icons/selected_account.png', height: 24.h),
            ),
          ),
          label: 'Account',
        ),
      ],
    );
  }
}

/// Custom reusable tile (unused here but made responsive)
class CustomTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;

  const CustomTile({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 28.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.black54, size: 22.sp),
      onTap: () {},
    );
  }
}

/// Settings tile responsive
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color textColor;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor = Colors.black87,
    this.textColor = Colors.black87,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 24.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: title != "Logout"
          ? Icon(Icons.chevron_right, color: Colors.black54, size: 22.sp)
          : null,
      onTap: onTap,
      tileColor: const Color(0xFFF5F5F5),
    );
  }
}
