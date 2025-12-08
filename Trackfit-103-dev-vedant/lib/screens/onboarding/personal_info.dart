import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_phone_field.dart';
import '../../widgets/custom_textfield_personal_info.dart';
import '../../widgets/date_picker.dart';
import '../../widgets/label_text_widget.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController nameController =
  TextEditingController(text: "Andrew Ainsley");
  final TextEditingController emailController =
  TextEditingController(text: "andrew.ainsley@yourdomain.com");
  final TextEditingController phoneController =
  TextEditingController(text: "+1 111467 378 399");

  late String gender = "Male";

  DateTime birthDate = DateTime(1995, 12, 25);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            GoRouter.of(context).pushNamed('acccountpage');
          },
          child: Icon(Icons.arrow_back, color: Colors.black, size: 26.sp),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Personal Info",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage:
                    const AssetImage("assets/profile_image.png"), // replace with your image
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4.w,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF7a00ff),
                      ),
                      child: Icon(Icons.edit, color: Colors.white, size: 18.sp),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15.h),

            // Full Name
            const LabelText("Full Name"),
            SizedBox(height: 9.h),
            CustomTextField(controller: nameController, enabled: true),

            SizedBox(height: 21.h),
            const LabelText("Email"),
            SizedBox(height: 9.h),
            CustomTextField(
              controller: emailController,
              prefixIcon: Image.asset("assets/email_icon.png", height: 20.h, width: 20.w),
              enabled: true,
            ),

            SizedBox(height: 20.h),
            const LabelText("Phone Number"),
            SizedBox(height: 9.h),
            CustomPhoneField(
              controller: phoneController,
              onCountryCodeChanged: (code) {
                debugPrint("Selected code: $code");
              },
            ),

            SizedBox(height: 25.h),
            const LabelText("Gender"),
            SizedBox(height: 13.h),
            _buildDropdown(),

            SizedBox(height: 27.h),
            const LabelText("Birthdate"),
            SizedBox(height: 12.h),
            CustomDatePicker(
              selectedDate: birthDate,
              onDateSelected: (picked) {
                setState(() {
                  birthDate = picked;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.grey[100],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: gender,
          isExpanded: true,
          style: TextStyle(fontSize: 15.sp, color: Colors.black87),
          items: const [
            DropdownMenuItem(value: "Male", child: Text("Male")),
            DropdownMenuItem(value: "Female", child: Text("Female")),
            DropdownMenuItem(value: "Other", child: Text("Other")),
          ],
          onChanged: (value) {
            setState(() {
              gender = value!;
            });
          },
        ),
      ),
    );
  }
}
