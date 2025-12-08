import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarckfit/screens/steplive/track_screen.dart';

const themeColor = Color(0xFF661FCC);

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 1;

  final List<Widget> _screens = const [
    Scaffold(
      body: Center(
        child: Text(
          "Home Screen (Coming Soon 🚧)",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    TrackScreen(),
    Scaffold(
      body: Center(
        child: Text(
          "Report Screen (Coming Soon 🚧)",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    Scaffold(
      body: Center(
        child: Text(
          "Account Screen (Coming Soon 🚧)",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    Scaffold(
      body: Center(
        child: Text(
          "History Screen (Coming Soon 🚧)",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: themeColor,
        unselectedItemColor: const Color.fromRGBO(192, 192, 192, 1),

        selectedLabelStyle: TextStyle(
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w400,
          color: themeColor,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w400,
          color: const Color.fromRGBO(192, 192, 192, 1),
        ),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/Image (13).png", height: 21.h),
            activeIcon: Image.asset("assets/icons/Image (13).png", height: 21.h),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/Image (14).png", height: 21.h),
            activeIcon: Image.asset("assets/icons/Image (14).png", height: 21.h),
            label: "Track",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/Image (15).png", height: 21.h),
            activeIcon: Image.asset("assets/icons/Image (15).png", height: 21.h),
            label: "Report",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/Image (16).png", height: 21.h),
            activeIcon: Image.asset("assets/icons/Image (16).png", height: 21.h),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/Image (17).png", height: 21.h),
            activeIcon: Image.asset("assets/icons/Image (17).png", height: 21.h),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
