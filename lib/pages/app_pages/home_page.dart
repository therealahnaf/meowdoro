import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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

  TimeOfDay _selectedTime = TimeOfDay(hour: 0, minute: 0);  // Initial time set to current time


  // Function to open the time picker dialog and select a time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,  // The time initially displayed on the picker
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        timeSelected = (_selectedTime.hour * 3600) + (_selectedTime.minute * 60);
        selected = true;
        _remainingTime = timeSelected;// Update the selected time
      });
    }
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
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("User Money").doc(uid).get();

        if (userDoc.exists) {
          int userMoney = userDoc['UserMoney'];


            setState(() {
              _userMoney = userMoney;
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

        await FirebaseFirestore.instance.collection("User Money").doc(uid).set({
          'UserMoney': _userMoney + newMoney,
        });

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("User Money").doc(uid).get();

        if (userDoc.exists) {
          int userMoney = userDoc['UserMoney'];

          _userMoney = userMoney;  // Assuming _userMoney is a state variable

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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Add padding around the text
            decoration: BoxDecoration(
              color: Colors.orange[200], // Background color
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: Text(
              "Your Money: $_userMoney",
              style: TextStyle(
                fontSize: 20, // Change the font size
                fontWeight: FontWeight.w900, // Make the text bold
                color: Colors.white, // Change the text color
                letterSpacing: 2.0, // Increase spacing between letters
              ),
            ),
          ),

          const SizedBox(height: 20),
          if (selected && !started)
          Text("Selected: " + formatDuration(_remainingTime.toInt()).toString(),
              style: TextStyle(
                fontSize: 20, // Change the font size
                fontWeight: FontWeight.bold, // Make the text bold
                color: Colors.orangeAccent, // Change the text color
                letterSpacing: 2.0, // Increase spacing between letters
              )
          )
          else if (!selected) Text("Select a time!",
              style: TextStyle(
                fontSize: 20, // Change the font size
                fontWeight: FontWeight.bold, // Make the text bold
                color: Colors.orangeAccent, // Change the text color
                letterSpacing: 2.0, // Increase spacing between letters
              )
          ),
          if (started)
            Text(formatDuration(_remainingTime.toInt()),
                style: TextStyle(
                  fontSize: 40, // Change the font size
                  fontWeight: FontWeight.bold, // Make the text bold
                  color: Colors.orangeAccent, // Change the text color
                  letterSpacing: 2.0, // Increase spacing between letters
                )
            ),
          const SizedBox(height: 10),
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
              minimumSize: Size(100, 100), // Set the size to match the image size
              shape: CircleBorder(), // Make the button circular
              padding: EdgeInsets.all(0), // No padding
              backgroundColor: Colors.transparent, // Transparent background
              elevation: 0, // No elevation
            ),
            child: Container(
              width: 300, // Set width of the container
              height: 300, // Set height of the container
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Ensure the container is circular
              ),
              child: FittedBox(
                fit: BoxFit.cover, // Ensure the image covers the container
                child: Image.asset(
                  mikaipath, // Path to your image
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
              const SizedBox(width: 10),
              MyButton(
                text: "50 m",
                onTap: setTimeFifty,
              ),
              const SizedBox(width: 10),
              MyButton(
                text: "2 hrs",
                onTap: setTimeTwo,
              ),


            ],
          ),
          const SizedBox(height: 10),
          if (!started)
            MyButton(
              text: "Set Custom Time",
              onTap: () => _selectTime(context),
            ),

        ],
      )),
    );
  }
}
