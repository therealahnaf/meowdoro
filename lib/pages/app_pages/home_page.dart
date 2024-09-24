import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meowdoro/components/money.dart';
import 'dart:async';
import 'package:time_picker_spinner/time_picker_spinner.dart';

import '../../components/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userCredential = FirebaseAuth.instance.currentUser!;

  double timeSelected = 25;
  double _remainingTime = 25 * 60;
  int _userMoney = 404;
  int newMoney = 0;
  int _userTime = 0;
  int _userCoupons = 0;
  int newTime = 0;
  bool custom = false;
  var dateTime= DateTime.now();

  @override
  void initState() {
    super.initState();
    // Fetch user money when the widget is initialized
    getUserMoney();

  }

  bool started = false;
  bool selected = false;
  String circleButton_text = "START";
  String mikaipath = 'lib/images/mikaisad_button-export.png';

  String formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    if (hours == 0){
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }



  // Function to open the time picker dialog and select a time

  void selectT(){
    selected = true;
    selectCustomTime();
  }

  void selectCustomTime() {
    setState(() {
      custom = !custom;
      timeSelected = (dateTime.hour * 3600) + (dateTime.minute * 60) + dateTime.second.toDouble();
      _remainingTime = timeSelected;// Update the selected time
    });
    print(dateTime);
  }

  void setTimeTwentyFive() {
    setState(() {
      timeSelected = 25;
      _remainingTime = 25 * 60;
      selected = true;
    });
  }

  void setTimeFifty() {
    setState(() {
      timeSelected = 50;
      _remainingTime = 50 * 60;
      selected = true;
    });
  }

  void setTimeTwo() {
    setState(() {
      timeSelected = 2;
      _remainingTime = 2 * 60 * 60;
      selected = true;
    });
  }

  Timer? _timer; // Timer object

  void cancelTimer() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    setState(() {
      circleButton_text = "START";
      started = false;
      selected = false;
    });
  }

  void startTimer() {
    if (selected){
      started = true;
      _timer?.cancel(); // Cancel any previous timer before starting a new one
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
            newTime++;
            if (_remainingTime % 2 == 0){
              newMoney++;
            }
          } else {
            _timer?.cancel();
            setUserMoney();
            getUserMoney();
            started = false;
            selected = false;
          }
        });
      });
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

      if (currentUser != null) {
        String uid = currentUser.uid;

        await FirebaseFirestore.instance.collection("User Details").doc(uid).set({
          'UserMoney': _userMoney + newMoney,
          'UserTime': _userTime + newTime,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          MoneyDisplay(userMoney: _userMoney),
          const SizedBox(height: 20),
          Divider(color: Colors.orange[200], thickness: 3, indent: 30, endIndent: 30,),
          const SizedBox(height: 10),
          if (selected && !started)
          Text("Selected: " + formatDuration(_remainingTime.toInt()).toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
                letterSpacing: 2.0,
              )
          )
          else if (!selected) Text("Select a time!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
                letterSpacing: 2.0,
              )
          ),
          if (started)
            Text(formatDuration(_remainingTime.toInt()),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                  letterSpacing: 2.0,
                )
            ),
          const SizedBox(height: 10),
          Divider(color: Colors.orange[200], thickness: 3, indent: 30, endIndent: 30,),
          ElevatedButton(
            onPressed: () {
              if (started) {
                cancelTimer();
                mikaipath = 'lib/images/mikaisad_button-export.png';
              } else if (selected) {
                startTimer();
                mikaipath = 'lib/images/mikai_button-export.png';
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 100),
              shape: CircleBorder(),
              padding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset(
                  mikaipath,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          if (!started)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                text: "25 m",
                onTap: setTimeTwentyFive,
              ),
              const SizedBox(width: 5),
              MyButton(
                text: "50 m",
                onTap: setTimeFifty,
              ),
              const SizedBox(width: 5),
              MyButton(
                text: "2 hrs",
                onTap: setTimeTwo,
              ),


            ],
          ),
          const SizedBox(height: 10),
          if (!started && !custom)
            MyButton(
              text: "Set Custom Time",
              onTap: () => selectCustomTime(),
            ),
          if (custom && !selected)
            Column(
              children: [
                TimePickerSpinner(
                  locale: const Locale('en', ''),
                  time: dateTime,
                  is24HourMode: true,
                  isShowSeconds: true,
                  itemHeight: 30,
                  normalTextStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  highlightedTextStyle:
                  const TextStyle(fontSize: 24, color: Colors.blue),
                  isForce2Digits: true,
                  onTimeChange: (time) {
                    setState(() {
                      dateTime = time;
                    });
                  },
                ),
                MyButton(
                  text: "Set",
                  onTap: () => selectT(),
                ),
              ],
            )


        ],
      )),
    );
  }
}
