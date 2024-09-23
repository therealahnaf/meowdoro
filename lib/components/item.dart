import 'package:flutter/material.dart';

class ItemDisplay extends StatefulWidget {
  final cats;
 // Callback function passed from the parent

  const ItemDisplay({Key? key, required this.cats}) : super(key: key);

  @override
  State<ItemDisplay> createState() => _ItemDisplayState();
}

class _ItemDisplayState extends State<ItemDisplay> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Add padding around the text
      decoration: BoxDecoration(
        color: Colors.orange[200], // Background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes widgets evenly in the row
        children: [
          // Left side: Cat image and ability
          Expanded(
            child: ListTile(
              leading: Image.asset(
                "lib/images/cathome.png",
                height: 200,
              ), // Cat image
              title: Text(widget.cats['Ability']), // Cat ability
               // Additional info
            ),
          ),

          // Right side: Price as a button

        ],
      ),
    );
  }
}
