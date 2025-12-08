import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = ["General", "Account", "Services", "Steps"];

  final Map<String, List<Map<String, String>>> faqData = {
    "General": [
      {
        "q": "What is TrackFit?",
        "a":
        "TrackFit is a fitness app that helps you track your steps, monitor your activity, and achieve your fitness goals.",
      },
      {
        "q": "How does TrackFit count steps?",
        "a": "TrackFit uses motion sensors to detect step patterns accurately.",
      },
      {
        "q": "How accurate is step counting?",
        "a":
        "Step counting is highly accurate but may vary depending on movement style.",
      },
      {"q": "How do I set my step goal?", "a": "Go to Settings > Step Goal."},
      {"q": "Is my data secure with TrackFit?", "a": "Yes, data is encrypted."},
      {
        "q": "Does TrackFit work offline?",
        "a": "Yes, TrackFit works even without an internet connection.",
      },
    ],
    "Account": [
      {
        "q": "How do I create an account?",
        "a": "You can sign up using email, Google, or Apple login.",
      },
      {
        "q": "How do I reset my password?",
        "a": "Tap ‘Forgot Password’ on the login screen.",
      },
    ],
    "Services": [
      {
        "q": "Does TrackFit require a subscription?",
        "a": "Basic features are free. Premium plans unlock more insights.",
      },
    ],
    "Steps": [
      {
        "q": "Can I manually add steps?",
        "a": "Yes, you can add steps manually in the Activity tab.",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            size: 22.sp, // ✅ responsive icon
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "FAQ",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22.sp, // ✅ responsive font
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: TextField(
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
                  hintText: "Search",
                  hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Tabs
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tabs.map((tab) {
                  final isSelected = _tabController.index == tabs.indexOf(tab);
                  return GestureDetector(
                    onTap: () {
                      _tabController.animateTo(tabs.indexOf(tab));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepPurple : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.deepPurple
                              : Colors.grey.shade400,
                        ),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: isSelected
                              ? const Color(0xFFD6BBFB)
                              : const Color(0xFF505050),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          SizedBox(height: 10.h),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: tabs.map((tab) {
                final list = faqData[tab] ?? [];
                return ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final faq = list[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.r)),
                          side: BorderSide.none,
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.r)),
                          side: BorderSide.none,
                        ),
                        tilePadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                        childrenPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        title: Text(
                          faq["q"]!,
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 17.w),
                            child: Divider(height: 1.h),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Text(
                              faq["a"]!,
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 14.sp,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
