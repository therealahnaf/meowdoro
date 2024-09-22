import 'package:flutter/material.dart';

class PriceDisplay extends StatelessWidget {
  final int itemPrice;

  // Constructor to accept itemPrice as a parameter
  const PriceDisplay({Key? key, required this.itemPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Add padding around the text
      decoration: BoxDecoration(
        color: Colors.red[200], // Background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Text(
        "Price: $itemPrice",
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
