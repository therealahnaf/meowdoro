import 'package:flutter/material.dart';

class CatDisplay extends StatelessWidget {
  final Map<String, dynamic> cats;

  // Constructor to accept cats as a parameter
  const CatDisplay({Key? key, required this.cats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 200, vertical: 8), // Add padding around the text
      decoration: BoxDecoration(
        color: Colors.orange[100], // Background color
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown, width: 5),// Rounded corners
      ),
      child: Column(
        children: [
          Image.asset(
            cats["image"]!, // Cat image
            height: 400, // Adjust height as needed
            fit: BoxFit.fill, // Ensure image fits well
          ),
          SizedBox(height: 8), // Space between image and text
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Add padding around the text
          decoration: BoxDecoration(
            color: Colors.orange[300], // Background color
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Text(
            cats["Name"],
            style: TextStyle(
              fontSize: 20, // Change the font size
              fontWeight: FontWeight.w900, // Make the text bold
              color: Colors.white, // Change the text color
              letterSpacing: 2.0, // Increase spacing between letters
            ),
          ),
        ),
          SizedBox(height: 4), // Space between name and ability
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Add padding around the text
        decoration: BoxDecoration(
          color: Colors.orange[200], // Background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Text(
          "Ability: "+cats["Ability"],
          style: TextStyle(
            fontSize: 16, // Change the font size
            fontWeight: FontWeight.w900, // Make the text bold
            color: Colors.white, // Change the text color
            letterSpacing: 1.0, // Increase spacing between letters
          ),
        ),
      )
        ],
      ),
    );
  }
}
