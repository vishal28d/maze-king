import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/views/authentication/mobile_auth/mobile_auth_controller.dart';

import '../../../res/widgets/auth_background_widget.dart';
import '../../../res/widgets/webview.dart';

class MobileAuthScreen extends StatelessWidget {
  MobileAuthScreen({super.key});

  final MobileAuthController con = Get.put(MobileAuthController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Obx(() {
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
                        AppStrings.loginNow,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 24.sp, color: AppColors.authTitle),
                      ),
                    ),
                    10.verticalSpace,
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: defaultPadding * 2.w),
                        child: Text(
                          AppStrings.enterAssociatedMobileNumberSubStr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.authSubTitle),
                        ),
                      ),
                    ),
                    25.verticalSpace,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
                child: Column(
                  children: [
                    /// mobile number text-filed
                    AppTextField(
                      title: AppStrings.mobileNumber,
                      hintText: AppStrings.enterMobileNumber,
                      controller: con.mobileNumberTEC.value,
                      // fillColor: Theme.of(context).scaffoldBackgroundColor,
                      showError: con.mobileNumberHasError.value,
                      errorMessage: con.mobileNumberError.value,
                      padding: const EdgeInsets.only(bottom: defaultPadding, top: defaultPadding * 1.4),
                      // isCountrySelectable: true,
                      // selectedCountry: con.countryObject,
                      enabled: con.isLoading.isFalse,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      prefixIcon: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 1.5),
                        width: 55.w,
                        child: Text(con.countryObject.value.dialCode),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        con.mobileNumberHasError.value = false;
                      },
                    ),

                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: con.isCheckBoxChecked.value,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                            side: WidgetStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                width: 1.5,
                                color: con.checkBoxHasError.value ? Theme.of(context).colorScheme.error : Theme.of(context).primaryColor.withOpacity(0.5),
                              ),
                            ),
                            checkColor: AppColors.getColorOnBackground(Theme.of(context).primaryColor),
                            onChanged: (bool? value) {
                              if (con.isLoading.isFalse) {
                                con.isCheckBoxChecked.value = (value ?? false);
                                con.checkBoxHasError.value = false;
                              }
                            },
                          ),
                        ),
                        Text(
                          AppStrings.age18agreement,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: (con.checkBoxHasError.value ? Theme.of(context).colorScheme.error : Theme.of(context).textTheme.bodyMedium?.color)?.withOpacity(0.8),
                              ),
                        ),
                      ],
                    ),

                    Hero(
                      tag: "heroButton",
                      child: AppButton(
                        padding: EdgeInsets.only(top: 33.h, bottom: defaultPadding),
                        loader: con.isLoading.value,
                        onPressed: () {
                          /// CONTINUE
                          con.continueButtonActivity(context);
                        },
                        title: AppStrings.continueStr,
                      ),
                    ),

                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: AppStrings.byContinueIAgreeWithApp,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                            ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => AppWebView(
                                      webURL: LocalStorage.termsAndConditionURL.value,
                                      title: AppStrings.termAndConditions,
                                    ));
                              },
                            text: AppStrings.termAndConditionShortForm,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),

                    30.verticalSpace
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
