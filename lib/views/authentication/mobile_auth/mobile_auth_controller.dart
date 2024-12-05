import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/data/services/firebase_service.dart';
import 'package:maze_king/utils/country_list.dart';

import '../../../exports.dart';
import '../../../repositories/auth/auth_repository.dart';

class MobileAuthController extends GetxController {
  final FirebaseService firebaseCon = Get.find<FirebaseService>();

  /// mobile number text-filed
  Rx<TextEditingController> mobileNumberTEC = TextEditingController(text: kDebugMode ? "7777990666" : "").obs;
  RxString verificationID = "".obs;
  RxBool mobileNumberHasError = false.obs;
  RxString mobileNumberError = ''.obs;
  RxBool isLoading = false.obs;

  /// country
  Rx<Country> countryObject = const Country(
    name: "India",
    flag: "🇮🇳",
    code: "IN",
    dialCode: "+91",
    minLength: 10,
    maxLength: 10,
  ).obs;

  /// check box
  RxBool isCheckBoxChecked = false.obs;
  RxBool checkBoxHasError = false.obs;
  RxString checkBoxError = ''.obs;

  /// ON-TAP of continue button
  void continueButtonActivity(BuildContext context) {
    FocusScope.of(context).unfocus();

    /// mobile number validations

    if (mobileNumberTEC.value.text.trim().isEmpty) {
      mobileNumberHasError.value = true;
      mobileNumberError.value = "Please enter mobile number";
    } else if (mobileNumberTEC.value.text.trim().length < 10) {
      mobileNumberHasError.value = true;
      mobileNumberError.value = "Mobile number must be 10 digits long";
    } else {
      mobileNumberHasError.value = false;
      mobileNumberError.value = "";
    }

    if (isCheckBoxChecked.isFalse) {
      checkBoxError.value = "Please tick the age restriction";
      checkBoxHasError.value = true;
      UiUtils.toast("Please tick the age restriction");
    } else {
      checkBoxHasError.value = false;
      checkBoxError.value = "";
    }

    /// success
    if (mobileNumberHasError.isFalse && isCheckBoxChecked.value) {
      /*firebaseCon.sentOTP(
        mobileNumber: mobileNumberTEC.value.text,
        isLoader: isLoading,
        verificationID: verificationID,
        onVerificationCompleted: () {},
        onCodeSent: () {
          Get.toNamed(
            AppRoutes.otpVerificationScreen,
            arguments: {
              "mobileNumber": mobileNumberTEC.value.text,
              "verificationID": verificationID.value,
              "countryCode": countryObject.value.dialCode,
            },
          );
        },
      );*/
      sendOtpToMobileNumber();
    }
  }

  Future<void> sendOtpToMobileNumber() async {
    await AuthRepository.userExitOrNotAPI(userMobileNumber: mobileNumberTEC.value.text, countryCode: countryObject.value.dialCode, isLoader: isLoading);
  }
}
