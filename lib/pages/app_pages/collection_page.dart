import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meowdoro/components/cat.dart';
import 'package:meowdoro/components/coupon.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _userMoney = 0;
  int _userCoupons = 0;
  int _userTime = 0;

  @override
  void initState() {
    super.initState();
    // Fetch user money when the widget is initialized
    getUserMoney();

  }

  Future<DocumentSnapshot> getCatData(String catId) {
    return FirebaseFirestore.instance.collection("Cats").doc(catId).get();
  }

  Future<List<String>> getAllCatIds() async {
    try {
      QuerySnapshot catSnapshot = await FirebaseFirestore.instance.collection("Cats").get();
      List<String> catIds = catSnapshot.docs.map((doc) => doc.id).toList();
      return catIds;
    } catch (e) {
      print("Error fetching cat IDs: $e");
      return [];
    }
  }

  Future<String?> getRandomCatId() async {
    List<String> catIds = await getAllCatIds();
    if (catIds.isNotEmpty) {
      Random random = Random();
      int randomIndex = random.nextInt(catIds.length);
      return catIds[randomIndex];
    } else {

      print("Returned null");
      return null;
    }
    // Return null if there are no cat IDs
  }
// Function to add cat to user
  // Function to add cat to user
  Future<void> addCatToUser(String userId, String catId) async {
    try {
      // Await the result of getCatData
      DocumentSnapshot catDoc = await getCatData(catId);

      if (catDoc.exists) {
        var catData = catDoc.data() as Map<String, dynamic>;

        // Add the cat data to the user's collection
        await FirebaseFirestore.instance
            .collection("User Details")
            .doc(userId)
            .collection("UserCats")
            .doc(catId) // Use the catId as the document ID
            .set(catData);

        print("Cat added successfully");
      } else {
        print("Cat document does not exist.");
      }
    } catch (e) {
      print("Error adding cat to user: $e");
    }
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

// Assuming _userMoney is a state variable

        } else {
          print("User data not found.");
        }
      }
    } catch (e) {
      print("Error fetching user money: $e");
    }
  }

  Future<void> setUserMoney() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      setState(() {
        _userCoupons -= 1;
      });

      if (currentUser != null) {
        String uid = currentUser.uid;

        await FirebaseFirestore.instance.collection("User Details").doc(uid).set({
          'UserMoney': _userMoney,
          'UserTime': _userTime,
          'UserCoupons': _userCoupons,
        });

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("User Money").doc(uid).get();

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

  // Stream to listen for user's cats
  Stream<QuerySnapshot> getUserCatsStream(String userId) {
    return FirebaseFirestore.instance
        .collection("User Details")
        .doc(userId)
        .collection("UserCats")
        .snapshots();
  }

  // Function to get specific cat data using catId




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Center(
          child: CouponDisplay(userCoupons: _userCoupons),
        ),
      ),
      body:
      StreamBuilder<QuerySnapshot>(
        stream: getUserCatsStream(user.uid), // Listen to the user's cats
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
              itemCount: userCatDocs.length,
              itemBuilder: (context, index) {
                // Get the catId from the user's "UserCats" collection
                String catId = userCatDocs[index].id;

                // Use FutureBuilder to get cat data for each catId
                return FutureBuilder<DocumentSnapshot>(
                  future: getCatData(catId),
                  builder: (context, catSnapshot) {
                    if (catSnapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text("Loading cat..."),
                      );
                    }

                    if (catSnapshot.hasError) {
                      return ListTile(
                        title: Text("Error loading cat: ${catSnapshot.error}"),
                      );
                    }

                    if (catSnapshot.hasData && catSnapshot.data!.exists) {
                      var catData = catSnapshot.data!.data() as Map<String, dynamic>;
                      return CatDisplay(cats: catData);
                    }

                    return ListTile(
                      title: Text("Cat not found"),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text("You don't have any cats! Start your meowdoro to earn Ms and cat coupons!"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[200],
        onPressed: () async {
          // Action to perform when button is pressed
          if (_userCoupons > 0){
            setUserMoney();
            var cat2add = await getRandomCatId();
            print(cat2add);
            addCatToUser(user.uid, cat2add!);
            DocumentSnapshot catDoc = await getCatData(cat2add);
            var catData = catDoc.data() as Map<String, dynamic>;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('You won ' + catData["Name"] + "!"),
                  content: SingleChildScrollView(
                    child: Image.asset(catData["image"]),
                  ),
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
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('No coupons left!'),
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
        tooltip: 'Redeem',
        child: Icon(Icons.pets_outlined), // Icon displayed on the button
      ),
    );
  }
}