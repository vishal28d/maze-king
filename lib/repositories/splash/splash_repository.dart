import 'package:get/get.dart';
import 'package:maze_king/views/splash/splash_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../data/models/splash/splash_model.dart';
import '../../exports.dart';

class SplashRepository {
  /*static Map<String, dynamic> dummyJson = {
    "success": true,
    "message": "Get versions",
    "data": {
      "app_config": [
        {
          "_id": "660a7ba456de28ad65c78bcc",
          "default_config": true,
          "app_config": {"primary": "#0D1442", "theme_mode": "light", "play_store_link": "https://play.google.com/store/apps/details?id=com.micrasol.pricelistmaker", "app_store_link": "https://apps.apple.com/us/app/price-list-maker/id6463614002"},
          "type": "config",
          "user": null,
          "createdAt": "2024-04-01T09:17:24.981Z",
          "updatedAt": "2024-04-01T09:17:24.981Z"
        }
      ],
      "android": [
        {
          "_id": "660a7ba456de28ad65c78bc6",
          "version": "1.0.0",
          "force_update": false,
          "soft_update": false,
          "maintenance": false,
          "type": "android",
          "createdAt": "2024-04-01T09:17:24.880Z",
          "updatedAt": "2024-04-01T09:17:24.880Z",
        },
        {
          "_id": "660a7ba456de28ad65c78bc6",
          "version": "1.0.1",
          "force_update": false,
          "soft_update": false,
          "maintenance": false,
          "type": "android",
          "createdAt": "2024-04-01T09:17:24.880Z",
          "updatedAt": "2024-04-01T09:17:24.880Z",
        },
        {
          "_id": "660a7ba456de28ad65c78bc6",
          "version": "1.0.2",
          "force_update": false,
          "soft_update": false,
          "maintenance": false,
          "type": "android",
          "createdAt": "2024-04-01T09:17:24.880Z",
          "updatedAt": "2024-04-01T09:17:24.880Z",
        },
      ]
    }
  };*/

  /// ***********************************************************************************
  ///                             GET SPLASH DATA API
  /// ***********************************************************************************

  static Future<dynamic> getSplashDataAPI({RxBool? isLoader, required Function() navigation}) async {
    ///
    final SplashController con = Get.find<SplashController>();

    try {
      isLoader?.value = true;
      PackageInfo packageInfo = await getPackageInfo();
      await APIFunction.getApiCall(
        apiName: ApiUrls.splashGET(versionCode: packageInfo.version),
        // notInternetConnectionActivity: navigation,
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            isLoader?.value = false;

            final GetSplashDataModel model = GetSplashDataModel.fromJson(response /*dummyJson*/);

            if (!isValEmpty(model.data)) {
              if (!isValEmpty(model.data!.appConfigs) && model.data!.appConfigs!.isNotEmpty && !isValEmpty(model.data!.appConfigs![0].appConfig)) {
                /// appConfig
                AppConfigDetails appConfig = model.data!.appConfigs![0].appConfig!;
                // printOkStatus("appConfig ===>");

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

              LocalStorage.storeAppConfigs(
                howToPlayVideoLinkUrl: model.data?.howToPlayVideoLink,
                userGuideVideoLinkUrl: model.data?.userGuideVideoLink,
              );

              if (!isValEmpty(model.data!.versions) /*&& model.data!.appConfigs!.isNotEmpty*/) {
                /// versions
                // printOkStatus("versions ===>");

                /// TODO
                /// CHECKING UPDATE
                con.inAppUpdateChecker(currentVersion: packageInfo.version, versions: model.data!.versions!);
              } else {
                navigation();
              }
            }
          }
          isLoader?.value = false;

          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "getSplashDataAPI", errText: e);
    }
  }
}
