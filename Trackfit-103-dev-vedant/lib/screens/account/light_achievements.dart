import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAchievementPopup(context, level: 10, steps: 250000);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showAchievementPopup(
      BuildContext context, {
        required int level,
        required int steps,
      }) {
    _confettiController.play();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 24.h,
              ),
              content: Container(
                width: 0.85.sw,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 26.h),
                      width: double.infinity,
                      child: Center(
                        child: Image.asset(
                          'assets/achievements_batch/level_$level.png',
                          width: 220.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "You've Reached Level $level!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 21.4.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "Congratulations! You've taken a whopping ${steps.toStringAsFixed(0)} steps. Keep up the incredible effort!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14.6.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 30.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color.fromRGBO(124, 35, 254, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.h,
                                ),
                              ),
                              child: Text(
                                "OK, Sure!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.3.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                maxBlastForce: 20,
                minBlastForce: 10,
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                gravity: 0.1,
                colors: const [
                  Colors.purple,
                  Colors.pink,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 0.5.sh,
              color: const Color.fromRGBO(127, 39, 255, 1),
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  "Achievements",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21.4.sp,
                  ),
                ),
                centerTitle: true,
              ),
              SizedBox(height: 20.h),
              Image.asset(
                'assets/achievements_batch/level_9.png',
                width: 185.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20.h),
              Text(
                "Level 9",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.3.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                "You've passed 200,000 steps!",
                style: TextStyle(
                  color: const Color.fromRGBO(207, 174, 254, 1),
                  fontSize: 14.6.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 26.h),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: GridView.builder(
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 20.h,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        final level = index + 1;
                        final bool isUnlocked = level <= 9;
                        final String stepsGoal = "${level * 50}k steps!";

                        return _buildAchievementItem(
                          level: level,
                          isUnlocked: isUnlocked,
                          stepsGoal: stepsGoal,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem({
    required int level,
    required bool isUnlocked,
    required String stepsGoal,
  }) {
    return Column(
      children: [
        Center(
          child: isUnlocked
              ? Image.asset(
            'assets/achievements_batch/level_$level.png',
            height: 70.h,
            fit: BoxFit.contain,
          )
              : Image.asset(
            'assets/achievements_batch/locked.png',
            height: 70.h,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Level $level",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14.4.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Flexible(
          child: Text(
            isUnlocked ? "You've passed this level!" : "Pass $stepsGoal",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 8.8.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
