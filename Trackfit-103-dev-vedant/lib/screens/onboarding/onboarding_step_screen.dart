import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tarckfit/widgets/step_template.dart';
import '../../data/prefs_hive_service.dart'; // HiveService2

const Color themeColor = Color(0xFF7F27FF);

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int currentStep = 0;

  final List<Widget> steps = [];

  // Store user selections
  String? lifestyle;
  int age = 28;
  int weight = 76;
  String weightUnit = 'kg';
  int height = 185;
  String heightUnit = 'cm';
  int stepGoal = 6000;

  @override
  void initState() {
    super.initState();
    steps.addAll([
      Lifestyle(onSelect: (val) => lifestyle = val),
      AgeStep(onSelect: (val) => age = val),
      HeightStep(
        onSelect: (val, unit) {
          height = val;
          heightUnit = unit;
        },
      ),
      WeightStep(
        onSelect: (val, unit) {
          weight = val;
          weightUnit = unit;
        },
      ),
      StepGoalStep(onSelect: (val) => stepGoal = val),
    ]);
  }

  void nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() => currentStep++);
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  Future<void> _saveDataAndFinish() async {
    try {
      // ✅ Save locally to Hive
      if (lifestyle != null) await HiveService2.setPreference('lifestyle', lifestyle);
      await HiveService2.setPreference('age', age);
      await HiveService2.setPreference('weight', weight);
      await HiveService2.setPreference('weightUnit', weightUnit);
      await HiveService2.setPreference('height', height);
      await HiveService2.setPreference('heightUnit', heightUnit);
      await HiveService2.setPreference('stepGoal', stepGoal);

      // ✅ Get current user ID (you must be logged in)
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("⚠️ No logged-in user found. Cannot save to Firestore.");
        return;
      }

      // ✅ Save to Firestore
      final userData = {
        'lifestyle': lifestyle ?? '',
        'age': age,
        'weight': weight,
        'weightUnit': weightUnit,
        'height': height,
        'heightUnit': heightUnit,
        'stepGoal': stepGoal,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));

      debugPrint("✅ User onboarding data saved to Firestore and Hive.");

      if (mounted) {
        context.goNamed("apphome");
      }
    } catch (e, st) {
      debugPrint("❌ Error saving onboarding data: $e\n$st");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save data. Please try again.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double progress = (currentStep + 1) / steps.length;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 28.w),
          child: IconButton(
            onPressed: (){
              if (currentStep == 0) {
                // 👇 Navigate to gender screen instead of going back to step 0
                context.goNamed('gender');
          } else {
            prevStep();
      }
    },
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          ),
        ),
        title: Center(
          child: SizedBox(
            width: 214.w,
            height: 17.h,
            child: LinearProgressIndicator(
              minHeight: 17.h,
              borderRadius: BorderRadius.circular(10.r),
              value: progress,
              backgroundColor: const Color(0xFFF5F5F5),
              valueColor: const AlwaysStoppedAnimation<Color>(themeColor),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 22.w),
            child: Text(
              "${currentStep + 2}/6",
              style: TextStyle(fontSize: 16.9.sp,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),

      // ✅ SafeArea added to prevent overlap
      body: SafeArea(
        child: steps[currentStep],
      ),

      // ✅ SafeArea added for bottom navigation
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 58.h,
                width: 170.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),
                  color: const Color(0xFFF5EEFF),
                ),
                child: TextButton(
                  onPressed: nextStep,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 15.4.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                height: 58.h,
                width: 180.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),
                  color: themeColor,
                ),
                child: TextButton(
                  onPressed: () {
                    currentStep != steps.length - 1
                        ? nextStep()
                        : _saveDataAndFinish();
                  },
                  child: Text(
                    currentStep == steps.length - 1 ? "Finish" : "Continue",
                    style: TextStyle(
                      color: const Color(0xFFF5EEFF),
                      fontSize: 15.4.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------- Step Widgets ----------------------

// Lifestyle
class Lifestyle extends StatefulWidget {
  final Function(String)? onSelect;
  const Lifestyle({super.key, this.onSelect});

  @override
  State<Lifestyle> createState() => _LifestyleState();
}

class _LifestyleState extends State<Lifestyle> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return StepTemplate(
      title: "Do You Live a Sedentary Lifestyle?",
      subtitle: "Tell us about your daily routine.",
      highlight: "Sedentary",
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Image.asset("assets/images/Image (18).png", height: 200.h),
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOption("Yes"),
              SizedBox(width: 53.w),
              _buildOption("No"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label) {
    final bool isSelected = selectedOption == label;
    return GestureDetector(
      onTap: () {
        setState(() => selectedOption = label);
        widget.onSelect?.call(label);
      },
      child: Container(
        height: 103.h,
        width: 103.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? themeColor : const Color.fromRGBO(245, 238, 255, 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color.fromRGBO(255, 255, 255, 0.5)
                : const Color.fromRGBO(74, 73, 75, 1),
            fontWeight: FontWeight.bold,
            fontSize: 20.7.sp,
          ),
        ),
      ),
    );
  }
}

// AgeStep
class AgeStep extends StatefulWidget {
  final Function(int)? onSelect;
  const AgeStep({super.key, this.onSelect});

  @override
  State<AgeStep> createState() => _AgeStepState();
}

class _AgeStepState extends State<AgeStep> {
  int age = 28;

  @override
  Widget build(BuildContext context) {
    final List<int> ages = List.generate(63, (i) => i + 18);

    return StepTemplate(
      title: "How Old Are You?",
      subtitle: "Share your age with us.",
      highlight: "Old",
      child: SizedBox(
        height: 450.h,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(initialItem: age - 18),
          itemExtent: 70.h,
          magnification: 1.3,
          onSelectedItemChanged: (index) {
            setState(() {
              age = ages[index];
              widget.onSelect?.call(age);
            });
          },
          selectionOverlay: Container(
            width: 120.w,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: themeColor, width: 1.2.w),
              ),
            ),
          ),
          children: ages.map((a) {
            final bool isSelected = a == age;
            return Center(
              child: Text(
                "$a years",
                style: TextStyle(
                  fontSize: isSelected ? 28.sp : 22.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? themeColor : Colors.black87,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// WeightStep
class WeightStep extends StatefulWidget {
  final Function(int, String)? onSelect;
  const WeightStep({super.key, this.onSelect});

  @override
  State<WeightStep> createState() => _WeightStepState();
}

class _WeightStepState extends State<WeightStep> {
  int weight = 76;
  String selectedUnit = 'kg';

  @override
  Widget build(BuildContext context) {
    final List<int> kgWeights = List.generate(111, (i) => i + 40);
    final List<int> lbsWeights =
    kgWeights.map((kg) => (kg * 2.20462).round()).toList();
    final weights = selectedUnit == 'kg' ? kgWeights : lbsWeights;

    return StepTemplate(
      title: "What's Your Weight?",
      subtitle: "Share your weight with us.",
      highlight: "Weight",
      text1: "kg",
      text2: "lbs",
      onUnitChanged: (unit) {
        setState(() => selectedUnit = unit);
        widget.onSelect?.call(weight, selectedUnit);
      },
      child: SizedBox(
        height: 350.h,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(initialItem: weight - 40),
          itemExtent: 70.h,
          magnification: 1.3,
          onSelectedItemChanged: (index) {
            setState(() => weight = kgWeights[index]);
            widget.onSelect?.call(weight, selectedUnit);
          },
          selectionOverlay: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: themeColor, width: 1.2.w),
              ),
            ),
          ),
          children: weights.map((w) {
            final isSelected = selectedUnit == 'kg'
                ? w == weight
                : w == (weight * 2.20462).round();
            String displayText = selectedUnit == 'kg' ? "$w kg" : "$w lbs";
            return Center(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: isSelected ? 28.sp : 22.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? themeColor : Colors.black87,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// HeightStep
class HeightStep extends StatefulWidget {
  final Function(int, String)? onSelect;
  const HeightStep({super.key, this.onSelect});

  @override
  State<HeightStep> createState() => _HeightStepState();
}

class _HeightStepState extends State<HeightStep> {
  int height = 185;
  String selectedUnit = 'cm';

  @override
  Widget build(BuildContext context) {
    return StepTemplate(
      title: "What's Your Height?",
      subtitle: "How tall are you?",
      highlight: "Height",
      text1: 'cm',
      text2: 'ft',
      onUnitChanged: (unit) {
        setState(() => selectedUnit = unit);
        widget.onSelect?.call(height, selectedUnit);
      },
      child: SizedBox(
        height: 350.h,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(initialItem: height - 140),
          itemExtent: 70.h,
          magnification: 1.3,
          onSelectedItemChanged: (index) {
            setState(() => height = 140 + index);
            widget.onSelect?.call(height, selectedUnit);
          },
          selectionOverlay: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: themeColor, width: 1.2.w),
              ),
            ),
          ),
          children: List.generate(71, (i) {
            final h = 140 + i;
            final isSelected = h == height;
            String displayText =
            selectedUnit == 'cm' ? "$h cm" : "${_convertCmToFtIn(h)} ft";
            return Center(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: isSelected ? 28.sp : 22.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? themeColor : Colors.black87,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// StepGoalStep
class StepGoalStep extends StatefulWidget {
  final Function(int)? onSelect;
  const StepGoalStep({super.key, this.onSelect});

  @override
  State<StepGoalStep> createState() => _StepGoalStepState();
}

class _StepGoalStepState extends State<StepGoalStep> {
  int steps = 6000;

  @override
  Widget build(BuildContext context) {
    final List<int> stepGoals =
    List.generate(((20000 - 500) ~/ 500) + 1, (i) => 500 + i * 500);

    return StepTemplate(
      title: "Set Your Step Goal",
      subtitle: "Choose your daily step goal to stay motivated!",
      highlight: "Step Goal",
      child: SizedBox(
        height: 350.h,
        child: CupertinoPicker(
          scrollController:
          FixedExtentScrollController(initialItem: (steps - 4000) ~/ 500),
          itemExtent: 70.h,
          magnification: 1.3,
          onSelectedItemChanged: (index) {
            setState(() => steps = stepGoals[index]);
            widget.onSelect?.call(steps);
          },
          selectionOverlay: Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: themeColor, width: 1.2.w),
              ),
            ),
          ),
          children: stepGoals.map((s) {
            final isSelected = s == steps;
            return Center(
              child: Text(
                "$s steps",
                style: TextStyle(
                  fontSize: isSelected ? 28.sp : 22.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? themeColor : Colors.black87,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Helper function
String _convertCmToFtIn(int cm) {
  double totalInches = cm / 2.54;
  int ft = totalInches ~/ 12;
  int inch = (totalInches % 12).round();
  return "$ft'$inch\"";
}
