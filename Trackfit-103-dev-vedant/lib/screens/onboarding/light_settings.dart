import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'language_page.dart';

class LightSettings extends StatefulWidget {
  const LightSettings({super.key});

  @override
  State<LightSettings> createState() => _LightSettingsState();
}

class _LightSettingsState extends State<LightSettings> {
  String selectedTheme = "Light"; // default selected theme
  String selectedLanguage = "English (US)"; // default language

  void _showThemeDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Choose Theme",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(height: 3.h),

                  // System Default
                  Row(
                    children: [
                      Radio<String>(
                        value: "System Default",
                        groupValue: selectedTheme,
                        onChanged: (value) {
                          setState(() {
                            selectedTheme = value!;
                          });
                          setStateSB(() {});
                        },
                      ),
                      SizedBox(width: 5.w),
                      Text("System Default", style: TextStyle(fontSize: 15.sp)),
                    ],
                  ),

                  // Light
                  Row(
                    children: [
                      Radio<String>(
                        value: "Light",
                        groupValue: selectedTheme,
                        onChanged: (value) {
                          setState(() {
                            selectedTheme = value!;
                          });
                          setStateSB(() {});
                        },
                      ),
                      SizedBox(width: 5.w),
                      Text("Light", style: TextStyle(fontSize: 15.sp)),
                    ],
                  ),

                  // Dark
                  Row(
                    children: [
                      Radio<String>(
                        value: "Dark",
                        groupValue: selectedTheme,
                        onChanged: (value) {
                          setState(() {
                            selectedTheme = value!;
                          });
                          setStateSB(() {});
                        },
                      ),
                      SizedBox(width: 5.w),
                      Text("Dark", style: TextStyle(fontSize: 15.sp)),
                    ],
                  ),

                  SizedBox(height: 5.h),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(height: 5.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5EEFF),
                          minimumSize: Size(150.w, 45.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: const Color(0xFF944BFE), fontSize: 14.sp),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7a00ff),
                          minimumSize: Size(150.w, 45.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        title: Text(
          'App Appearance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23.sp,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pushNamed('acccountpage');
          },
          icon: Icon(Icons.arrow_back, size: 22.sp),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Theme',
                style: TextStyle(fontSize: 17.sp),
              ),
              trailing: GestureDetector(
                onTap: _showThemeDialog,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedTheme,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(width: 26.w),
                    Icon(Icons.arrow_forward_ios, size: 14.sp),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(
                'App Language',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF444444),
                ),
              ),
              trailing: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LanguagePage()),
                  );

                  if (result != null) {
                    setState(() {
                      selectedLanguage = result; // update with chosen language
                    });
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedLanguage,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(width: 26.w),
                    Icon(Icons.arrow_forward_ios, size: 14.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
