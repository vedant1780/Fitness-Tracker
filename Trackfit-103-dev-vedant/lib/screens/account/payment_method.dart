import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarckfit/screens/account/add_payment.dart';
import 'package:tarckfit/widgets/template.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethod {
  final String name;
  final String? email;
  final String? number;
  final String icon;

  PaymentMethod({
    required this.name,
    this.email,
    this.number,
    required this.icon,
  });
}

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethod> methods = [
    PaymentMethod(
      name: "PayPal",
      email: "andrew.ainsley@yourdo...",
      icon: "assets/paypal.png",
    ),
    PaymentMethod(
      name: "Google Pay",
      email: "andrew.ainsley@yourdo...",
      icon: "assets/gpay.png",
    ),
    PaymentMethod(
      name: "Apple Pay",
      email: "andrew.ainsley@yourdo...",
      icon: "assets/apple_pay.png",
    ),
    PaymentMethod(
      name: "Mastercard",
      number: "**** **** **** 4679",
      icon: "assets/master_card.png",
    ),
    PaymentMethod(
      name: "Visa",
      number: "**** **** **** 5567",
      icon: "assets/visa.png",
    ),
  ];

  void _addNewPayment(PaymentMethod newMethod) {
    setState(() {
      methods.add(newMethod);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea( // ✅ Added SafeArea here
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).push('/accountpage');
            },
            icon: Icon(Icons.arrow_back, size: 22.sp),
          ),
          backgroundColor: const Color(0xFFF5F5F5),
          title: Text(
            "Payment Methods",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 21.8.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: methods.length,
                  itemBuilder: (context, index) {
                    final method = methods[index];
                    return Padding(
                      padding: EdgeInsets.all(9.5.w),
                      child: Container(
                        height: 96.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Center(
                          child: ListTile(
                            leading: Image.asset(
                              method.icon,
                              width: 60.w,
                              height: 60.h,
                            ),
                            title: Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                method.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.6.sp,
                                  color: const Color(0xFF474847),
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 11.h),
                              child: Text(
                                method.email ?? method.number ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.1.sp,
                                  color: const Color(0xFF999999),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            trailing: Text(
                              "Connected",
                              style: TextStyle(
                                color: const Color(0xFF8B8B8B),
                                fontSize: 16.2.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            visualDensity: const VisualDensity(horizontal: -4),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddPaymentScreen()),
                    );
                    if (result is PaymentMethod) {
                      _addNewPayment(result);
                    }
                  },
                  child: Text(
                    "+  Add New Payment",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFDACDFD),
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
