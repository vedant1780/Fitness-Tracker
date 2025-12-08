import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLanguage = "English (US)";

  final List<Map<String, String>> languages = [
    {"name": "English (US)", "flag": "🇺🇸", "code": "en"},
    {"name": "English (UK)", "flag": "🇬🇧", "code": "en-GB"},
    {"name": "Hindi", "flag": "🇮🇳", "code": "hi"},
    {"name": "Spanish", "flag": "🇪🇸", "code": "es"},
    {"name": "French", "flag": "🇫🇷", "code": "fr"},
    {"name": "German", "flag": "🇩🇪", "code": "de"},
    {"name": "Portuguese", "flag": "🇵🇹", "code": "pt"},
    {"name": "Italian", "flag": "🇮🇹", "code": "it"},
    {"name": "Russian", "flag": "🇷🇺", "code": "ru"},
    {"name": "Chinese", "flag": "🇨🇳", "code": "zh"},
    {"name": "Japanese", "flag": "🇯🇵", "code": "ja"},
    {"name": "Korean", "flag": "🇰🇷", "code": "ko"},
    {"name": "Arabic", "flag": "🇸🇦", "code": "ar"},
    {"name": "Turkish", "flag": "🇹🇷", "code": "tr"},
    {"name": "Thai", "flag": "🇹🇭", "code": "th"},
    {"name": "Persian", "flag": "🇮🇷", "code": "fa"},
    {"name": "Bengali", "flag": "🇧🇩", "code": "bn"},
    {"name": "Urdu", "flag": "🇵🇰", "code": "ur"},
    {"name": "Nepali", "flag": "🇳🇵", "code": "ne"},
    {"name": "Swahili", "flag": "🇰🇪", "code": "sw"},
    {"name": "Malay", "flag": "🇲🇾", "code": "ms"},
    {"name": "Filipino", "flag": "🇵🇭", "code": "fil"},
    {"name": "Vietnamese", "flag": "🇻🇳", "code": "vi"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // light grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5), // same as page bg
        elevation: 0,
        centerTitle: true,
        title: Text(
          "App Language",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18.sp,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 22.sp),
          onPressed: () {
            Navigator.pop(context, selectedLanguage);
          },
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12.w),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final lang = languages[index];
          final isSelected = selectedLanguage == lang["name"];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLanguage = lang["name"]!;
              });
              Navigator.pop(context, lang["name"]);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 6.h),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected ? Colors.purple : Colors.transparent,
                  width: 2.w,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    lang["flag"]!,
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      lang["name"]!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check, color: Colors.purple, size: 20.sp),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
