import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularCountdownTimer extends StatefulWidget {
  final int seconds;
  final String subtitle;
  final double size;

  const CircularCountdownTimer({
    super.key,
    required this.seconds,
    required this.subtitle,
    this.size = 100,
  });

  @override
  CircularCountdownTimerState createState() => CircularCountdownTimerState();
}

class CircularCountdownTimerState extends State<CircularCountdownTimer> {
  late int remainingTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.seconds;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void resetTimer() {
    setState(() {
      remainingTime = widget.seconds; // Reset to the initial value
    });
    startTimer(); // Restart the timer
  }

  void stopTimer() {
    if (timer.isActive) {
      timer.cancel(); // Stop the timer
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                value: 1 - (remainingTime / widget.seconds), // Clockwise countdown
                strokeWidth: 8, // Thickness of the border
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.grey), // Red color
                backgroundColor: Colors.red, // Light background for the border
              ),
            ),
            Text(
              "$remainingTime",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).cardColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h), // space between the timer and the subtitle
        Text(
          widget.subtitle,
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).cardColor.withOpacity(0.75),
          ),
        ),
      ],
    );
  }
}
