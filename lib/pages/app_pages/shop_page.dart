import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  ShopPage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("you're logged in as " + user.email!),),
    );
  }
}
