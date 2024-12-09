import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:maze_king/views/splash/splash_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../data/models/splash/splash_model.dart';
import '../../exports.dart';

class SplashRepository {
  /// ***********************************************************************************
  ///                             GET SPLASH DATA API
  /// ***********************************************************************************
  /// 
  /// 

  static Future<dynamic> getSplashDataAPI({RxBool? isLoader, required Function() navigation}) async {
    final SplashController con = Get.find<SplashController>();

    try {
      // Show loader while fetching data
      isLoader?.value = true;
      PackageInfo packageInfo = await getPackageInfo();

      final response = await APIFunction.getApiCall(
        apiName: ApiUrls.splashGET(versionCode: packageInfo.version),
      );

      if (response != null && response['success'] == true) {
        isLoader?.value = false;

        final GetSplashDataModel model = GetSplashDataModel.fromJson(response);

        if (model.data != null && model.data!.appConfigs != null && model.data!.appConfigs!.isNotEmpty) {
          final appConfig = model.data!.appConfigs![0].appConfig;

          if (appConfig != null) {
            // Store app configurations locally
            LocalStorage.storeAppConfigs(
              terms: appConfig.terms,
              privacy: appConfig.privacy,
              aboutUs: appConfig.aboutUs,
              contactUs: appConfig.contactUs,
              communityGuidelines: appConfig.communityGuidelines,
              howToPlay: appConfig.howToPlay,
              responsiblePlay: appConfig.responsiblePlay,
              legality: appConfig.legality,
              pointsSystem: appConfig.pointsSystem,
            );
          }
        }

        // Store video links
        LocalStorage.storeAppConfigs(
          howToPlayVideoLinkUrl: model.data?.howToPlayVideoLink,
          userGuideVideoLinkUrl: model.data?.userGuideVideoLink,
        );

        // Check for app updates
        if (model.data?.versions != null) {
          // con.inAppUpdateChecker(currentVersion: packageInfo.version, versions:   );
        } else {
          // Navigate to the next screen if versions data is not available
          navigation();
        }
      } else {
        // Handle failure case if response is not successful
        if (kDebugMode) {
          print("Failed to fetch splash data: ${response?['message']}");
        }
      }

      return response;
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "getSplashDataAPI", errText: e);
    } finally {
      isLoader?.value = false;
    }
  }
}
