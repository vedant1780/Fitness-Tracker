import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WeightTrackerScreen extends StatefulWidget {
  const WeightTrackerScreen({super.key});

  @override
  State<WeightTrackerScreen> createState() => _WeightTrackerScreenState();
}

class _WeightTrackerScreenState extends State<WeightTrackerScreen> {
  final List<FlSpot> _weightData = const [
    FlSpot(0, 78),
    FlSpot(1, 79),
    FlSpot(2, 77.5),
    FlSpot(3, 78),
    FlSpot(4, 76.5),
    FlSpot(5, 78),
  ];

  final double _bmiValue = 22.2;
  String _selectedPeriod = 'Last 6 Months';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () {
            GoRouter.of(context).pushNamed('acccountpage');
          },
        ),
        title: Text(
          "Weight Tracker",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildWeightChartCard(),
              SizedBox(height: 24.h),
              _buildBmiCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightChartCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black12,
                    width: 1.w,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Weight",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(74, 74, 74, 1),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 34.h,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.w),
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPeriod,
                            isExpanded: false,
                            alignment: Alignment.center,
                            icon: Icon(Icons.keyboard_arrow_down, size: 20.sp),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                            items: <String>[
                              'Last 6 Months',
                              'Last 1 Year',
                              'All Time',
                            ].map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                alignment: Alignment.center,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedPeriod = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      IconButton(
                        icon: Icon(Icons.add, size: 28.sp),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 250.h,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: _weightData.length.toDouble() - 1,
                  minY: 74,
                  maxY: 80,
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: false,
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28.w,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 28.w,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            "Jul",
                            "Aug",
                            "Sep",
                            "Oct",
                            "Nov",
                            "Dec",
                          ];
                          if (value >= 0 && value < months.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                months[value.toInt()],
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return const Text("");
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _weightData,
                      isCurved: false,
                      color: const Color.fromRGBO(150, 79, 255, 1),
                      barWidth: 3.w,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4.r,
                            color: Colors.white,
                            strokeColor:
                            const Color.fromRGBO(150, 79, 255, 1),
                            strokeWidth: 2.w,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color.fromRGBO(150, 79, 255, 1)
                                .withOpacity(0.5),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "BMI (kg/m2): ${_bmiValue.toStringAsFixed(1)}",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.edit, size: 20.sp, color: Colors.black54),
              ],
            ),
            SizedBox(height: 8.h),
            Divider(thickness: 1.w, color: Colors.black12),
            SizedBox(
              height: 320.h,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 12,
                    maximum: 48,
                    startAngle: 180,
                    endAngle: 0,
                    showLabels: false,
                    showTicks: false,
                    axisLineStyle: AxisLineStyle(
                      thickness: 0.2,
                      color: Colors.black12,
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 12,
                        endValue: 18.5,
                        color: Colors.blue,
                        label: 'Under weight\n< 18.5',
                        labelStyle: GaugeTextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        sizeUnit: GaugeSizeUnit.factor,
                        startWidth: 0.5.w,
                        endWidth: 0.5.w,
                      ),
                      GaugeRange(
                        startValue: 18.5,
                        endValue: 24.9,
                        color: Colors.green,
                        label: 'Normal\n18.5 - 24.9',
                        labelStyle: GaugeTextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        sizeUnit: GaugeSizeUnit.factor,
                        startWidth: 0.5.w,
                        endWidth: 0.5.w,
                      ),
                      GaugeRange(
                        startValue: 24.9,
                        endValue: 29.9,
                        color: Colors.yellow,
                        label: 'Overweight\n25 - 29.9',
                        labelStyle: GaugeTextStyle(
                          color: Colors.black,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        sizeUnit: GaugeSizeUnit.factor,
                        startWidth: 0.5.w,
                        endWidth: 0.5.w,
                      ),
                      GaugeRange(
                        startValue: 29.9,
                        endValue: 39.9,
                        color: Colors.red,
                        label: 'Obese\n30 - 39.9',
                        labelStyle: GaugeTextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        sizeUnit: GaugeSizeUnit.factor,
                        startWidth: 0.5.w,
                        endWidth: 0.5.w,
                      ),
                      GaugeRange(
                        startValue: 39.9,
                        endValue: 48,
                        color: Colors.red.shade900,
                        label: 'Morbidly\nObese\n> 40',
                        labelStyle: GaugeTextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        sizeUnit: GaugeSizeUnit.factor,
                        startWidth: 0.5.w,
                        endWidth: 0.5.w,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: _bmiValue,
                        needleStartWidth: 1.w,
                        needleEndWidth: 20.w,
                        needleColor: Colors.black,
                        knobStyle: KnobStyle(
                          color: Colors.black,
                          sizeUnit: GaugeSizeUnit.factor,
                          knobRadius: 0.13.r,
                        ),
                      ),
                    ],
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
