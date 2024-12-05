import 'package:intl/intl.dart';

class AppDateFormatter {
  /// ***********************************************************************************
  ///                                15 APRIL 23' 12:00AM
  /// ***********************************************************************************

  static String formatToCustom(String dateString) {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    DateFormat formatter = DateFormat("dd MMM yy' at' hh:mma");
    return formatter.format(dateTime);
  }

  /// ***********************************************************************************
  ///                                15 April 2023
  /// ***********************************************************************************

  static String formatToDateOnly(String dateString) {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    DateFormat formatter = DateFormat("dd MMMM yyyy");
    return formatter.format(dateTime);
  }

  /// ***********************************************************************************
  ///                                  12:00 AM
  /// ***********************************************************************************

  static String formatToTimeOnly(String dateString) {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    DateFormat formatter = DateFormat("hh:mm a");
    return formatter.format(dateTime);
  }

  /// ***********************************************************************************
  ///                                   Monday
  /// ***********************************************************************************

  static String getDayOfWeek(String dateString) {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    DateFormat formatter = DateFormat("EEEE");
    return formatter.format(dateTime);
  }
}
