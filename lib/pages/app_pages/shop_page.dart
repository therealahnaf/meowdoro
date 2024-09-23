import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meowdoro/components/coupon.dart';
import 'package:meowdoro/components/price.dart';
import 'package:meowdoro/components/widget_spinning_wheel.dart';

import '../../components/cat.dart';
import '../../components/item.dart';
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
  int price = 0;

  @override
  void initState() {
    super.initState();
    getUserMoney();
  }

  Future<DocumentSnapshot> getCatData(String catId) {
    return FirebaseFirestore.instance.collection("Cats").doc(catId).get();
  }

  Stream<QuerySnapshot> getUserCatsStream(String userId) {
    return FirebaseFirestore.instance
        .collection("User Details")
        .doc(userId)
        .collection("UserCats")
        .snapshots();
  }

  Future<void> getUserMoney() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("User Details")
            .doc(uid)
            .get();

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
        await FirebaseFirestore.instance
            .collection("User Details")
            .doc(uid)
            .set({
          'UserMoney': _userMoney,
          'UserTime': _userTime,
          'UserCoupons': _userCoupons,
        });

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("User Details")
            .doc(uid)
            .get();

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



  Future<void> setUserItemBought(int item_price, String redeem_str) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      setState(() {
        _userMoney = _userMoney - item_price;
      });

      if (currentUser != null) {
        String uid = currentUser.uid;
        await FirebaseFirestore.instance
            .collection("User Details")
            .doc(uid)
            .set({
          'UserMoney': _userMoney,
          'UserTime': _userTime,
          'UserCoupons': _userCoupons,
        });

        await FirebaseFirestore.instance
            .collection("User Details")
            .doc(uid).collection("UserRedeems")
            .add({
              'redeemString': redeem_str
        });

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("User Details")
            .doc(uid)
            .get();

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

  bool won = false;
  String selectedLabel = '';
  var reward;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Make the whole page scrollable
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MoneyDisplay(userMoney: _userMoney),
                  const SizedBox(width: 5),
                  CouponDisplay(userCoupons: _userCoupons),
                ],
              ),
              const SizedBox(height: 15),
              if (_userMoney >= 1000) Icon(Icons.arrow_downward_rounded, size: 80, color: Colors.orange[200]),
              if (_userMoney < 1000) Icon(Icons.lock_rounded, size: 80, color: Colors.orange[200],),
              if (_userMoney >= 1000)
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
                          title: Text('You Won $label!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Accept'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  size: 200,
                ),
              const SizedBox(height: 20),
              if (_userMoney >= 1000) Text("Tap on the wheel to spin!"),
              if (_userMoney > 1000) const SizedBox(height: 20),
              PriceDisplay(itemPrice: 1000),
              const SizedBox(height: 20),
              if (_userMoney < 1000) Text("You don't have enough money for the spin!"),
              const SizedBox(height: 20),
              Divider(color: Colors.orange[200], thickness: 3, indent: 30, endIndent: 30,),
              const SizedBox(height: 20),
              Text('Unlocked Shop Items',
                style: TextStyle(
                  fontSize: 20, // Change the font size
                  fontWeight: FontWeight.w900, // Make the text bold
                  color: Colors.orange, // Change the text color
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.orange[200], thickness: 3, indent: 30, endIndent: 30,),
              StreamBuilder<QuerySnapshot>(
                stream:
                    getUserCatsStream(user.uid), // Listen to the user's cats
                builder: (context, snapshot) {
                  // Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Error handling
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  // Data retrieved successfully
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    var userCatDocs = snapshot.data!.docs;

                    return ListView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), // Prevents conflict with SingleChildScrollView
                      shrinkWrap:
                          true, // Ensures the ListView doesn't take up infinite height
                      itemCount: userCatDocs.length,
                      itemBuilder: (context, index) {
                        // Get the catId from the user's "UserCats" collection
                        String catId = userCatDocs[index].id;

                        // Use FutureBuilder to get cat data for each catId
                        return FutureBuilder<DocumentSnapshot>(
                          future: getCatData(catId),
                          builder: (context, catSnapshot) {
                            if (catSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListTile(
                                title: Text("Loading cat..."),
                              );
                            }

                            if (catSnapshot.hasError) {
                              return ListTile(
                                title: Text(
                                    "Error loading cat: ${catSnapshot.error}"),
                              );
                            }

                            if (catSnapshot.hasData &&
                                catSnapshot.data!.exists) {
                              var catData = catSnapshot.data!.data()
                                  as Map<String, dynamic>;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between the cat data and the button
                                children: [
                                  // Display the cat data

                                  Expanded(
                                    child: ItemDisplay(
                                      cats: catData,
                                    ),
                                  ),

                                  // Display the button on the right side
                                  TextButton(
                                    onPressed: () {
                                      price = catData["Price"];

                                      if (_userMoney >= price){
                                        String dialog = catData["Name"]+ ' helped you redeem: '+ catData["Ability"];
                                        setUserItemBought(price, dialog);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(dialog),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Yay!'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Not enough Ms'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Ok'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red[200], // Text color
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                    child: Text('${catData['Price'].toString()} Ms'), // Display the price
                                  ),
                                  const SizedBox(width: 10,)
                                ],
                              );

                            }



                            return ListTile(
                              title: Text("Cat not found"),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("No cats found for this user."));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
