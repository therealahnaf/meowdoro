import 'package:flutter/material.dart';

class CouponDisplay extends StatelessWidget {
  final int userCoupons;

  // Constructor to accept userCoupons as a parameter
  const CouponDisplay({Key? key, required this.userCoupons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Add padding around the text
      decoration: BoxDecoration(
        color: Colors.green[200], // Background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Text(
        "$userCoupons Coupons",
        style: TextStyle(
          fontSize: 20, // Change the font size
          fontWeight: FontWeight.w900, // Make the text bold
          color: Colors.white, // Change the text color
          letterSpacing: 2.0, // Increase spacing between letters
        ),
      ),
    );
  }
}
