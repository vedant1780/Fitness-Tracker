import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/prefs_hive_service.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool dailyReminder = true;
  String reminderTime = "07:00";

  String gender = "Man";
  int age = 28;
  int height = 170; // in cm or total inches
  int weight = 70;  // in kg or lbs
  String unit = "kg / cm / km";
  int stepGoal = 8000;
  String sensitivity = "Medium";
  int stepLength = 74; // in cm or inches
  String firstDayOfWeek = "Sunday";

  @override
  void initState() {
    super.initState();
    _loadHiveData();
  }

  // ================== Conversion Helpers ==================
  double cmToInch(int cm) => cm / 2.54;
  int inchToCm(double inch) => (inch * 2.54).round();

  double kgToLbs(int kg) => kg * 2.20462;
  int lbsToKg(double lbs) => (lbs / 2.20462).round();

  String inchesToFeetInch(int inches) {
    final ft = inches ~/ 12;
    final inch = inches % 12;
    return "${ft}ft ${inch}in";
  }

  int feetInchToInches(String str) {
    final parts = str.split(RegExp(r'[ftin ]+')).where((s) => s.isNotEmpty).toList();
    final ft = int.parse(parts[0]);
    final inch = int.parse(parts[1]);
    return ft * 12 + inch;
  }

  // ================== Load Data ==================
  Future<void> _loadHiveData() async {
    await HiveService2.initHive();

    gender = await HiveService2.getPreference('gender') ?? "Man";
    age = await HiveService2.getPreference('age') ?? 28;
    height = await HiveService2.getPreference('height') ?? 170;
    weight = await HiveService2.getPreference('weight') ?? 70;
    stepGoal = await HiveService2.getPreference('stepGoal') ?? 8000;
    unit = await HiveService2.getPreference('unit') ?? "kg / cm / km";
    sensitivity = await HiveService2.getPreference('sensitivity') ?? "Medium";
    stepLength = await HiveService2.getPreference('stepLength') ?? 74;
    firstDayOfWeek = await HiveService2.getPreference('firstDayOfWeek') ?? "Sunday";
    dailyReminder = await HiveService2.getPreference('dailyReminder') ?? true;
    reminderTime = await HiveService2.getPreference('reminderTime') ?? "07:00";

    setState(() {});
  }

  // ================== Save Preference ==================
  Future<void> _savePreference(String key, dynamic value) async {
    await HiveService2.setPreference(key, value);
    debugPrint("✅ Saved $key: $value");
  }

  // ================== Unit Conversion ==================
  void _onUnitChanged(String newUnit) {
    if (unit == newUnit) return;

    if (newUnit == "lbs / ft / miles") {
      // Metric -> Imperial
      weight = kgToLbs(weight).round();
      height = cmToInch(height).round();
      stepLength = cmToInch(stepLength).round();
    } else {
      // Imperial -> Metric
      weight = lbsToKg(weight.toDouble());
      height = inchToCm(height.toDouble());
      stepLength = inchToCm(stepLength.toDouble());
    }

    setState(() => unit = newUnit);
    _savePreference('unit', newUnit);
    _savePreference('weight', weight);
    _savePreference('height', height);
    _savePreference('stepLength', stepLength);
  }

  // ================== Build UI ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Preferences",
          style: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _buildCard([
            _buildPreferenceItem("Gender", gender, () {
              _showCenterPopup("Gender", ["Man", "Woman"], (val) {
                setState(() => gender = val);
                _savePreference('gender', val);
              });
            }),
            _buildPreferenceItem("Age", "$age years", () {
              _showCenterPopup(
                  "Age",
                  List.generate(60, (i) => "${i + 10} years"), (val) {
                final newAge = int.parse(val.split(" ")[0]);
                setState(() => age = newAge);
                _savePreference('age', newAge);
              });
            }),
            _buildPreferenceItem(
              "Height",
              unit.contains("cm") ? "$height cm" : inchesToFeetInch(height),
                  () {
                if (unit.contains("cm")) {
                  _showCenterPopup(
                      "Height",
                      List.generate(100, (i) => "${140 + i} cm"), (val) {
                    final newHeight = int.parse(val.split(" ")[0]);
                    setState(() => height = newHeight);
                    _savePreference('height', newHeight);
                  });
                } else {
                  _showCenterPopup(
                      "Height",
                      List.generate(100, (i) {
                        final totalInches = 55 + i; // min 4ft7in = 55in
                        return inchesToFeetInch(totalInches);
                      }),
                          (val) {
                        final totalInches = feetInchToInches(val);
                        setState(() => height = totalInches);
                        _savePreference('height', totalInches);
                      });
                }
              },
            ),
            _buildPreferenceItem(
              "Weight",
              unit.contains("kg") ? "$weight kg" : "$weight lbs",
                  () {
                if (unit.contains("kg")) {
                  _showCenterPopup(
                      "Weight",
                      List.generate(80, (i) => "${40 + i} kg"), (val) {
                    final newWeight = int.parse(val.split(" ")[0]);
                    setState(() => weight = newWeight);
                    _savePreference('weight', newWeight);
                  });
                } else {
                  _showCenterPopup(
                      "Weight",
                      List.generate(180, (i) => "${90 + i} lbs"), (val) {
                    final newWeight = int.parse(val.split(" ")[0]);
                    setState(() => weight = newWeight);
                    _savePreference('weight', newWeight);
                  });
                }
              },
            ),
          ], withDivider: false),
          SizedBox(height: 22.h),
          _buildCard([
            _buildPreferenceItem("Unit", unit, () {
              _showCenterPopup(
                  "Unit",
                  ["kg / cm / km", "lbs / ft / miles"],
                  _onUnitChanged);
            }),
            _buildPreferenceItem("Step Goal", "$stepGoal steps", () {
              _showCenterPopup(
                  "Step Goal",
                  ["4000", "6000", "8000", "10000"], (val) {
                final goal = int.parse(val);
                setState(() => stepGoal = goal);
                _savePreference('stepGoal', goal);
              });
            }),
            _buildPreferenceItem("Sensitivity", sensitivity, () {
              _showCenterPopup("Sensitivity", ["Low", "Medium", "High"], (val) {
                setState(() => sensitivity = val);
                _savePreference('sensitivity', val);
              });
            }),
            _buildPreferenceItem(
              "Step Length",
              unit.contains("cm") ? "$stepLength cm" : "$stepLength in",
                  () {
                if (unit.contains("cm")) {
                  _showCenterPopup(
                      "Step Length",
                      List.generate(60, (i) => "${60 + i} cm"), (val) {
                    final length = int.parse(val.split(" ")[0]);
                    setState(() => stepLength = length);
                    _savePreference('stepLength', length);
                  });
                } else {
                  _showCenterPopup(
                      "Step Length",
                      List.generate(40, (i) => "${24 + i} in"), (val) {
                    final length = int.parse(val.split(" ")[0]);
                    setState(() => stepLength = length);
                    _savePreference('stepLength', length);
                  });
                }
              },
            ),
            _buildPreferenceItem("First Day of Week", firstDayOfWeek, () {
              _showCenterPopup(
                  "First Day of Week",
                  ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
                      (val) {
                    setState(() => firstDayOfWeek = val);
                    _savePreference('firstDayOfWeek', val);
                  });
            }),
          ], withDivider: false),
          SizedBox(height: 22.h),
          _buildCard([
            _buildSwitchItem(
              "Daily Step Reminder",
              dailyReminder,
                  (value) async {
                setState(() => dailyReminder = value);
                _savePreference('dailyReminder', value);
              },
            ),
            _buildPreferenceItem("Reminder Time", reminderTime, () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: int.parse(reminderTime.split(":")[0]),
                  minute: int.parse(reminderTime.split(":")[1]),
                ),
              );
              if (picked != null) {
                setState(() {
                  reminderTime =
                  "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                });
                _savePreference('reminderTime', reminderTime);
              }
            }, isLastCard: true),
          ], withDivider: true),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children, {required bool withDivider}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(children: withDivider ? [
        children[0],
        Padding(padding: EdgeInsets.symmetric(horizontal: 15.w), child: Divider(height: 1.h)),
        children[1],
      ] : children),
    );
  }

  Widget _buildPreferenceItem(String title, String value, VoidCallback onTap, {bool isLastCard = false}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.bold,
          fontSize: 18.3.sp,
          color: const Color(0xFF494949),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
              fontSize: 14.4.sp,
              color: const Color(0xFF565656),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 20.sp),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.bold,
          fontSize: 18.3.sp,
          color: const Color(0xFF494949),
        ),
      ),
      trailing: Switch(
        value: value,
        activeThumbColor: Colors.white,
        activeTrackColor: Colors.deepPurple,
        onChanged: onChanged,
      ),
    );
  }

  void _showCenterPopup(String title, List<String> options, ValueChanged<String> onSelected) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text("Select $title",
                          style: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.w700, fontSize: 18.sp, color: Colors.black87)),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black54, size: 20.sp),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Divider(height: 1.h),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: options.map((opt) {
                        return ListTile(
                          title: Text(opt,
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: const Color(0xFF494949),
                              )),
                          onTap: () {
                            onSelected(opt);
                            Navigator.pop(ctx);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
