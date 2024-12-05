import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../data/api/api_utils.dart';
import '../../exports.dart';

class AuthRepository {
  /// ***********************************************************************************
  ///                                       LOGIN API
  /// ***********************************************************************************

  static Future<dynamic> loginAPI({
    required String mobileNumber,
    RxBool? loader,
  }) async {
    try {
      loader?.value = true;

      await APIFunction.postApiCall(
        apiName: ApiUrls.loginPOST,
        body: {
          "mobile": mobileNumber,
        },
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            loader?.value = false;
            UiUtils.toast(AppStrings.otpSendSuccessfully);
            Get.toNamed(
              AppRoutes.otpVerificationScreen,
              arguments: {
                "mobileNumber": mobileNumber,
              },
            );
          } else {
            if (!isValEmpty(response['message'])) UiUtils.toast(response['message']);
          }

          loader?.value = false;
          return response;
        },
      );
    } catch (e) {
      loader?.value = false;
      printErrors(type: "loginAPI", errText: "$e");
    }
  }

  /// ***********************************************************************************
  ///                                     REGISTER API
  /// ***********************************************************************************

  static Future<dynamic> registerAPI({
    required String mobileNumber,
    RxBool? loader,
  }) async {
    try {
      loader?.value = true;

      await APIFunction.postApiCall(
        apiName: ApiUrls.registerPOST,
        body: {
          "mobile": mobileNumber,
        },
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            loader?.value = false;
            UiUtils.toast(AppStrings.otpSendSuccessfully);
            Get.toNamed(
              AppRoutes.otpVerificationScreen,
              arguments: {
                "mobileNumber": mobileNumber,
              },
            );
          } else {
            if (!isValEmpty(response['message'])) UiUtils.toast(response['message']);
          }
          loader?.value = false;
          return response;
        },
      );
    } catch (e) {
      printErrors(type: "registerAPI", errText: "$e");
      loader?.value = false;
    } finally {}
  }

  /// ***********************************************************************************
  ///                                 USER EXIST CHECKER API
  /// ***********************************************************************************

  static Future<dynamic> userExitOrNotAPI({required String userMobileNumber, required String countryCode, RxBool? isLoader}) async {
    try {
      isLoader?.value = true;
      await APIFunction.getApiCall(apiName: ApiUrls.checkUserExistOrNotGET + countryCode + userMobileNumber).then(
        (response) async {
          if (response != null && response['success'] == true) {
            bool alreadyRegistered = response['data'] != null ? bool.parse((response['data']['register'] ?? false).toString()) : false;
            if (alreadyRegistered) {
              await AuthRepository.loginAPI(mobileNumber: countryCode + userMobileNumber, loader: isLoader);
            } else {
              await AuthRepository.registerAPI(mobileNumber: countryCode + userMobileNumber, loader: isLoader);
            }
          } else {
            if (!isValEmpty(response['message'])) UiUtils.toast(response['message']);
          }
          isLoader?.value = false;
          return response;
        },
      );
    } catch (e) {
      printErrors(type: "userExitOrNotAPI", errText: "$e");
    } finally {
      isLoader?.value = false;
    }
  }

  /// ***********************************************************************************
  ///                                   RESEND OTP API
  /// ***********************************************************************************

  static Future<dynamic> resendOtpToMobileNumAPI({required String userMobileNumber, RxBool? isLoader}) async {
    try {
      isLoader?.value = true;
      await APIFunction.postApiCall(
        apiName: ApiUrls.sendOtpByMobilePOST,
        body: {
          "mobile": userMobileNumber,
        },
      ).then(
        (response) async {
          if (!isValEmpty(response['message'])) UiUtils.toast(response['message']);
          if (response != null && response['success'] == true) {}
          isLoader?.value = false;
          return response;
        },
      );
    } catch (e) {
      printErrors(type: "resendOtpToMobileNumAPI", errText: "$e");
    } finally {
      isLoader?.value = false;
    }
  }

  /// ***********************************************************************************
  ///                                   VERIFY OTP API
  /// ***********************************************************************************

  static Future<dynamic> verifyMobileOtpAPI({required String userMobileNumber, required String otp, RxBool? isLoader}) async {
    try {
      isLoader?.value = true;
      await ApiUtils.devicesInfo();
      PackageInfo packageInfo = await getPackageInfo();
      await APIFunction.postApiCall(
        apiName: ApiUrls.verifyMobileOtpPOST,
        body: {
          "mobile": userMobileNumber,
          "otp": otp,
          "device_info": await ApiUtils.devicesInfo(),
          "version": packageInfo.version,
        },
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            UiUtils.toast(AppStrings.otpVerificationSuccessfully);

            if (response['data'] != null && response['data']['data'] != null) {
              Map userData = response['data']['data'];

              bool isAlreadyExists = (userData['is_username'] ?? false);
              if (isAlreadyExists) {
                /// LOGIN ACTIVITY
                LocalStorage.storeUserDetails(
                  userID: userData['_id'] ?? "",
                  mobile: userData['mobile'] ?? "",
                  userNAME: userData['user_name'] ?? "",
                  referralCODE: userData['referral_code'] ?? "",
                  userIMAGE: userData['image'] ?? "",
                  accessTOKEN: response['data']['token'] ?? "",
                  myBALANCE: userData['my_balance'] ?? "",
                );

                Get.offAllNamed(AppRoutes.bottomNavBarScreen);
              } else {
                /// REGISTER REQUIRED

                /// Navigate to add user_name and referral code screen
                Get.toNamed(AppRoutes.addUserNameScreen, arguments: {
                  "mobileNumber": userMobileNumber,
                  "accessToken": response['data']['token'] ?? "",
                });
              }
            }
          } else {
            if (!isValEmpty(response['message'])) UiUtils.toast(response['message']);
          }

          isLoader?.value = false;
          return response;
        },
      );
    } catch (e) {
      printErrors(type: "verifyMobileOtpAPI", errText: "$e");
    } finally {
      isLoader?.value = false;
    }
  }

  /// ***********************************************************************************
  ///                                   ADD USER NAME API
  /// ***********************************************************************************

  static Future<dynamic> addUserNameAPI({required String accessToken, required String userName, String? referralCode, RxBool? isLoader}) async {
    try {
      isLoader?.value = true;
      await ApiUtils.devicesInfo();
      PackageInfo packageInfo = await getPackageInfo();
      await APIFunction.postApiCall(
        apiName: ApiUrls.addUserNameInAuthPOST,
        accessToken: accessToken,
        body: {
          "user_name": userName,
          if (!isValEmpty(referralCode)) "referralCode": referralCode,
          "device_info": await ApiUtils.devicesInfo(),
          // "version": packageInfo.version,
        },
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            if (!isValEmpty(response['message'])) UiUtils.toast(response['message']);

            if (response['data'] != null) {
              Map userData = response['data'];

              /// REGISTER DONE
              LocalStorage.storeUserDetails(
                userID: userData['_id'] ?? "",
                mobile: userData['mobile'] ?? "",
                userNAME: userData['user_name'] ?? "",
                referralCODE: userData['referral_code'] ?? "",
                userIMAGE: userData['image'] ?? "",
                accessTOKEN: accessToken,
                myBALANCE: userData['my_balance'] ?? "",
              );

              Get.offAllNamed(AppRoutes.bottomNavBarScreen);
            }
          } else {
            if (!isValEmpty(response['message'])) UiUtils.toast(response['message']);
          }
          isLoader?.value = false;
          return response;
        },
      );
    } catch (e) {
      printErrors(type: "addUserNameAPI", errText: "$e");
    } finally {
      isLoader?.value = false;
    }
  }

  /// ***********************************************************************************
  ///                                   LOG-OUT API
  /// ***********************************************************************************

  static Future<bool> logOutAPI({
    RxBool? loader,
  }) async {
    try {
      loader?.value = true;

      return await APIFunction.postApiCall(
        apiName: ApiUrls.logOutPOST,
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            loader?.value = false;
            return true;
          }
          return false;
        },
      );
    } catch (e) {
      printErrors(type: "logOutAPI", errText: "$e");
      loader?.value = false;
      return false;
    } finally {}
  }

  /// ***********************************************************************************
  ///                                 DELETE ACCOUNT API
  /// ***********************************************************************************

  static Future<bool> deleteAccountAPI({
    RxBool? loader,
    Function()? onSuccess,
  }) async {
    try {
      loader?.value = true;

      return await APIFunction.deleteApiCall(
        apiName: ApiUrls.deleteAccountDELETE,
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            loader?.value = false;

            /// onSuccess
            if (onSuccess != null) onSuccess();
            return true;
          }
          loader?.value = false;
          return false;
        },
      );
    } catch (e) {
      printErrors(type: "deleteAccountAPI", errText: "$e");
      loader?.value = false;
      return false;
    } finally {}
  }
}
