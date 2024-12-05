import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/common/get_state_model.dart';
import '../../../exports.dart';
import '../../../repositories/common/common_repository.dart';

class SelectStateController extends GetxController {
  Rx<TextEditingController> selectStateCon = TextEditingController().obs;
  RxBool showCloseButton = false.obs;
  RxString searchKeyword = "".obs;
  Timer? searchDebounce;

  RxBool isLoading = true.obs;
  Rx<StateModel> selectedStateModel = StateModel().obs;
  RxList<StateModel> stateList = <StateModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['selectedState'].runtimeType == StateModel) {
        selectedStateModel.value = Get.arguments['selectedState'];
      }
    }
  }

  @override
  void onReady() {
    super.onReady();

    //! This is India's country ID - 64ba1d2406d7934103061c0a form [CommonRepository.getCountryList].
    CommonRepository.getStateListByCountry(isLoader: isLoading, countryId: "64ba1d2406d7934103061c0a").then(
      (returnStateList) {
        if (!isValEmpty(returnStateList)) {
          stateList.value = returnStateList ?? [];
        }
      },
    );
  }
}
