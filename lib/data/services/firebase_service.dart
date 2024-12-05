import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../../exports.dart';

class FirebaseService extends GetxController {
  RxString deviceToken = "".obs;


  @override
  void onReady() {
    // initToken();
    super.onReady();
  }

  Future<String?> initToken() async {
    if (await getConnectivityResult()) {
      FirebaseMessaging.instance.requestPermission();
      await FirebaseMessaging.instance.getToken().then(
        (token) {
          if (!isValEmpty(token)) {
            deviceToken = RxString(token!);
            storeDeviceDetails();
          }
          printData(key: "device_token", value: deviceToken);
        },
      );
      return deviceToken.value;
    }
    return null;
  }

  Future<void> storeDeviceDetails() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = (await deviceInfoPlugin.androidInfo);
      await LocalStorage.storeDeviceInfo(
        deviceID: androidDeviceInfo.id,
        deviceTOKEN: deviceToken.value,
        deviceTYPE: AppStrings.androidSlag,
        deviceNAME: androidDeviceInfo.model,
      );
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = (await deviceInfoPlugin.iosInfo);
      await LocalStorage.storeDeviceInfo(
        deviceID: iosDeviceInfo.identifierForVendor ?? "",
        deviceTOKEN: deviceToken.value,
        deviceTYPE: AppStrings.iOSSlag,
        deviceNAME: iosDeviceInfo.model,
      );
    }
  }
}
