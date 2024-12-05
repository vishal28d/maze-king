import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maze_king/res/app_colors.dart';

class AppTheme {
  static String fontFamilyName = 'Outfit';

  static ThemeData lightMode(BuildContext context, {Color? kPrimaryColor, Color? kSecondaryColor, Color? kTertiaryColor, Color? kBackgroundColor, Color? errorColor, String? fontFamily}) {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.comfortable,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        shadowColor: const Color(0xFFdedcdc),
        indicatorColor: kPrimaryColor,
        splashColor: kPrimaryColor?.withOpacity(0.2),
        hoverColor: kPrimaryColor?.withOpacity(0.1),
        splashFactory: InkRipple.splashFactory,
        canvasColor: const Color(0xFFFFFFFF),
        disabledColor: const Color(0xFFD3D9DD),
        textTheme: buildTextTheme(base: base.textTheme, myFontFamily: fontFamily, fontColor: AppColors.fontLightMode),
        primaryTextTheme: buildTextTheme(base: base.primaryTextTheme, myFontFamily: fontFamily, fontColor: AppColors.fontLightMode),
        colorScheme: const ColorScheme.light().copyWith(
          error: errorColor,
          primary: kPrimaryColor,
          surface: kBackgroundColor,
          secondary: kSecondaryColor,
          tertiary: kTertiaryColor,
        ),
        buttonTheme: ButtonThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.orange,
              ),
        ),

        // Widgets Theme
        appBarTheme: AppBarTheme(
          color: kPrimaryColor,
          titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        ),
        popupMenuTheme: const PopupMenuThemeData(color: Color(0xFFFFFFFF)),
        tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(color: const IconThemeData().color),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FCFF),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: kPrimaryColor ?? const Color(0xFF000000), width: 0.4),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff2b2b2b)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kPrimaryColor,
          foregroundColor: base.iconTheme.color,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.sp, color: AppColors.primary),
          unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.sp, color: AppColors.unselectedIcon(context)),
          unselectedItemColor: AppColors.unselectedIcon(context),
          backgroundColor: AppColors.primary.withOpacity(0.5),
        ),
        tabBarTheme: TabBarTheme(
          tabAlignment: TabAlignment.start,
          labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: Theme.of(context).primaryColor,
              ),
          unselectedLabelColor: AppColors.subTextColor(context),
        ),
        dividerTheme: DividerThemeData(thickness: 1, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.05), space: 0));
  }

  static ThemeData darkMode(BuildContext context, {Color? kPrimaryColor, Color? kSecondaryColor, Color? kBackgroundColor, Color? errorColor, String? fontFamily}) {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      primaryColor: kPrimaryColor,
      visualDensity: VisualDensity.comfortable,
      scaffoldBackgroundColor: const Color(0xff0F0F0F),
      shadowColor: const Color(0xFFFFFFFF),
      indicatorColor: kPrimaryColor,
      splashColor: kPrimaryColor?.withOpacity(0.2),
      hoverColor: kPrimaryColor?.withOpacity(0.1),
      splashFactory: InkRipple.splashFactory,
      canvasColor: const Color(0xFF1E1E1E),
      disabledColor: const Color(0xFFCCCCCC),
      textTheme: buildTextTheme(base: base.textTheme, myFontFamily: fontFamily, fontColor: AppColors.fontDarkMode),
      primaryTextTheme: buildTextTheme(base: base.primaryTextTheme, myFontFamily: fontFamily, fontColor: AppColors.fontDarkMode),
      colorScheme: const ColorScheme.dark().copyWith(
        error: errorColor,
        primary: kPrimaryColor,
        surface: kBackgroundColor,
        secondary: kSecondaryColor,
      ),

      // Widgets Theme
      appBarTheme: AppBarTheme(color: kPrimaryColor),
      popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF303642)),
      tooltipTheme: TooltipThemeData(
        textStyle: TextStyle(color: const IconThemeData().color),
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: kPrimaryColor ?? const Color(0xFF000000), width: 0.4),
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kPrimaryColor,
        foregroundColor: base.iconTheme.color,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        selectedIconTheme: const IconThemeData(color: Colors.white),
        unselectedIconTheme: const IconThemeData(color: Colors.white54),
        selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, height: 1.9),
        unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54, height: 1.9),
      ),
    );
  }

