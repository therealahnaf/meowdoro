import 'package:flutter/material.dart';

class CatDisplay extends StatelessWidget {
  final Map<String, dynamic> cats;

  // Constructor to accept cats as a parameter
  const CatDisplay({Key? key, required this.cats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Add padding around the text
      decoration: BoxDecoration(
        color: Colors.transparent, // Background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Column(
        children: [
          Image.asset(
            cats["image"]!, // Cat image
            height: 400, // Adjust height as needed
            fit: BoxFit.cover, // Ensure image fits well
          ),
          SizedBox(height: 8), // Space between image and text
          Text(
            cats['Name'] ?? 'Unknown Cat', // Cat name
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4), // Space between name and ability
          Text(
            cats['Ability'] ?? 'No Ability Listed', // Cat ability
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
