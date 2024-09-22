import 'package:flutter/material.dart';

class CatDisplay extends StatelessWidget {
  final cats;

  // Constructor to accept userCoupons as a parameter
  const CatDisplay({Key? key, required this.cats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),// Add padding around the text
      decoration: BoxDecoration(
        color: Colors.green[200], // Background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: ListTile(
        leading: Image.network(cats['image']), // Cat image
        title: Text(cats['Name']), // Cat name
        subtitle: Text(cats['Ability']), // Cat ability
      ),
    );
  }
}
