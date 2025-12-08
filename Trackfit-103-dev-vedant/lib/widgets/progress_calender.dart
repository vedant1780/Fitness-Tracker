import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressCalendar extends StatefulWidget {
  final Map<int, double> progress;
  final int year;
  final int month;

  const ProgressCalendar({
    super.key,
    required this.progress,
    required this.year,
    required this.month,
  });

  @override
  State<ProgressCalendar> createState() => _ProgressCalendarState();
}

class _ProgressCalendarState extends State<ProgressCalendar> {
  late int year;
  late int month;
  String selectedPeriod = "This Month";

  @override
  void initState() {
    super.initState();
    year = widget.year;
    month = widget.month;
  }

  void _changeMonth(int offset) {
    setState(() {
      month += offset;
      if (month < 1) {
        month = 12;
        year -= 1;
      } else if (month > 12) {
        month = 1;
        year += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    int daysInMonth = DateTime(year, month + 1, 0).day;
    int startingWeekday = firstDayOfMonth.weekday % 7;

    List<Widget> dayWidgets = [];

    // Empty slots before first day
    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Calendar day cells
    for (int day = 1; day <= daysInMonth; day++) {
      double? value = widget.progress[day]; // null if data not available
      bool hasData = value != null && value > 0;

      dayWidgets.add(
        Container(
          margin: EdgeInsets.all(4.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 40.w,
                height: 40.w,
                child: CircularProgressIndicator(
                  value: hasData ? value!.clamp(0.0, 1.0) : 0.0,
                  strokeWidth: 3.w,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    hasData ? const Color(0xFF8A2BE2) : Colors.grey.shade300,
                  ),
                ),
              ),
              Text(
                "$day",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: hasData ? Colors.black : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Progress",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildCustomDropdown(),
            ],
          ),

          SizedBox(height: 16.h),

          /// Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 18.sp),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                "${_monthName(month)} $year",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, size: 18.sp),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Weekday labels
          Row(
            children: [
              for (var d in ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])
                Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Calendar grid
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            mainAxisSpacing: 5.h,
            physics: const NeverScrollableScrollPhysics(),
            children: dayWidgets,
          ),
        ],
      ),
    );
  }

  /// Dropdown using your custom design
  Widget _buildCustomDropdown() {
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPeriod,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 18.sp,
            color: Colors.black87,
          ),
          dropdownColor: Colors.white,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
          borderRadius: BorderRadius.circular(12.r),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedPeriod = newValue;
              });
              _onDropdownChanged(newValue);
            }
          },
          items: const [
            DropdownMenuItem(value: "This Month", child: Text("This Month")),
            DropdownMenuItem(value: "Last Month", child: Text("Last Month")),
            DropdownMenuItem(value: "Custom", child: Text("Custom")),
          ],
        ),
      ),
    );
  }

  /// Handles dropdown logic for month changes
  void _onDropdownChanged(String value) {
    if (value == "This Month") {
      final now = DateTime.now();
      setState(() {
        month = now.month;
        year = now.year;
      });
    } else if (value == "Last Month") {
      final now = DateTime.now();
      setState(() {
        if (now.month == 1) {
          month = 12;
          year = now.year - 1;
        } else {
          month = now.month - 1;
          year = now.year;
        }
      });
    } else {
      _pickCustomMonth(context);
    }
  }

  Future<void> _pickCustomMonth(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime(year, month),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: "Select a month",
    );
    if (selected != null) {
      setState(() {
        year = selected.year;
        month = selected.month;
      });
    }
  }

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }
}
