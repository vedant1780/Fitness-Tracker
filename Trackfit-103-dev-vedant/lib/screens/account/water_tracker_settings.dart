import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Screen49 extends StatefulWidget {
  const Screen49({super.key});

  @override
  State<Screen49> createState() => _Screen49State();
}

class _Screen49State extends State<Screen49> {
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 23, minute: 0);

  final List<String> intervalOptions = [
    "15 Minutes",
    "30 Minutes",
    "45 Minutes",
    "1 Hour",
    "2 Hours",
    "3 Hours",
    "4 Hours"
  ];
  final List<String> unitOptions = ["ml", "Litres"];

  String selectedInterval = "15 Minutes";
  String selectedUnit = "ml";

  int cupCapacity = 200;
  int drinkingGoal = 2000;

  bool reminderEnabled = true;

  Future<void> pickStartTime() async {
    if (!reminderEnabled) return;
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> pickEndTime() async {
    if (!reminderEnabled) return;
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  Future<int?> showScrollNumberPickerDialog(
      String title, int initialValue, int min, int max, int step) async {
    int tempValue = initialValue;

    return await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 18.sp)),
          content: SizedBox(
            height: 200.h,
            width: 100.w,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 40.h,
              perspective: 0.002,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                tempValue = min + (index * step);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  final value = min + (index * step);
                  if (value > max) return null;
                  return Center(
                    child: Text(
                      "$value",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: value == tempValue ? Colors.black : Colors.grey,
                      ),
                    ),
                  );
                },
                childCount: ((max - min) ~/ step) + 1,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(fontSize: 14.sp)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, tempValue),
              child: Text("OK", style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        leading: InkWell(
          child: Icon(Icons.arrow_back, size: 30.sp),
          onTap: () => Navigator.pop(context),
        ),
        title: Text(
          "Water Tracker Settings",
          style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top settings container
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 187.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Unit Row
                  Row(
                    children: [
                      SizedBox(width: 18.w),
                      Text(
                        "Unit",
                        style: GoogleFonts.inter(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final selected = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              String tempSelected = selectedUnit;
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Container(
                                  height: 250.h,
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Select Unit",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListWheelScrollView.useDelegate(
                                          itemExtent: 40.h,
                                          physics: const FixedExtentScrollPhysics(),
                                          perspective: 0.002,
                                          onSelectedItemChanged: (index) {
                                            tempSelected = unitOptions[index];
                                          },
                                          childDelegate: ListWheelChildBuilderDelegate(
                                            builder: (context, index) {
                                              if (index < 0 || index >= unitOptions.length) return null;
                                              return Center(
                                                child: Text(
                                                  unitOptions[index],
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: tempSelected == unitOptions[index] ? Colors.black : Colors.grey,
                                                  ),
                                                ),
                                              );
                                            },
                                            childCount: unitOptions.length,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("Cancel", style: TextStyle(fontSize: 14.sp)),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context, tempSelected),
                                            child: Text("OK", style: TextStyle(fontSize: 14.sp)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          if (selected != null) {
                            setState(() => selectedUnit = selected);
                          }
                        },
                        child: Container(
                          width: 100.w,
                          height: 40.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Text(
                                selectedUnit,
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10.w),
                              Image.asset(
                                "assets/icons/drop_down.png",
                                width: 10.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                  ),
                  // Cup Capacity Row
                  Row(
                    children: [
                      SizedBox(width: 18.w),
                      Text(
                        "Cup Capacity",
                        style: GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final selected = await showScrollNumberPickerDialog(
                              "Select Cup Capacity", cupCapacity, 50, 1000, 50);
                          if (selected != null) setState(() => cupCapacity = selected);
                        },
                        child: Container(
                          width: 120.w,
                          height: 40.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "$cupCapacity $selectedUnit",
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10.w),
                              Image.asset("assets/icons/drop_down.png", width: 12.w),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                  // Drinking Goal Row
                  Row(
                    children: [
                      SizedBox(width: 18.w),
                      Text(
                        "Drinking Goal",
                        style: GoogleFonts.inter(fontSize: 17.sp, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final selected = await showScrollNumberPickerDialog(
                              "Select Drinking Goal", drinkingGoal, 500, 5000, 100);
                          if (selected != null) setState(() => drinkingGoal = selected);
                        },
                        child: Container(
                          width: 140.w,
                          height: 40.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "$drinkingGoal $selectedUnit",
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10.w),
                              Image.asset("assets/icons/drop_down.png", width: 10.w),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 1.w),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 21.h),
            // Reminder and time container
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 270.h,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  // Reminder Switch
                  Row(
                    children: [
                      SizedBox(width: 18.w),
                      Text("Reminder", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Transform.scale(
                        scale: 0.7,
                        child: Switch(
                          activeTrackColor: const Color(0xff7F27FF),
                          value: reminderEnabled,
                          onChanged: (value) => setState(() => reminderEnabled = value),
                        ),
                      ),
                      SizedBox(width: 20.w),
                    ],
                  ),
                  Divider(height: 0, indent: 10.w, endIndent: 10.w),
                  SizedBox(height: 30.h),
                  Opacity(
                    opacity: reminderEnabled ? 1.0 : 0.5,
                    child: Column(
                      children: [
                        // Start Time
                        Row(
                          children: [
                            SizedBox(width: 18.w),
                            Text("Start Time", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w700)),
                            const Spacer(),
                            InkWell(
                              onTap: pickStartTime,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Text(formatTimeOfDay(startTime), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5.w),
                                    Image.asset("assets/icons/drop_down.png", width: 10.w),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 24.w),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        // End Time
                        Row(
                          children: [
                            SizedBox(width: 18.w),
                            Text("End Time", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w700)),
                            const Spacer(),
                            InkWell(
                              onTap: pickEndTime,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Text(formatTimeOfDay(endTime), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5.w),
                                    Image.asset("assets/icons/drop_down.png", width: 10.w),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 24.w),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        // Interval Selector
                        Row(
                          children: [
                            SizedBox(width: 18.w),
                            Text("Interval", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w700)),
                            const Spacer(),
                            InkWell(
                              onTap: () async {
                                int selectedIndex = intervalOptions.indexOf(selectedInterval);
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    int tempIndex = selectedIndex;
                                    return AlertDialog(
                                      title: Text("Select Interval", style: TextStyle(fontSize: 18.sp)),
                                      content: SizedBox(
                                        height: 200.h,
                                        width: 100.w,
                                        child: ListWheelScrollView.useDelegate(
                                          itemExtent: 40.h,
                                          perspective: 0.001,
                                          physics: const FixedExtentScrollPhysics(),
                                          diameterRatio: 1.5,
                                          onSelectedItemChanged: (index) {
                                            tempIndex = index;
                                          },
                                          childDelegate: ListWheelChildBuilderDelegate(
                                            builder: (context, index) {
                                              if (index < 0 || index >= intervalOptions.length) return null;
                                              return Center(
                                                child: Text(
                                                  intervalOptions[index],
                                                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: index == tempIndex ? Colors.black : Colors.grey),
                                                ),
                                              );
                                            },
                                            childCount: intervalOptions.length,
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: TextStyle(fontSize: 14.sp))),
                                        TextButton(
                                          onPressed: () {
                                            setState(() => selectedInterval = intervalOptions[tempIndex]);
                                            Navigator.pop(context);
                                          },
                                          child: Text("OK", style: TextStyle(fontSize: 14.sp)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  children: [
                                    Text(selectedInterval, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 10.w),
                                    Image.asset("assets/icons/drop_down.png", width: 10.w),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 24.w),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
