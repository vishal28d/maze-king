import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/data/models/profile/user_details_model.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/repositories/profile/profile_repository.dart';

import '../../../../data/models/common/get_state_model.dart';

class MyInfoAndSettingController extends GetxController {
  Rx<UserDetailsModel> userDetails = UserDetailsModel().obs;

  RxBool isEdit = true.obs;
  RxBool isDisable = true.obs;
  RxBool loader = false.obs;
  RxBool isLoader = false.obs;

  /// Name
  Rx<TextEditingController> userNameCon = TextEditingController(text: "${LocalStorage.userName}").obs;
  RxString userNameError = "".obs;
  RxBool userNameHasError = false.obs;

  /// First name
  Rx<TextEditingController> firstNameCon = TextEditingController().obs;
  RxString firstNameError = "".obs;
  RxBool firstNameHasError = false.obs;

  /// Last name
  Rx<TextEditingController> lastNameCon = TextEditingController().obs;
  RxString lastNameError = "".obs;
  RxBool lastNameHasError = false.obs;

  RxString selectGender = "Male".obs;

  RxList<String> genders = [
    "Male",
    "Female",
    "Other",
  ].obs;

  /// Mobile Number
  Rx<TextEditingController> mobileNumCon = TextEditingController(text: "${LocalStorage.userMobile}").obs;
  RxString mobileNumError = "".obs;
  RxBool mobileNumHasError = false.obs;

  RxString genderError = "Please Enable Edit Mode".obs;
  RxBool genderHasError = false.obs;

  // Rx<TextEditingController> cityCon = TextEditingController().obs;
  // RxString cityError = "".obs;
  // RxBool cityHasError = false.obs;

  Rx<TextEditingController> addressCon = TextEditingController().obs;
  RxString addressError = "".obs;
  RxBool addressHasError = false.obs;

  TextEditingController stateCon = TextEditingController(text: "");
  Rx<StateModel> selectedStateModel = StateModel().obs;
  RxString stateError = "".obs;
  RxBool stateHasError = false.obs;

  Rx<String> image = "".obs;

  bool validate() {
    /// Name Validation
    if (userNameCon.value.text.trim().isEmpty) {
      userNameError.value = "Please Enter Name";
      userNameHasError.value = true;
    } else {
      userNameHasError.value = false;
    }

    if (firstNameCon.value.text.trim().isEmpty) {
      firstNameError.value = "Please Enter First Name";
      firstNameHasError.value = true;
    } else if (!firstNameCon.value.text.trim().isAlphabetOnly) {
      firstNameError.value = "Please Enter Valid Name";
      firstNameHasError.value = true;
    } else {
      firstNameHasError.value = false;
    }

    if (lastNameCon.value.text.trim().isEmpty) {
      lastNameError.value = "Please Enter Last Name";
      lastNameHasError.value = true;
    } else if (!lastNameCon.value.text.trim().isAlphabetOnly) {
      lastNameError.value = "Please Enter Valid Name";
      lastNameHasError.value = true;
    } else {
      lastNameHasError.value = false;
    }

    /// Mobile Number Validation
    if (mobileNumCon.value.text.trim().isEmpty) {
      mobileNumError.value = "Please Enter Mobile Number";
      mobileNumHasError.value = true;
    } else {
      mobileNumHasError.value = false;
    }

    /// Address Validation
    if (addressCon.value.text.trim().isEmpty) {
      addressError.value = "Please Enter Address";
      addressHasError.value = true;
    } else {
      addressHasError.value = false;
    }

    /// State
    if (isValEmpty(stateCon.text)) {
      stateError.value = "Please select state";
      stateHasError.value = true;
    } else {
      stateHasError.value = false;
    }

    /// City Validation
    // if (cityCon.value.text.trim().isEmpty) {
    //   cityError.value = "Please Enter City";
    //   cityHasError.value = true;
    // } else {
    //   cityHasError.value = false;
    // }
    isDisable.value = userNameHasError.isFalse && addressHasError.isFalse && stateHasError.isFalse && firstNameHasError.isFalse && lastNameHasError.isFalse;
    return isDisable.value;
  }

  @override
  void onReady() {
    super.onReady();
    ProfileRepository.getUserDetailsAPI(isLoader: loader).then((res) {
      // cityCon.value.text = userDetails.value.city ?? "";
      addressCon.value.text = userDetails.value.address ?? "";
      firstNameCon.value.text = userDetails.value.firstName ?? "";
      lastNameCon.value.text = userDetails.value.lastName ?? "";
      image.value = userDetails.value.image ?? "";
      selectGender.value = (userDetails.value.gender != null ? (userDetails.value.gender.toString().capitalizeFirst) : genders[0]) ?? genders[0];
      selectedStateModel.value = userDetails.value.state ?? StateModel();
      stateCon.text = userDetails.value.state?.name ?? "";
    });
  }
}
