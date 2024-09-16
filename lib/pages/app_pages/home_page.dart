import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  int timeSelected = 25;
  int _remainingTime = 25 * 60;

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
      circleButton_text = "STOP";
      _timer?.cancel(); // Cancel any previous timer before starting a new one
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _timer?.cancel(); // Stop the timer when it reaches zero
          }
        });
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 20),
          if (selected && !started)
          Text("Selected: " + timeSelected.toString(),
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
            Text(formatDuration(_remainingTime),
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
              ElevatedButton(
                onPressed: () {
                  setTimeTwentyFive();
                },
                child: Text(
                  '25 m',
                  style: TextStyle(
                    fontSize: 20, // Change the font size
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Colors.orangeAccent, // Change the text color
                    letterSpacing: 2.0, // Increase spacing between letters
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setTimeFifty();
                },
                child: Text(
                  '50 m',
                  style: TextStyle(
                    fontSize: 20, // Change the font size
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Colors.orangeAccent, // Change the text color
                    letterSpacing: 2.0, // Increase spacing between letters
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setTimeTwo();
                },
                child: Text(
                  '2 hrs',
                  style: TextStyle(
                    fontSize: 20, // Change the font size
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Colors.orangeAccent, // Change the text color
                    letterSpacing: 2.0, // Increase spacing between letters
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
