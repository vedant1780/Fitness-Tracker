import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarckfit/services/summary_page.dart';

class Screen40 extends StatefulWidget {
  const Screen40({super.key});

  @override
  State<Screen40> createState() => _Screen40State();
}

class _Screen40State extends State<Screen40> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {"logo": "assets/paypal.png", "name": "PayPal", "ending": "andrew.ainsley@yourdomain.com"},
    {"logo": "assets/gpay.png", "name": "Google Pay", "ending": "andrew.ainsley@yourdomain.com"},
    {"logo": "assets/apple_pay.png", "name": "Apple Pay", "ending": "andrew.ainsley@yourdomain.com"},
    {"logo": "assets/master_card.png", "name": "Master Card", "ending": "---------..-- 1679"},
    {"logo": "assets/visa.png", "name": "Visa", "ending": "---------..-- 1679"},
    {"logo": "assets/amex.png", "name": "American Express", "ending": "---------..-- 1679"},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xffF5F5F5),
          leading: GestureDetector(
            onTap: () => GoRouter.of(context).pushNamed('planupgrade'),
            child: Icon(Icons.arrow_back, size: 30.sp),
          ),
          actions: [
            IconButton(
              onPressed: () => GoRouter.of(context).pushNamed('addpaymentmethods'),
              icon: Icon(Icons.add, size: 30.sp),
            ),
            SizedBox(width: 10.w),
          ],
          centerTitle: true,
          title: Text(
            "Choose Payment Methods",
            style: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.w700),
          ),
        ),

        // ✅ Scrollable content
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100.h),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              ...List.generate(paymentMethods.length, (index) {
                final method = paymentMethods[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: paymentCardTile(
                      logoPath: method["logo"],
                      brandName: method["name"],
                      cardEnding: method["ending"],
                      isSelected: selectedIndex == index,
                    ),
                  ),
                );
              }),
              SizedBox(height: 30.h),
            ],
          ),
        ),

        // ✅ Fixed OK button at the bottom
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: SizedBox(
            width: double.infinity,
            child: MaterialButton(
              height: 58.h,
              onPressed: () {
                final selectedMethod = paymentMethods[selectedIndex];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Screen41(selectedMethod: selectedMethod),
                  ),
                );
              },
              color: const Color(0xff7A1FFE),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
              child: Text(
                "OK",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );


  }
}

Widget paymentCardTile({
  required String logoPath,
  required String brandName,
  required String cardEnding,
  bool isSelected = false,
}) {
  return Container(
    height: 92.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(
        color: isSelected ? const Color(0xff7A1FFE) : Colors.white,
        width: 2.w,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Image.asset(logoPath, height: 60.h, width: 60.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  brandName,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  cardEnding,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Icon(Icons.check, color: const Color(0xff7A1FFE), size: 24.sp),
        ],
      ),
    ),
  );
}