/* ===================> Custom TextStyle <================== */
  static TextTheme buildTextTheme({required TextTheme base, required Color fontColor, String? myFontFamily}) {
    //? If not using responsive font remove both ".sp - 1.5"
    return base.copyWith(
      //* Display
      displayLarge: TextStyle(fontSize: (57.0.sp - 1.5), letterSpacing: 0.0, fontWeight: FontWeight.w300, color: fontColor.withOpacity((base.displayLarge!.color!.opacity)), fontFamily: myFontFamily),
      displayMedium: TextStyle(fontSize: (45.0.sp - 1.5), letterSpacing: 0.0, fontWeight: FontWeight.w300, color: fontColor.withOpacity((base.displayMedium!.color!.opacity)), fontFamily: myFontFamily),
      displaySmall: TextStyle(fontSize: (36.0.sp - 1.5), letterSpacing: 0.0, fontWeight: FontWeight.w400, color: fontColor.withOpacity((base.displaySmall!.color!.opacity)), fontFamily: myFontFamily),

      //* Headline
      headlineLarge: TextStyle(fontSize: (32.0.sp - 1.5), letterSpacing: 0.0, fontWeight: FontWeight.w400, color: fontColor.withOpacity((base.headlineLarge!.color!.opacity)), fontFamily: myFontFamily),
      headlineMedium: TextStyle(fontSize: (28.0.sp - 1.5), letterSpacing: 0.0, fontWeight: FontWeight.w400, color: fontColor.withOpacity((base.headlineMedium!.color!.opacity)), fontFamily: myFontFamily),
      headlineSmall: TextStyle(fontSize: (24.0.sp - 1.5), letterSpacing: 0.0, fontWeight: FontWeight.w400, color: fontColor.withOpacity((base.headlineSmall!.color!.opacity)), fontFamily: myFontFamily),

      //* Title
      titleLarge: TextStyle(fontSize: (22.0.sp - 1.5), letterSpacing: 0.0, fontWeight: FontWeight.w500, color: fontColor.withOpacity((base.titleLarge!.color!.opacity)), fontFamily: myFontFamily),
      titleMedium: TextStyle(fontSize: (16.0.sp - 1.5), letterSpacing: 0.15, fontWeight: FontWeight.w400, color: fontColor.withOpacity((base.titleMedium!.color!.opacity)), fontFamily: myFontFamily),
      titleSmall: TextStyle(fontSize: (14.0.sp - 1.5), letterSpacing: 0.1, fontWeight: FontWeight.w500, color: fontColor.withOpacity((base.titleSmall!.color!.opacity)), fontFamily: myFontFamily),

      //* Label
      labelLarge: TextStyle(fontSize: (14.0.sp - 1.5), letterSpacing: 0.1, fontWeight: FontWeight.w400, color: fontColor.withOpacity((base.labelLarge!.color!.opacity)), fontFamily: myFontFamily),
      labelMedium: TextStyle(fontSize: (12.0.sp - 1.5), letterSpacing: 0.5, fontWeight: FontWeight.w400, color: fontColor.withOpacity((base.labelMedium!.color!.opacity)), fontFamily: myFontFamily),
      labelSmall: TextStyle(fontSize: (11.0.sp - 1.5), letterSpacing: 0.5, fontWeight: FontWeight.w400, color: fontColor.withOpacity((base.labelSmall!.color!.opacity)), fontFamily: myFontFamily),

      //* Body Text
      bodyLarge: TextStyle(fontSize: (16.0.sp - 1.5), letterSpacing: 0.15, fontWeight: FontWeight.w400, color: fontColor.withOpacity((base.bodyLarge!.color!.opacity)), fontFamily: myFontFamily),
      // This style is flutter default body textStyle (without textStyle)
      bodyMedium: TextStyle(fontSize: (14.0.sp - 1.5), letterSpacing: 0.25, fontWeight: FontWeight.w400, color: fontColor.withOpacity((base.bodyMedium!.color!.opacity)), fontFamily: myFontFamily),
      bodySmall: TextStyle(fontSize: (12.0.sp - 1.5), letterSpacing: 0.4, fontWeight: FontWeight.w400, color: fontColor.withOpacity((base.bodySmall!.color!.opacity)), fontFamily: myFontFamily),
    );
  }
}
