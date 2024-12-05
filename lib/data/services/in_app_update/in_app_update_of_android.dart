import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../../exports.dart';

class AndroidInAppUpdate {
  static Future<AppUpdateResult> showUpdateBottomSheet({bool forceUpdate = false, RxBool? isLoader}) async {
    Future<AppUpdateResult> callingAppUpdate(AppUpdateResult appUpdateResult) async {
      printOkStatus("-=-=-=-=-=-> $appUpdateResult");

      switch (appUpdateResult) {
        case AppUpdateResult.success:
          if (forceUpdate == false) {
            await InAppUpdate.completeFlexibleUpdate();
          }
          return AppUpdateResult.success;

        case AppUpdateResult.userDeniedUpdate:
          return appUpdateResult;

        case AppUpdateResult.inAppUpdateFailed:
          return appUpdateResult;

        default:
          return AppUpdateResult.inAppUpdateFailed;
      }
    }

    if (forceUpdate == true) {
      return await InAppUpdate.performImmediateUpdate().then((appUpdateResult) async {
        isLoader?.value = true;

        printOkStatus("-=-=-=-=-=-&&> $appUpdateResult");

        return await callingAppUpdate(appUpdateResult);
      }).catchError((e) {
        isLoader?.value = false;
        printErrors(type: "performImmediateUpdate Function", errText: e);
        return AppUpdateResult.inAppUpdateFailed;
      });
    } else {
      return await InAppUpdate.startFlexibleUpdate().then((appUpdateResult) async {
        isLoader?.value = true;

        return await callingAppUpdate(appUpdateResult);
      }).catchError((e) {
        isLoader?.value = false;
        printErrors(type: "startFlexibleUpdate Function", errText: e);
        return AppUpdateResult.inAppUpdateFailed;
      });
    }
  }
}
