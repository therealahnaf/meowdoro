import 'package:flutter/material.dart';

class MoneyDisplay extends StatelessWidget {
  final int userMoney;

  // Constructor to accept userMoney as a parameter
  const MoneyDisplay({Key? key, required this.userMoney}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Add padding around the text
      decoration: BoxDecoration(
        color: Colors.orange[200], // Background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Text(
        "Your Money: $userMoney",
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
