import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/repositories/profile/profile_repository.dart';
import 'package:maze_king/views/profile/widgets/info_and_setting_screen/info_and_setting_controller.dart';

import '../../../../data/models/common/get_state_model.dart';
import '../../../../packages/cached_network_image/cached_network_image.dart';
import '../../../../res/widgets/app_bar.dart';

class MyInfoAndSettingScreen extends StatelessWidget {
  MyInfoAndSettingScreen({super.key});

  final MyInfoAndSettingController con = Get.put(MyInfoAndSettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyanBg,
      body: Obx(
        () {
          return con.loader.isFalse
              ? Column(
                  children: [
                    MyAppBar(
                      showBackIcon: true,
                      title: "My Info & Settings",
                      myAppBarSize: MyAppBarSize.medium,
                      backgroundColor: Colors.transparent,
                      actions: [
                        if (con.isEdit.value)
                          appBarActionButton(
                            svgIconPath: AppAssets.editGraphicIconSVG,
                            padding: const EdgeInsets.only(right: defaultPadding / 2, bottom: defaultPadding / 5),
                            onTap: () {
                              con.isEdit.value = false;
                              con.genderHasError.value = false;
                              // con.validate();
                            },
                          ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const RangeMaintainingScrollPhysics(),
                        padding: const EdgeInsets.all(defaultPadding).copyWith(bottom: MediaQuery.of(context).size.height / 7),
                        children: [
                          SizedBox(
                            height: (Get.width / 3) + (Get.width / 10) / 2,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (con.image.value.startsWith(AppStrings.httpPrefix) || con.image.value.startsWith(AppStrings.httpsPrefix))
                                        ? AppNetworkImage(
                                            height: Get.width / 3,
                                            width: Get.width / 3,
                                            borderRadius: BorderRadius.circular(defaultRadius),
                                            imageUrl: con.userDetails.value.image ?? "",
                                          )
                                        : Container(
                                            height: Get.width / 3,
                                            width: Get.width / 3,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(defaultRadius),
                                              image: DecorationImage(
                                                image: FileImage(
                                                  File(con.image.value),
                                                ),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                                if (!con.isEdit.value)
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: GestureDetector(
                                      onTap: () => pickImages(
                                        context,
                                        croppedFileChange: (croppedImage) async {
                                          if (croppedImage != null) {
                                            con.image.value = croppedImage.path;
                                            printOkStatus(con.image.value);
                                          }
                                        },
                                      ),
                                      child: Container(
                                        height: Get.width / 10,
                                        width: Get.width / 10,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(defaultPadding / 1.8),
                                        child: SvgPicture.asset(AppAssets.editImageGraphicSVG),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          20.verticalSpace,
                          AppTextField(
                            title: "Username",
                            readOnly: true,
                            hintText: AppStrings.enterYourUserName,
                            controller: con.userNameCon.value,
                            showError: con.userNameHasError.value,
                            errorMessage: con.userNameError.value,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            fillColor: Colors.white.withOpacity(.5),
                            onChanged: (val) {
                              con.validate();
                            },
                          ),
                          AppTextField(
                            title: "Mobile Number",
                            readOnly: true,
                            controller: con.mobileNumCon.value,
                            hintText: "Enter Mobile Number",
                            showError: con.mobileNumHasError.value,
                            errorMessage: con.mobileNumError.value,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            fillColor: Colors.white.withOpacity(.5),
                            padding: const EdgeInsets.only(top: defaultPadding),
                          ),
                          AppTextField(
                            title: "First Name",
                            readOnly: con.isEdit.value,
                            controller: con.firstNameCon.value,
                            hintText: "Enter First Name",
                            showError: con.firstNameHasError.value,
                            errorMessage: con.firstNameError.value,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            padding: const EdgeInsets.only(top: defaultPadding),
                            onChanged: (val) {
                              con.validate();
                            },
                          ),
                          AppTextField(
                            title: "Last Name",
                            readOnly: con.isEdit.value,
                            controller: con.lastNameCon.value,
                            hintText: "Enter Last Name",
                            showError: con.lastNameHasError.value,
                            errorMessage: con.lastNameError.value,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            padding: const EdgeInsets.only(top: defaultPadding),
                            onChanged: (val) {
                              con.validate();
                            },
                          ),
                          FieldTitleWidget(
                            context,
                            title: "Gender",
                            titleStyle: Theme.of(context).textTheme.bodyMedium,
                            padding: const EdgeInsets.only(bottom: 0, left: defaultPadding * 1.1, top: defaultPadding),
                          ),
                          Wrap(
                            children: List.generate(
                              con.genders.length,
                              (index) {
                                return AppButton(
                                  onPressed: () {
                                    if (con.isEdit.value) {
                                      con.genderHasError.value = true;
                                    }
                                    if (!con.isEdit.value) {
                                      con.selectGender.value = con.genders[index];
                                    }
                                  },
                                  title: con.genders[index],
                                  disableButton: con.isEdit.value,
                                  titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                      ),
                                  width: 86.w,
                                  buttonType: con.selectGender.value == con.genders[index] ? ButtonType.gradient : ButtonType.outline,
                                  padding: index == 2 ? const EdgeInsets.only(right: 0, top: defaultPadding / 2) : EdgeInsets.only(right: 12.w, top: defaultPadding / 2),
                                  borderColor: Theme.of(Get.context!).primaryColor.withOpacity(0.14),
                                  backgroundColor: con.selectGender.value == con.genders[index]
                                      ? (con.isEdit.value)
                                          ? Theme.of(context).colorScheme.tertiary.withOpacity(0.5)
                                          : null
                                      : (con.isEdit.value)
                                          ? Colors.white.withOpacity(.5)
                                          : Colors.white,
                                );
                              },
                            ),
                          ),
                          FieldErrorWidget(
                            context,
                            showError: con.genderHasError.value,
                            errorStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            errorMessage: con.genderError.value,
                          ),
                          AppTextField(
                            title: "Address",
                            readOnly: con.isEdit.value,
                            hintText: "Enter Address",
                            controller: con.addressCon.value,
                            maxLines: 2,
                            showError: con.addressHasError.value,
                            errorMessage: con.addressError.value,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            padding: const EdgeInsets.only(top: defaultPadding),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(80),
                            ],
                            onChanged: (val) {
                              con.validate();
                            },
                          ),
                          // AppTextField(
                          //   title: "City",
                          //   hintText: "Enter City",
                          //   readOnly: con.isEdit.value,
                          //   controller: con.cityCon.value,
                          //   showError: con.cityHasError.value,
                          //   errorMessage: con.cityError.value,
                          //   keyboardType: TextInputType.name,
                          //   textInputAction: TextInputAction.done,
                          //   fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                          //   padding: const EdgeInsets.only(top: defaultPadding),
                          //   onChanged: (val) {
                          //     con.validate();
                          //   },
                          // ),
                          AppTextField(
                            title: "State",
                            readOnly: true,
                            hintText: "Enter your state",
                            controller: con.stateCon,
                            showError: con.stateHasError.value,
                            errorMessage: con.stateError.value,
                            keyboardType: TextInputType.name,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            textInputAction: TextInputAction.next,
                            padding: const EdgeInsets.only(top: defaultPadding),
                            onChanged: (val) {
                              // if (con.accountHolderNameCon.value.text.trim().isNotEmpty && con.accountNumCon.value.text.trim().isNotEmpty && con.ifscCon.value.text.trim().isNotEmpty) {
                              //   con.validate();
                              // }
                            },
                            onTap: () {
                              if (con.isEdit.isFalse) {
                                Get.toNamed(
                                  AppRoutes.selectStateScreen,
                                  arguments: {
                                    "selectedState": con.selectedStateModel.value,
                                  },
                                )?.then(
                                  (value) {
                                    if (!isValEmpty(value)) {
                                      if (con.selectedStateModel.value != value) {
                                        /// RESET CITY DATA
                                        con.selectedStateModel.value = StateModel();
                                        con.stateCon.clear();

                                        /// SET STATE DATA
                                        con.selectedStateModel.value = value;
                                        con.stateCon.text = con.selectedStateModel.value.name ?? "";
                                      }
                                      // con.checkButtonDisableStatus();
                                      con.validate();
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : UiUtils.appCircularProgressIndicator();
        },
      ),
      bottomSheet: Obx(
        () {
          return (!con.isEdit.value)
              ? Container(
                  padding: const EdgeInsets.all(defaultPadding).copyWith(top: 0, bottom: 0),
                  color: AppColors.cyanBg,
                  child: AppButton(
                    loader: con.isLoader.value,
                    disableButton: !con.isDisable.value,
                    padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      con.validate();
                      if (con.validate()) {
                        await ProfileRepository.updateProfileAPI(
                          isLoader: con.isLoader,
                          // city: con.cityCon.value.text.trim(),
                          stateModel: con.selectedStateModel.value,
                          firstName: con.firstNameCon.value.text.trim(),
                          lastName: con.lastNameCon.value.text.trim(),
                          image: con.image.value,
                          address: con.addressCon.value.text.trim(),
                          gender: con.selectGender.value.toLowerCase(),
                        ).then(
                          (value) {
                            con.isEdit.value = true;
                          },
                        );
                        ProfileRepository.getUserDetailsAPI(isLoader: con.isLoader);
                      }
                    },
                    title: "Update Profile",
                  ),
                )
              : const SizedBox(height: 0, width: 0);
        },
      ),
    );
  }
}
