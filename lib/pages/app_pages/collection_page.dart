import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CollectionPage extends StatelessWidget {
  CollectionPage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("TODO"),),
    );
  }
}
