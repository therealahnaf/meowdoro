import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meowdoro/components/coupon.dart';
import 'package:meowdoro/components/price.dart';
import 'package:meowdoro/components/widget_spinning_wheel.dart';

import '../../components/money.dart';

class ShopPage extends StatefulWidget {
  ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _userMoney = 0;
  int _userCoupons = 0;
  int _userTime = 0;

  @override
  void initState() {
    super.initState();
    getUserMoney();
  }

  Future<void> getUserMoney() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("User Details").doc(uid).get();

        if (userDoc.exists) {
          int userMoney = userDoc['UserMoney'];
          int userTime = userDoc['UserTime'];
          int userCoupons = userDoc['UserCoupons'];

          setState(() {
            _userMoney = userMoney;
            _userTime = userTime;
            _userCoupons = userCoupons;
          });
        } else {
          print("User data not found.");
        }
      }
    } catch (e) {
      print("Error fetching user money: $e");
    }
  }

  Future<void> setUserMoney(int reward) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      setState(() {
        if (reward != 1) {
          _userMoney = _userMoney + reward - 1000;
        } else {
          _userMoney -= 1000;
          _userCoupons += 1;
        }
      });

      if (currentUser != null) {
        String uid = currentUser.uid;
        await FirebaseFirestore.instance.collection("User Details")
            .doc(uid)
            .set({
          'UserMoney': _userMoney,
          'UserTime': _userTime,
          'UserCoupons': _userCoupons,
        });

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("User Details").doc(uid).get();

        if (userDoc.exists) {
          int userMoney = userDoc['UserMoney'];
          int userTime = userDoc['UserTime'];
          int userCoupons = userDoc['UserCoupons'];

          _userMoney = userMoney;
          _userTime = userTime;
          _userCoupons = userCoupons;
        } else {
          print("User data not found.");
        }
      }
    } catch (e) {
      print("Error fetching user money: $e");
    }
  }

  void setReward(String option) {
    if (option == "1000 Ms") {
      reward = 1000;
    } else if (option == "3000 Ms") {
      reward = 3000;
    } else {
      reward = 1;
    }
  }

  bool won = false;
  String selectedLabel = '';
  var reward;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Make the whole page scrollable
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MoneyDisplay(userMoney: _userMoney),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_downward_rounded, size: 80),
                  const SizedBox(width: 5),
                  CouponDisplay(userCoupons: _userCoupons),
                ],
              ),

              if (_userMoney > 1000)
                WidgetSpinningWheel(
                  labels: ['1000 Ms', 'Cat Coupon', '3000 Ms'],
                  onSpinComplete: (String label) {
                    setState(() {
                      selectedLabel = label;
                      won = true;
                      setReward(label);
                      setUserMoney(reward);
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Selected Option'),
                          content: Text('You Won $label!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  size: 500,
                ),
              if (_userMoney > 1000)
                const SizedBox(height: 20),
              Text("Tap on the wheel to spin!"),
              const SizedBox(height: 20),
              PriceDisplay(itemPrice: 1000),
              const SizedBox(height: 20),
              if (_userMoney <= 1000)
                Text("You don't have enough money!"),
            ],
          ),
        ),
      ),
    );
  }
}
