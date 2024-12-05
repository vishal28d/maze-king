import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:maze_king/data/handler/app_environment.dart';

import '../../data/models/splash/splash_model.dart';
import '../../data/services/in_app_update/in_app_update_of_android.dart';
import '../../exports.dart';
import '../../repositories/splash/splash_repository.dart';
import '../../res/widgets/app_dialog.dart';
import '../../utils/enums/common_enums.dart';

class SplashController extends GetxController {
  RxBool isUpdating = false.obs;

  navigation() async {
    await Future.delayed(
      const Duration(seconds: kDebugMode ? 0 : 0),
      () {
        if (LocalStorage.accessToken.value.trim().isEmpty) {
          Get.offAllNamed(AppRoutes.onBoardingScreen);
        } else {
          Get.offAllNamed(AppRoutes.bottomNavBarScreen);
        }
      },
    );
  }

  @override
  void onReady() {
    if (AppEnvironment.environmentType == EnvironmentType.custom) {
      AppDialogs.splashApiDialog(
        onSuccess: () async {
          await SplashRepository.getSplashDataAPI(navigation: navigation);
        },
      );
    } else {
      SplashRepository.getSplashDataAPI(navigation: navigation);
    }
    super.onReady();
  }

  /// ***********************************************************************************
  ///                             IN-APP UPDATE CHECKER
  /// ***********************************************************************************

  Future<void> inAppUpdateChecker({required List<VersionModel> versions, required String currentVersion}) async {
    // printOkStatus("${versions.length}");
    if (versions.isNotEmpty) {
      //*
      //* Maintenance Module
      if ((versions.firstWhereOrNull((element) => element.version == currentVersion)?.maintenance ?? false) == false) {
        //*
        //* App Update Module
        List<Map<String, Object>>? versionList = versions
            .map(
              (e) => {
                "versionComparison": currentVersion.compareTo(e.version ?? ""),
                "versionCode": e.version ?? "",
                "isForceUpdate": e.forceUpdate ?? false,
                "isSoftUpdate": e.softUpdate ?? false,
              },
            )
            .toList()
            .where((element) => element['versionComparison'] == -1)
            .toList();

        if (versionList.isNotEmpty) {
          //* Force Update
          bool isForceUpdate = versionList.where((element) => element["isForceUpdate"] == true).toList().isNotEmpty;
          printData(key: "Force Update length", value: versionList.where((element) => element["isForceUpdate"] == true).toList().length);

          //* Soft Update
          bool isSoftUpdate = versionList.where((element) => element["isSoftUpdate"] == true).toList().isNotEmpty;
          printData(key: "Soft Update length", value: versionList.where((element) => element["isSoftUpdate"] == true).toList().length);

          if (isForceUpdate) {
            //*
            //* Force Update

            printYellow("Force Update Available");

            if (Platform.isIOS) {
              AppDialogs.cupertinoAppUpdateDialog(
                Get.context!,
                isLoader: isUpdating,
                isForceUpdate: true,
                onUpdate: () async {
                  launchUrlFunction(Uri.parse(AppStrings.appStoreLink));
                },
              );
            } else if (Platform.isAndroid) {
              // await checkAndroidAppUpdate(forceUpdate: true, softUpdate: false);
              AppDialogs.materialAppUpdateDialog(
                Get.context!,
                isLoader: isUpdating,
                isForceUpdate: true,
                onUpdate: () async {
                  launchUrlFunction(Uri.parse(AppStrings.playStoreLink));
                },
                onLater: () {},
              );
            } else {
              throw platformUnsupportedError;
            }
          } else if (isSoftUpdate) {
            //*
            //* Soft Update

            printYellow("Soft Update Available");

            if (Platform.isIOS) {
              AppDialogs.cupertinoAppUpdateDialog(
                Get.context!,
                isLoader: isUpdating,
                isForceUpdate: false,
                onLater: () => navigation(),
                onUpdate: () async {
                  launchUrlFunction(Uri.parse(AppStrings.appStoreLink));
                },
              );
            } else if (Platform.isAndroid) {
              // await checkAndroidAppUpdate(forceUpdate: false, softUpdate: true);
              AppDialogs.materialAppUpdateDialog(
                Get.context!,
                isLoader: isUpdating,
                isForceUpdate: false,
                onLater: () => navigation(),
                onUpdate: () async {
                  launchUrlFunction(Uri.parse(AppStrings.playStoreLink));
                },
              );
            } else {
              throw platformUnsupportedError;
            }
          } else {
            printYellow("Custom Force Or Soft Update Variable Both Are false.");
            navigation();
          }
        } else {
          navigation();
        }
      } else {
        //* Under Maintenance.
        printWarning("App is under Maintenance");

        Get.offAllNamed(AppRoutes.underMaintenanceScreen);
      }
    } else {
      navigation();
    }
  }

  /// ***********************************************************************************
  ///                             ANDROID APP UPDATE CHECKER (NATIVE SHEETS)
  /// ***********************************************************************************

  Future<void> checkAndroidAppUpdate({bool forceUpdate = false, bool softUpdate = false}) async {
    await InAppUpdate.checkForUpdate().then((info) async {
      printData(key: "UpdateAvailability", value: info.updateAvailability);

      switch (info.updateAvailability) {
        //* Developer Triggered Update In Progress.
        case UpdateAvailability.developerTriggeredUpdateInProgress:
          await UiUtils.toast("Restart your app.");
          break;

        //* Update Availability Unknown.
        case UpdateAvailability.unknown:
          navigation();
          break;

        //* Update Available.
        case UpdateAvailability.updateAvailable:
          await AndroidInAppUpdate.showUpdateBottomSheet(forceUpdate: forceUpdate).then(
            (appUpdateResult) async {
              printWhite("appUpdateResult $appUpdateResult");
              switch (appUpdateResult) {
                case AppUpdateResult.success:
                  printOkStatus("...Success...");

                  break;

                case AppUpdateResult.userDeniedUpdate:
                  printTitle("User Denied Update");

                  if (forceUpdate == true) {
                    AppDialogs.materialAppUpdateDialog(
                      Get.context!,
                      isLoader: isUpdating,
                      isForceUpdate: true,
                      onLater: () => navigation(),
                      onUpdate: () async {
                        Get.back();
                        await checkAndroidAppUpdate(forceUpdate: forceUpdate, softUpdate: softUpdate);
                      },
                    );
                  } else {
                    navigation();
                  }

                  break;

                case AppUpdateResult.inAppUpdateFailed:
                  printTitle("In App Update Failed");

                  break;
              }
            },
          );
          break;

        //* Update Not Available.
        case UpdateAvailability.updateNotAvailable:
          navigation();
          break;
      }
    }).catchError((e) {
      printErrors(type: "checkForUpdate Function", errText: e);
    });
  }
}
