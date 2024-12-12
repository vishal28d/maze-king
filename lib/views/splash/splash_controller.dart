import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:maze_king/data/handler/app_environment.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../data/services/in_app_update/in_app_update_of_android.dart';
import '../../exports.dart';
import '../../repositories/splash/splash_repository.dart';
import '../../res/widgets/app_dialog.dart';
import '../../utils/enums/common_enums.dart';

class SplashController extends GetxController {
  RxBool isUpdating = false.obs;
  late List<VersionModel> versions;

  // Navigation function after a delay
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

  // Fetch available app versions from API
  Future<List<VersionModel>> fetchVersions() async {
    try {
      final response = await http.post(
        Uri.parse('https://devapi.gotilo.app/v1/version/create'),
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => VersionModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load versions');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching versions: $e');
      }
      return [];
    }
  }



  @override
  void onReady() async {
    super.onReady();

  PackageInfo packageInfo = await getPackageInfo();
    // Fetch versions and then check for updates
    versions = await fetchVersions();
    checkAndroidAppUpdate();
    inAppUpdateChecker(versions: versions, currentVersion: packageInfo.version );

    if (AppEnvironment.environmentType == EnvironmentType.custom) {
      AppDialogs.splashApiDialog(
        onSuccess: () async {
          await SplashRepository.getSplashDataAPI(navigation: navigation);
        },
      );
    } else {
      SplashRepository.getSplashDataAPI(navigation: navigation);
    }
  }

  /// ***********************************************************************************
  ///                             IN-APP UPDATE CHECKER
  /// ***********************************************************************************

  Future<void> inAppUpdateChecker(
      {required List<VersionModel> versions,
      required String currentVersion}) async {
    if (versions.isNotEmpty) {
      // Maintenance check
      var currentVersionModel = versions.firstWhere(
        (element) => element.version == currentVersion,
        orElse: () => VersionModel(version: currentVersion, forceUpdate: false, softUpdate: false, maintenance: true),
      );

      if (currentVersionModel.maintenance == false) {
        // App Update Module
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
          bool isForceUpdate = versionList
              .where((element) => element["isForceUpdate"] == true)
              .isNotEmpty;
          bool isSoftUpdate = versionList
              .where((element) => element["isSoftUpdate"] == true)
              .isNotEmpty;

          if (isForceUpdate) {
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
              await checkAndroidAppUpdate(forceUpdate: true, softUpdate: false);
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
              await checkAndroidAppUpdate(forceUpdate: false, softUpdate: true);
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
            printYellow("No update needed.");
            navigation();
          }
        } else {
          navigation();
        }
      } else {
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

  Future<void> checkAndroidAppUpdate(
      {bool forceUpdate = false, bool softUpdate = false}) async {
    await InAppUpdate.checkForUpdate().then((info) async {
      printData(key: "UpdateAvailability", value: info.updateAvailability);

      switch (info.updateAvailability) {
        case UpdateAvailability.developerTriggeredUpdateInProgress:
          await UiUtils.toast("Restart your app.");
          break;
        case UpdateAvailability.unknown:
          navigation();
          break;
        case UpdateAvailability.updateAvailable:
          await AndroidInAppUpdate.showUpdateBottomSheet(
                  forceUpdate: forceUpdate)
              .then(
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
                        await checkAndroidAppUpdate(
                            forceUpdate: forceUpdate, softUpdate: softUpdate);
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
        case UpdateAvailability.updateNotAvailable:
          navigation();
          break;
      }
    }).catchError((e) {
      printErrors(type: "checkForUpdate Function", errText: e);
    });
  }
}

class VersionModel {
  final String version;
  final bool forceUpdate;
  final bool softUpdate;
  final bool maintenance;

  VersionModel({
    required this.version,
    required this.forceUpdate,
    required this.softUpdate,
    required this.maintenance,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      version: json['version'] ?? '',
      forceUpdate: json['force_update'] ?? false,
      softUpdate: json['soft_update'] ?? false,
      maintenance: json['maintenance'] ?? false,
    );
  }
}
