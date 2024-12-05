import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repositories/auth/auth_repository.dart';

class AddUserNameController extends GetxController {
  RxBool isLoading = false.obs;

  /// user name
  TextEditingController userNameTEC = TextEditingController(text: "");
  RxString userNameError = "".obs;
  RxBool userNameHasError = false.obs;

  /// referral code
  RxBool enableReferralCodeFiled = false.obs;
  TextEditingController referralCodeTEC = TextEditingController(text: "");
  RxString referralCodeError = "".obs;
  RxBool referralCodeHasError = false.obs;

  /// get from mobile number screen
  RxString mobileNumber = ''.obs;
  RxString accessToken = ''.obs;
  // RxString countryCode = ''.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      if (Get.arguments["mobileNumber"].runtimeType == String) {
        mobileNumber.value = Get.arguments["mobileNumber"] ?? "";
      }
      if (Get.arguments["accessToken"].runtimeType == String) {
        accessToken.value = Get.arguments["accessToken"] ?? "";
      }

      // if (Get.arguments["countryCode"].runtimeType == String) {
      //   countryCode.value = Get.arguments["countryCode"] ?? "+91";
      // }
    }
  }

  /// SAVE BUTTON ACTIVITY
  void saveButtonActivity() {
    userNameError.value = "";
    referralCodeError.value = "";

    userNameHasError.value = false;
    referralCodeHasError.value = false;

    if (userNameTEC.text.trim().length < 2) {
      userNameError.value = "Please enter valid user name";
      userNameHasError.value = true;
    } else if (userNameTEC.text.trim().contains(" ")) {
      userNameError.value = "User name not contains spaces";
      userNameHasError.value = true;
    } else if (!GetUtils.isUsername(userNameTEC.value.text.trim())) {
      userNameError.value = "Please enter valid user name";
      userNameHasError.value = true;
    } else if (enableReferralCodeFiled.isTrue && referralCodeTEC.text.trim().isNotEmpty && (referralCodeTEC.text.trim().length < 10 || referralCodeTEC.text.trim().length > 10)) {
      referralCodeError.value = "Please enter valid referral code";
      referralCodeHasError.value = true;
    }

    /// TODO
    /// Add User Name API
    if (userNameHasError.isFalse && referralCodeHasError.isFalse) {
      AuthRepository.addUserNameAPI(accessToken: accessToken.value, userName: userNameTEC.text, referralCode: enableReferralCodeFiled.isTrue ? referralCodeTEC.text : null, isLoader: isLoading);
    }
  }
}
