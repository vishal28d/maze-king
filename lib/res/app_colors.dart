import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static Color primary = const Color(0xff0D1442);
  static Color backgroundLight = const Color(0xffF4F6FF);
  static Color backgroundDark = const Color(0xff313131);

  static Color fontLightMode = const Color(0xff0D1442);
  static Color fontDarkMode = const Color(0xff0D1442);

  static Color secondary = const Color(0xffFF8B00);
  static Color tertiary = const Color(0xffEE4036);

  static Color secondarySubColor = secondary.withOpacity(0.14);
  static Color tertiarySubColor = tertiary.withOpacity(0.14);
  static Color green = Colors.green;
  static Color red = Colors.red;

  static Color gameBackground = Colors.transparent;
  static Color gameWall = AppColors.primary /* Colors.grey.shade800*/;

  static Color gameTraversablePath = Colors.transparent;
  static Color gameBall = Colors.green;
  static Color gameDestination = Colors.green;
  static Color gameCompletedPath = Colors.green;
  static Color gameWinningPath = Colors.red.withOpacity(0.2);

  static Color authTitle = Colors.white;
  static Color authSubTitle = const Color(0xffAEB2C4);

  static Color error = Colors.red;

  static Color unselectedIcon(BuildContext context) => Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8);

  static Color subTextColor(BuildContext context) => Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6);

  static Color darkBlue = const Color(0xff001D61);
  static Color black = const Color(0xff242424);
  static Color whiteSmoke = const Color(0xffF1F1FF);
  static Color cyanBg = const Color(0xffE6F7FF);

  static List<Color> bannerGradientColorList = [
    const Color(0xff169A8A).withOpacity(0.1),
    const Color(0xffFFD83D).withOpacity(0.1),
    const Color(0xffFFD83D).withOpacity(0.1),
    const Color(0xffFF417E).withOpacity(0.1),
  ];

  static ColorFilter iconColorFilter(BuildContext context, {Color? color}) => ColorFilter.mode(color ?? Theme.of(context).iconTheme.color!, BlendMode.srcIn);

  static Color getColorOnBackground(Color backgroundColor, {bool reverse = false}) {
    if (backgroundColor.computeLuminance() < 0.5) {
      return reverse == true ? Colors.black : Colors.white;
    } else {
      return reverse == true ? Colors.white : Colors.black;
    }
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String fromColor(Color color) {
    String hex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    return hex;
  }
}
