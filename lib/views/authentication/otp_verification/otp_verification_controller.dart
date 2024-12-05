import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/firebase_service.dart';
import '../../../exports.dart';
import '../../../repositories/auth/auth_repository.dart';

class OtpVerificationController extends GetxController {
  final FirebaseService firebaseCon = Get.find<FirebaseService>();
  RxBool isLoading = false.obs;

  /// OTP number text-filed
  Rx<TextEditingController> otpTEC = TextEditingController().obs;
  RxBool otpHasError = false.obs;
  RxString otpError = ''.obs;
  final FocusNode focusNode = FocusNode();

  /// Resend OTP timer
  RxBool isTimerComplete = false.obs;
  RxBool isResendOtp = true.obs;
  RxInt timeLimit = kDebugMode ? 60.obs : 60.obs;
  late Timer timer;

  Future startTimer() async {
    void timerTick() {
      if (timeLimit.value > 0) {
        timeLimit.value--;
      } else if (timeLimit.value == 0) {
        isTimerComplete.value = true;
        timeLimit.value = 0;
        timer.cancel();
      }
    }

    isResendOtp.value = false;
    isTimerComplete.value = false;

    timeLimit = kDebugMode ? 60.obs : 60.obs;
    timerTick();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        timerTick();
      },
    );
  }

  /// get from mobile number screen
  RxString mobileNumber = ''.obs;
  // RxString countryCode = ''.obs;
  // RxString verificationID = "".obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      if (Get.arguments["mobileNumber"].runtimeType == String) {
        mobileNumber.value = Get.arguments["mobileNumber"] ?? "xxxxx";
      }
      // if (Get.arguments["verificationID"] != null) {
      //   verificationID.value = Get.arguments["verificationID"] ?? "";
      // }
      // if (Get.arguments["countryCode"].runtimeType == String) {
      //   countryCode.value = Get.arguments["countryCode"] ?? "+91";
      // }
    }

    /// start timer
    startTimer();
  }

  bool otpValidation() {
    FocusScope.of(Get.context!).unfocus();
    otpHasError.value = false;
    otpError.value = "";

    if (otpTEC.value.text.trim().isEmpty) {
      otpError.value = "Please enter OTP";
      UiUtils.toast(otpError.value);
      otpHasError.value = true;
    } else if (otpTEC.value.text.length < 6) {
      otpError.value = "Please enter 6 digit OTP";
      UiUtils.toast(otpError.value);
      otpHasError.value = true;
    } else {
      otpHasError.value = false;
    }
    return otpHasError.isFalse;
  }

  void verifyButtonActivity() {
    bool isValid = otpValidation();
    if (isValid) {
      /* /// verify OTP by firebase event
      firebaseCon.verifyOTP(
        verificationID: verificationID.value,
        isLoader: isLoading,
        otp: otpTEC.value.text,
        onSuccess: () {
          UiUtils.toast(AppStrings.otpVerificationSuccessfully);

          printOkStatus("************ VERIFICATION SUCCESS ************");

          /// CHECK USER-EXIST-OR-NOT API
          AuthRepository().userExitOrNotAPI(userMobileNumber: mobileNumber.value, countryCode: countryCode.value, isLoader: isLoading);
        },
        onError: () {
          UiUtils.toast(AppStrings.invalidOTP);
          printError(info: "************* VERIFICATION FAIL **************");
        },
      );*/

      AuthRepository.verifyMobileOtpAPI(userMobileNumber: mobileNumber.value, isLoader: isLoading, otp: otpTEC.value.text.trim());
    }
  }

  void resendOTP() {
    startTimer();

    /*firebaseCon.sentOTP(
      mobileNumber: mobileNumber.value,
      // isLoader: isLoading,
      verificationID: verificationID,
      onVerificationCompleted: () {},
      onCodeSent: () {},
    );*/

    AuthRepository.resendOtpToMobileNumAPI(userMobileNumber: mobileNumber.value, isLoader: isLoading);
  }
}
