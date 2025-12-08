import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarckfit/screens/account/payment_method.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:card_scanner/card_scanner.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final TextEditingController cardController = TextEditingController();
  final TextEditingController holderController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  String? selectedName;
  String? selectedIcon;

  @override
  void initState() {
    super.initState();
    expiryController.text = "06/28";
  }

  void _pickExpiryDate() async {
    DateTime now = DateTime.now();

    final picked = await showMonthPicker(
      context: context,
      firstDate: DateTime(now.year, now.month),
      lastDate: DateTime(now.year + 15),
      initialDate: now,
    );

    if (picked != null) {
      setState(() {
        expiryController.text = DateFormat("MM/yy").format(picked);
      });
    }
  }

  Future<void> _scanCard() async {
    final cardDetails = await CardScanner.scanCard(
      scanOptions: const CardScanOptions(
        scanCardHolderName: true,
        scanExpiryDate: true,
      ),
    );

    if (!mounted || cardDetails == null) return;

    setState(() {
      cardController.text = cardDetails.cardNumber;
      holderController.text = cardDetails.cardHolderName;
      expiryController.text = cardDetails.expiryDate;

      final number = cardDetails.cardNumber;
      if (number.startsWith('4')) {
        selectedName = "Visa";
        selectedIcon = "assets/VISA 2.png";
      } else if (number.startsWith('5')) {
        selectedName = "Mastercard";
        selectedIcon = "assets/mastercard.png";
      } else if (number.startsWith('34') || number.startsWith('37')) {
        selectedName = "American Express";
        selectedIcon = "assets/amexp.png";
      } else if (number.startsWith('35')) {
        selectedName = "JCB";
        selectedIcon = "assets/jcb.png";
      } else {
        selectedName = "Unknown";
        selectedIcon = "assets/unknown.png";
      }
    });
  }

  void _savePayment() {
    final card = cardController.text;
    if (card.isNotEmpty && selectedName != null && selectedIcon != null) {
      final last4 = card.substring(card.length - 4);
      final newMethod = PaymentMethod(
        name: selectedName!,
        number: "**** **** **** $last4",
        icon: selectedIcon!,
      );
      Navigator.pop(context, newMethod);
    }
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9.r),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildHeadingField(String title, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.9.sp,
            color: const Color(0xFF4D4D4D),
          ),
        ),
        SizedBox(height: 14.h),
        field,
      ],
    );
  }

  Widget _buildPaymentIcon(String name, String iconPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedName = name;
          selectedIcon = iconPath;
        });
      },
      child: Image.asset(
        iconPath,
        width: 50.w,
        height: 32.h,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea( // ✅ Added SafeArea (keeps all UI identical)
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "Add New Payment",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 21.8.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: ImageIcon(
              const AssetImage("assets/Image (30).png"),
              size: 32.sp,
            ),
          ),
          actions: [
            IconButton(
              icon: ImageIcon(
                const AssetImage("assets/Image (31).png"),
                size: 32.sp,
              ),
              onPressed: _scanCard,
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildHeadingField(
                "Card Number",
                TextField(
                  controller: cardController,
                  decoration: _inputDecoration(),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 32.h),
              _buildHeadingField(
                "Account Holder Name",
                TextField(
                  controller: holderController,
                  decoration: _inputDecoration(),
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: _buildHeadingField(
                      "Expiry Date",
                      GestureDetector(
                        onTap: _pickExpiryDate,
                        child: AbsorbPointer(
                          child: TextField(
                            controller: expiryController,
                            decoration: _inputDecoration().copyWith(
                              suffixIcon:
                              const Icon(Icons.keyboard_arrow_down),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildHeadingField(
                      "CVV",
                      TextField(
                        controller: cvvController,
                        decoration: _inputDecoration(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              Divider(
                color: const Color(0xFFEBEBEC),
                height: 1.h,
              ),
              SizedBox(height: 25.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Supported Payments:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.8.sp,
                    color: const Color(0xFF505050),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 1.sw, // full width
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPaymentIcon("Mastercard", "assets/mastercard.png"),
                      _buildPaymentIcon("Visa", "assets/VISA 2.png"),
                      _buildPaymentIcon("Amazon", "assets/amazon.png"),
                      _buildPaymentIcon("American Express", "assets/amexp.png"),
                      _buildPaymentIcon("JCB", "assets/jcb.png"),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                onPressed: _savePayment,
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 16.2.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFDACDFD),
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