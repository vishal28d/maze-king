import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maze_king/exports.dart';

class UiUtils {
  static bool _isShowingToast = false;

  static Future toast(message, {Toast? toastLength}) async {
    printOkStatus("$message");

    Future showToast() {
      FToast fToast = FToast();
      fToast.removeQueuedCustomToasts();
      fToast.removeCustomToast();
      return Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength ?? Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      );
    }

    if (!_isShowingToast) {
      _isShowingToast = true;
      showToast().then((_) async {
        await Future.delayed(const Duration(seconds: 1));
        _isShowingToast = false;
      });
    }
  }

  static SystemUiOverlayStyle systemUiOverlayStyle({
    bool? isReverse,
    Color? statusBarColor,
    Brightness? statusBarIconBrightness,
    Brightness? statusBarBrightness,
    Color? systemNavigationBarColor,
  }) {
    isReverse = (isReverse ?? Get.isDarkMode);
    return SystemUiOverlayStyle(
      statusBarColor: statusBarColor ?? Colors.transparent, // <-- SEE HERE
      statusBarIconBrightness: statusBarIconBrightness ?? (isReverse == true ? Brightness.light : Brightness.dark), //<-- For Android SEE HERE (dark icons)
      statusBarBrightness: statusBarBrightness ?? (isReverse == true ? Brightness.dark : Brightness.light), //<-- For iOS SEE HERE (dark icons)
      systemNavigationBarColor: systemNavigationBarColor,
    );
  }

  static Widget fadeSwitcherWidget({required Widget child}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
          child: child,
        );
      },
      //? Anytime child key passing deferent.
      child: child,
    );
  }

  static Widget rupeeWidget() => SizedBox(
        // This width and [AppTextField] hight same
        width: 57,
        child: Center(
          child: Text(
            AppStrings.rupeeSymbol,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
          ),
        ),
      );

  static String monthlyEMI(String value, {int? decimalDigits, String? symbol}) {
    if (!isValEmpty(value)) {
      NumberFormat format = NumberFormat.currency(
        decimalDigits: decimalDigits ?? 0,
        symbol: symbol ?? "",
        locale: "en_IN",
      );
      return format.format(double.parse(value));
    } else {
      return "0.0";
    }
  }

  static AppButton resetButton(BuildContext context, {required VoidCallback onPressed}) {
    return AppButton(
      backgroundColor: Theme.of(context).colorScheme.error.withOpacity(.3),
      padding: const EdgeInsets.all(defaultPadding).copyWith(bottom: MediaQuery.of(context).padding.bottom + defaultPadding, left: defaultPadding / 2),
      onPressed: onPressed,
      child: Text(
        "Reset",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 14.sp),
      ),
    );
  }

  static Widget appCircularProgressIndicator({Color? color, EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularLoader(
            color: color,
          ),
        ],
      ),
    );
  }
}
