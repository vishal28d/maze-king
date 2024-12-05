import '../exports.dart';

class AppAmountFormatter {
  AppAmountFormatter._();

  ///     double amount1 = 250000; // 2.5 lakh
  ///     double amount2 = 13000000; // 1.3 crore
  ///     double amount3 = 75000; // 75,000
  ///     double amount4 = 1000000; // 10 lakh (1.00 crore)

  static String defaultFormatter(num amount) {
    if (amount >= 100000) {
      // Amount is 1 lakh or more
      double inLakhs = amount / 100000;
      if (inLakhs >= 100) {
        // Amount is 1 crore or more
        double inCrores = inLakhs / 100;
        if (inCrores == inCrores.floorToDouble()) {
          return '${inCrores.floor()} Crore';
        } else {
          return '${inCrores.toStringAsFixed(2)} Crore';
        }
      } else {
        if (inLakhs == inLakhs.floorToDouble()) {
          return '${inLakhs.floor()} Lakh';
        } else {
          return '${inLakhs.toStringAsFixed(2)} Lakh';
        }
      }
    } else {
      return formatAmount(amount);
    }
  }
}
