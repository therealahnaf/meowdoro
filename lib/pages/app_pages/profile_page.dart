import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meowdoro/components/coupon.dart';

import '../../components/item.dart';
import '../../components/money.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _userMoney = 0;
  int _userTime = 0;
  int _userCoupons = 0;

  @override
  void initState() {
    super.initState();

    getUserMoney();
  }

  Stream<QuerySnapshot> getUserRedeemsStream(String userId) {
    return FirebaseFirestore.instance
        .collection("User Details")
        .doc(userId)
        .collection("UserRedeems")
        .snapshots();
  }

  Future<DocumentSnapshot> getRedeemData(String redeemId) {
    return FirebaseFirestore.instance.collection("UserRedeems").doc(redeemId).get();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
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

  String formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    if (hours == 0) {
      return '${minutes.toString()} minutes and ${seconds.toString()} seconds';
    } else {
      return '${hours.toString()} hour, ${minutes.toString()} minutes and ${seconds.toString()} seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const SizedBox(height: 10),

              // Logo
              Image.asset(
                "lib/images/cathome.png",
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 40),

              // Welcome message
              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),

              // User email
              Text(
                "You're logged in as " + user.email!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 30),

              // Productivity time
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "You've been productive for " +
                      formatDuration(_userTime.toInt()) +
                      "!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.orangeAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // User money display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MoneyDisplay(userMoney: _userMoney),
                  const SizedBox(
                    width: 10,
                  ),
                  CouponDisplay(userCoupons: _userCoupons)
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 10,),
                  Divider(color: Colors.orange[200], thickness: 3, indent: 30, endIndent: 30,),
                  const SizedBox(height: 20),
                  Text('Your History',
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
                    stream: getUserRedeemsStream(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }

                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        var userRedeemDocs = snapshot.data!.docs;

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: userRedeemDocs.length,
                          itemBuilder: (context, index) {
                            // Fetch the document data directly
                            var redeemData = userRedeemDocs[index].data() as Map<String, dynamic>;

                            return Column(
                              children: [
                                const SizedBox(width: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Display the redeemString
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(16),

                                        child: Text( redeemData["redeemString"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orangeAccent,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                const SizedBox(width: 20),
                              ],
                            );
                          },
                        );
                      } else {
                        return Center(child: Text("No redeems found for this user."));
                      }
                    },
                  ),
                ],
              )

            ],
          ),
        ),
        )
      ),
    );
  }
}
