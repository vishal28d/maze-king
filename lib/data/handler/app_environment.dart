import 'package:flutter/foundation.dart';

import '../../exports.dart';
import '../../utils/enums/common_enums.dart';

class AppEnvironment {
  static EnvironmentType environmentType = EnvironmentType.production;

  static String getApiURL() {
    printData(key: "API environment", value: environmentType.name);

    switch (environmentType) {
      case EnvironmentType.production:
        if (kDebugMode) {
          return "https://api.gotilo.app/v1/";
        } else {
          return "https://api.gotilo.app/v1/";
        }
        

      case EnvironmentType.staging:
        if (kDebugMode) {
          return "";
        } else {
          return "";
        }

      case EnvironmentType.development:
        if (kDebugMode) {
          return "https://devapi.gotilo.app/v1/";
        } else {
          return "https://devapi.gotilo.app/v1/";
        }


      case EnvironmentType.local:
        if (kDebugMode) {
          return "http://192.168.29.221:5008/v1/";
        } else {
          return "http://192.168.29.221:5008/v1/";
        }

      case EnvironmentType.custom:
        String localUrl = !isValEmpty(LocalStorage.baseUrl.value) ? LocalStorage.baseUrl.value : "https://devapi.gotilo.app/v1/";

        if (kDebugMode) {
          return localUrl;
        } else {
          return localUrl;
        }
    }
  }
}
