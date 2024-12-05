import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:maze_king/repositories/auth/auth_repository.dart';

import '../../exports.dart';

class ApiUtils {
  static String defaultTitle = "Default Title";

  static void logoutWithoutAPI() async {
    await LocalStorage.clearLocalStorage();
    Get.offAllNamed(AppRoutes.mobileAuthScreen);
  }

  //* =-=-=-=-=-=-> After Logout API <-=-=-=-=-=-=- *//
  static Future<void> logoutAndClean({RxBool? loader}) async {
    if (Get.currentRoute != AppRoutes.mobileAuthScreen) {
      await AuthRepository.logOutAPI(loader: loader).then(
        (value) async {
          if (value) {
            Get.offAllNamed(AppRoutes.mobileAuthScreen);
            UiUtils.toast("Log Out Successfully");
            await LocalStorage.clearLocalStorage();
          } else {
            UiUtils.toast("Please try again!");
          }
        },
      );
    }
  }

  static Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.requestPermission().then(
      (_) {
        try {
          return FirebaseMessaging.instance.getToken().then(
            (token) {
              storeDeviceInformation(token);
              return token;
            },
          );
        } catch (e) {
          return null;
        }
      },
    );
  }

  static Future<Map<String, dynamic>> devicesInfo() async {
    if (LocalStorage.deviceId.isEmpty || LocalStorage.deviceType.isEmpty) {
      if (LocalStorage.deviceToken.isEmpty) {
        await getFCMToken();
      } else {
        await storeDeviceInformation(LocalStorage.deviceToken.value);
      }
    }

    return {
      "device_name": LocalStorage.deviceName.value,
      "device_id": LocalStorage.deviceId.value,
      "device_type": LocalStorage.deviceType.value,
      "device_token": LocalStorage.deviceToken.value,
    };
  }
}
