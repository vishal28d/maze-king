import 'dart:core';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppRemainingTimeCalculator {
  AppRemainingTimeCalculator._();

  /// ***********************************************************************************
  ///                                        UTILS
  /// ***********************************************************************************
  static int hoursToMilliseconds(int hours) {
    return hours * 60 * 60 * 1000;
  }

  static int minutesToMilliseconds(int minutes) {
    return minutes * 60 * 1000;
  }

  static int secondsToMilliseconds(int seconds) {
    return seconds * 1000;
  }

  static bool isTomorrow(DateTime date) {
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    DateTime dateWithoutTime = DateTime(date.year, date.month, date.day);

    return dateWithoutTime.isAtSameMomentAs(tomorrow);
  }

  /// ***********************************************************************************
  ///                                        DEFAULT
  /// ***********************************************************************************

  static String defaultCalculation(DateTime startTime, {bool showSecondsInHourFormat = false}) {
    DateTime gameStartTime = startTime.toLocal();

    DateTime now = DateTime.now();

    // Check if the game is scheduled for today
    if (now.year == gameStartTime.year && now.month == gameStartTime.month && now.day == gameStartTime.day) {
      // Check if the game has already started
      if (now.isAfter(gameStartTime)) {
        return '0s';
      }

      // Calculate remaining time
      Duration remainingTime = gameStartTime.difference(now);

      // Check if remaining time is less than or equal to 60
      return _calculateRemainingTimeByDuration(remainingTime: remainingTime, showSecondsInHourFormat: showSecondsInHourFormat);
    }

    // Check if the game is scheduled for tomorrow
    else if (now.year == gameStartTime.year && now.month == gameStartTime.month && now.day + 1 == gameStartTime.day) {
      return 'Tomorrow';
    } else if (gameStartTime.isBefore(now)) {
      return "0s";
    }
    // Game is scheduled for a future date
    else {
      String formattedDate = DateFormat('d MMM').format(gameStartTime);
      return formattedDate;
    }
  }

  /// ***********************************************************************************
  ///                         REMAINING TIME BY REMAINING DURATION
  /// ***********************************************************************************

  static String getByRemainingDuration(DateTime startTime, {required Duration remainingTime, bool showSecondsInHourFormat = false, required Function() whenComplete}) {
    DateTime gameStartTime = startTime.toLocal();

    String dateFormat(DateTime dateTime) => DateFormat('d MMM').format(dateTime);

    // Duration is less than 48 hours
    if (remainingTime.inMilliseconds <= hoursToMilliseconds(48)) {
      whenComplete();
      if (remainingTime.inMilliseconds <= hoursToMilliseconds(24)) {
        return _calculateRemainingTimeByDuration(remainingTime: remainingTime, showSecondsInHourFormat: showSecondsInHourFormat, addExtraSec: false);
      } else if (isTomorrow(gameStartTime)) {
        return 'Tomorrow';
      } else {
        return dateFormat(gameStartTime);
      }
    } else {
      return dateFormat(gameStartTime);
    }
  }

  /// ***********************************************************************************
  ///
  /// ***********************************************************************************

  static String _padLeftZero(int value, {int width = 2}) {
    return value.toString().padLeft(width, '0');
  }

  static String _calculateRemainingTimeByDuration({
    required Duration remainingTime,
    bool showSecondsInHourFormat = false,
    bool addExtraSec = true,
  }) {
    if ((remainingTime.inMilliseconds) <= 0) {
      return '0s';
    } else if ((remainingTime.inMilliseconds) <= 60 * 1000) {
      return '${_padLeftZero(remainingTime.inSeconds == 60 ? remainingTime.inSeconds : remainingTime.inSeconds + (addExtraSec ? 1 : 0))}s';
    }

    // Check if remaining time is less than 60 minutes
    else if (remainingTime.inMilliseconds < 60 * (60 * 1000)) {
      return '${_padLeftZero(remainingTime.inMinutes)}m ${_padLeftZero((remainingTime.inSeconds % 60).isEqual(60) ? remainingTime.inSeconds % 60 : (remainingTime.inSeconds % 60) + (addExtraSec ? 1 : 0))}s';
    }

    // Remaining time is 60 minutes or more
    else {
      return '${_padLeftZero(remainingTime.inHours)}h ${(remainingTime.inMinutes % 60).isEqual(0) ? "" : '${_padLeftZero(remainingTime.inMinutes % 60)}m '}${showSecondsInHourFormat ? '${_padLeftZero(remainingTime.inSeconds % 60)}s' : ''}'.trim();
    }
  }
}
