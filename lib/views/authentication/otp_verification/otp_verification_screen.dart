import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/views/authentication/otp_verification/otp_verification_controller.dart';
import 'package:pinput/pinput.dart';

import '../../../exports.dart';
import '../../../packages/animated_counter/animated_counter.dart';
import '../../../res/widgets/auth_background_widget.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({super.key});

  final OtpVerificationController con = Get.put(OtpVerificationController());

  BorderRadiusGeometry? get borderRadius {
    return /*BorderRadius.circular(0)*/ null;
  }

  final Color defaultBorderColor = Theme.of(Get.context!).primaryColor.withOpacity(0.14);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const RangeMaintainingScrollPhysics(),
          children: [
            AuthSmallBackgroundWidget(
              child: Column(
                children: [
                  115.verticalSpace,
                  Center(
                    child: Text(
                      AppStrings.verification,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 24.sp, color: AppColors.authTitle),
                    ),
                  ),
                  10.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * .030).copyWith(top: defaultPadding / 1.5),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 12.sp, fontFamily: AppTheme.fontFamilyName, height: 1.5),
                        children: [
                          TextSpan(
                            text: AppStrings.weHaveSentOtpToYourMobileNumber,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.authSubTitle),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.back();
                              },
                            text: con.mobileNumber.value,
                            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.authSubTitle, fontSize: 12.sp),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 4.sp, bottom: 2),
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.authSubTitle,
                                  size: 13.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  30.verticalSpace,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
              child: Column(
                children: [
                  /// OTP PIN-PUT
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: defaultPadding * 2,
                        bottom: defaultPadding,
                      ),
                      child: Pinput(
                        length: 6,
                        controller: con.otpTEC.value,
                        focusNode: con.focusNode,
                        autofocus: true,
                        // autoFill OTP
                        androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                        //!
                        enabled: con.isLoading.isFalse,
                        defaultPinTheme: defaultPinTheme,
                        keyboardType: TextInputType.number,
                        scrollPadding: const EdgeInsets.only(bottom: defaultPadding * 5),
                        cursor: Container(
                          width: 2,
                          height: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        preFilledWidget: Text(
                          "-",
                          style: TextStyle(
                            fontSize: 22,
                            color: AppColors.unselectedIcon(context),
                          ),
                        ),

                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: borderRadius,
                            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          ),
                          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: defaultBorderColor, fontSize: 18.sp, fontWeight: FontWeight.w500),
                        ),
                        followingPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: borderRadius,
                            border: Border.all(color: defaultBorderColor),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: borderRadius,
                            border: Border.all(color: defaultBorderColor),
                          ),
                          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19.sp, fontWeight: FontWeight.w600),
                        ),
                        errorPinTheme: defaultPinTheme.copyBorderWith(
                          border: Border.all(color: Colors.redAccent),
                        ),
                        onClipboardFound: (value) {
                          if (value is int) {
                            con.otpTEC.value.setText(value);
                          }
                        },
                        onCompleted: (pin) async {
                          /// TODO
                          /// Verify OTP here
                          ///
                          con.verifyButtonActivity();
                        },
                      ),
                    ),
                  ),

                  /// Verify OTP button
                  Hero(
                    tag: "heroButton",
                    child: AppButton(
                      padding: EdgeInsets.only(top: 33.h, bottom: defaultPadding),
                      loader: con.isLoading.value,
                      onPressed: () {
                        con.verifyButtonActivity();
                      },
                      title: AppStrings.verifyOTP,
                    ),
                  ),

                  /// Resend OTP functionalities and its timer
                  con.isTimerComplete.isTrue
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppStrings.resendOtp, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7))),
                            GestureDetector(
                              onTap: () async {
                                // if (con.isResendOtp.value) {
                                /// TODO
                                /// RESEND OTP FUNCTION
                                con.resendOTP();
                                // } else {
                                //   UiUtils.toast(AppStrings.pleaseWait);
                                // }
                              },
                              child: Text(
                                AppStrings.resendText,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'Resend Code in ',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8)),
                                ),
                                WidgetSpan(
                                  child: AnimatedFlipCounter(
                                    value: con.timeLimit / 60 + con.timeLimit % 60,
                                    wholeDigits: 2,
                                    // prefix: "00:",
                                    // suffix: " Seconds",
                                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: 2),
                                  ),
                                ),
                                TextSpan(
                                  text: " Seconds",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),

                  10.verticalSpace
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  /// default pin-put theme
  PinTheme get defaultPinTheme => PinTheme(
        width: 560,
        height: 56,
        textStyle: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(color: Theme.of(Get.context!).textTheme.titleLarge?.color, fontWeight: FontWeight.w700, fontSize: 18.sp),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(50),
          shape: BoxShape.circle,
          // color: Theme.of(context).tr,
          border: Border.all(color: con.otpError.isEmpty ? defaultBorderColor : Theme.of(Get.context!).colorScheme.error, width: 1),
        ),
      );
}
