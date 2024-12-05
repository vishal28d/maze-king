import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../exports.dart';
import '../../../res/widgets/auth_background_widget.dart';
import 'add_username_controller.dart';

class AddUserNameScreen extends StatelessWidget {
  AddUserNameScreen({super.key});

  final AddUserNameController con = Get.put(AddUserNameController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
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
                        "You're all set to play!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 24.sp, color: AppColors.authTitle),
                      ),
                    ),
                    5.verticalSpace,
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Get.width * .030).copyWith(top: defaultPadding / 1.5),
                        child: Text(
                          "Start your new innings with Gotilo Maze King.\nTell us your name",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.authSubTitle),
                        ),
                      ),
                    ),
                    30.verticalSpace,
                  ],
                ),
              ),
              defaultPadding.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
                child: Column(
                  children: [
                    /// User name filed
                    AppTextField(
                      title: AppStrings.userName,
                      hintText: AppStrings.enterYourUserName,
                      controller: con.userNameTEC,
                      showError: con.userNameHasError.value,
                      errorMessage: con.userNameError.value,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      // padding: const EdgeInsets.only(top: defaultPadding),
                      onChanged: (val) {
                        con.userNameHasError.value = false;
                      },
                    ),

                    /// Referral Code
                    if (con.enableReferralCodeFiled.value) ...[
                      defaultPadding.verticalSpace,
                      AppTextField(
                        title: AppStrings.referralCode,
                        hintText: AppStrings.enterReferralCode,
                        controller: con.referralCodeTEC,
                        showError: con.referralCodeHasError.value,
                        errorMessage: con.referralCodeError.value,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        // padding: const EdgeInsets.only(top: defaultPadding),
                        onChanged: (val) {
                          con.referralCodeHasError.value = false;
                        },
                      ),
                    ],
                    defaultPadding.verticalSpace,
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          con.enableReferralCodeFiled.value = !con.enableReferralCodeFiled.value;
                        },
                        child: Text(
                          con.enableReferralCodeFiled.value ? "Don't have Referral code?" : "Referral code? Tap to enter",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.tertiary.withOpacity(0.85)),
                        ),
                      ),
                    ),

                    /// Save name button
                    AppButton(
                      padding: EdgeInsets.only(top: 33.h, bottom: defaultPadding),
                      loader: con.isLoading.value,
                      onPressed: () async {
                        con.saveButtonActivity();
                      },
                      title: "Save",
                    ),

                    10.verticalSpace
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
