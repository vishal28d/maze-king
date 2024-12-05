import 'enums/timer_enums.dart';

class TimerCalculations {
  static int calculateTimeDifference(DateTime startDate, DateTime endDate, {TimeUnit timeUnit = TimeUnit.seconds}) {
    Duration difference = endDate.difference(startDate);

    switch (timeUnit) {
      case TimeUnit.microseconds:
        return difference.inMicroseconds < 0 ? 0 : difference.inMicroseconds;
      case TimeUnit.milliseconds:
        return difference.inMilliseconds < 0 ? 0 : difference.inMilliseconds;
      case TimeUnit.seconds:
        return difference.inSeconds < 0 ? 0 : difference.inSeconds;
      case TimeUnit.minutes:
        return difference.inMinutes < 0 ? 0 : difference.inMinutes;
      default:
        throw ArgumentError('Unsupported time unit.');
    }
  }
}
