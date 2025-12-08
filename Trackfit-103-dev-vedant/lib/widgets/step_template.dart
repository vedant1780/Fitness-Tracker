import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepTemplate extends StatefulWidget {
  final String title;
  final String? highlight;
  final String subtitle;
  final Widget child;
  final String? text1;
  final String? text2;
  final void Function(String unit)? onUnitChanged;

  const StepTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.highlight,
    this.text1,
    this.text2,
    this.onUnitChanged,
  });

  @override
  State<StepTemplate> createState() => _StepTemplateState();
}

class _StepTemplateState extends State<StepTemplate> {
  late bool isSelected1;
  late bool isSelected2;

  @override
  void initState() {
    super.initState();
    isSelected1 = true;
    isSelected2 = false;
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF7F27FF);
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 26.h),

          /// Title
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 30.4.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: _buildTitle(),
            ),
          ),

          SizedBox(height: 12.h),

          /// Subtitle
          Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.8.sp,
              color: const Color(0xFF737373),
              fontWeight: FontWeight.normal,
            ),
          ),

          SizedBox(height: 23.h),

          /// Two toggle buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.text1 != null)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected1 = true;
                      isSelected2 = false;
                    });
                    widget.onUnitChanged?.call(widget.text1!);
                  },
                  child: Container(
                    width: 78.w,
                    height: 49.h,
                    margin: EdgeInsets.only(right: 10.5.w),
                    decoration: BoxDecoration(
                      color: isSelected1 ? themeColor : Colors.white,
                      borderRadius: BorderRadius.circular(24.5.r),
                      border: Border.all(
                        color: isSelected1
                            ? Colors.transparent
                            : const Color(0xFFBDBDBD),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.text1!,
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: (isSelected1 ? 17.2 : 16.1).sp,
                        color: isSelected1
                            ? const Color(0xFFE8DAFD)
                            : const Color(0xFF4C4B4C),
                      ),
                    ),
                  ),
                ),
              if (widget.text2 != null)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected1 = false;
                      isSelected2 = true;
                      widget.onUnitChanged?.call(widget.text2!);
                    });
                  },
                  child: Container(
                    width: 78.w,
                    height: 49.h,
                    margin: EdgeInsets.only(left: 10.5.w),
                    decoration: BoxDecoration(
                      color: isSelected2 ? themeColor : Colors.white,
                      borderRadius: BorderRadius.circular(24.5.r),
                      border: Border.all(
                        color: isSelected2
                            ? Colors.transparent
                            : const Color(0xFFBDBDBD),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.text2!,
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: (isSelected2 ? 17.2 : 16.1).sp,
                        color: isSelected2
                            ? const Color(0xFFE8DAFD)
                            : const Color(0xFF4C4B4C),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 20.h),

          /// The actual content below
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  List<TextSpan> _buildTitle() {
    if (widget.highlight == null || !widget.title.contains(widget.highlight!)) {
      return [TextSpan(text: widget.title)];
    }

    final parts = widget.title.split(widget.highlight!);
    return [
      TextSpan(text: parts[0]),
      TextSpan(
        text: widget.highlight!,
        style: TextStyle(
          color: const Color(0xFF7F27FF),
          fontWeight: FontWeight.bold,
          fontSize: 30.4.sp,
        ),
      ),
      if (parts.length > 1) TextSpan(text: parts[1]),
    ];
  }
}
