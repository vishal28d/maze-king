class AppTimerFormatter {
  AppTimerFormatter._();

  static String _formatHour(DateTime dateTime) {
    int formattedHour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    return formattedHour.toString().padLeft(2, '0');
  }

  static String _formatMinutes(DateTime dateTime) {
    return dateTime.minute.toString().padLeft(2, '0');
  }

  static String _formatPeriod(DateTime dateTime) {
    return dateTime.hour < 12 ? 'AM' : 'PM';
  }

  /// *****************************************************
  /// *******************   01:45 PM    *******************
  /// *****************************************************

  static String hourMinAMPM(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);
    return '${_formatHour(dateTime)}:${_formatMinutes(dateTime)} ${_formatPeriod(dateTime)}';
  }
}
