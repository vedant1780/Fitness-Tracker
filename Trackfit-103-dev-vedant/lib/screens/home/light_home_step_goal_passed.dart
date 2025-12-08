import 'package:flutter/material.dart';
import 'package:tarckfit/screens/home/light_home_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:tarckfit/screens/onboarding/select_your_gender_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepGoalPassedScreen extends StatefulWidget {
  const StepGoalPassedScreen({super.key});

  @override
  State<StepGoalPassedScreen> createState() => _StepGoalPassedScreenState();
}

class _StepGoalPassedScreenState extends State<StepGoalPassedScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play(); // 🎉 Start confetti on screen load
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // Trophy and Confetti Section
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Image.asset(
                        'assets/images/trophy.png',
                        height: 200.h,
                        width: 200.w,
                      ),
                    ),
                  ),
                  // Main Content Section
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          '6,000 Steps!',
                          style: TextStyle(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Congratulations!\nYou\'ve completed the step goal.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.8.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Summary Cards
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: _buildSummaryCard(
                                'assets/icons/clock.png',
                                '1h 14m',
                                'time',
                              ),
                            ),
                            Expanded(
                              child: _buildSummaryCard(
                                'assets/icons/fire.png',
                                '360',
                                'kcal',
                                isBordered: true,
                              ),
                            ),
                            Expanded(
                              child: _buildSummaryCard(
                                'assets/icons/location.png',
                                '5.46',
                                'km',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Buttons Section
                  _buildButtons(context),
                ],
              ),
            ),

            // 🎉 Confetti Widget
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.purple
              ],
              gravity: 0.3,
              emissionFrequency: 0.06,
              numberOfParticles: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String icon,
      String value,
      String label, {
        bool isBordered = false,
      }) {
    return Container(
      decoration: isBordered
          ? BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.black26, width: 1.w),
          right: BorderSide(color: Colors.black26, width: 1.w),
        ),
      )
          : null,
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(icon, height: 24.h, width: 24.w),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(fontSize: 20.7.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15.1.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(isPaused: true)),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(245, 238, 255, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
                side: BorderSide.none,
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text(
                'Stop Step',
                style: TextStyle(
                  color: const Color.fromRGBO(150, 79, 255, 1),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GenderSelectionScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(127, 39, 255, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
                side: BorderSide.none,
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text(
                'Continue Steps',
                style: TextStyle(
                  color: const Color.fromRGBO(218, 194, 255, 1),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
