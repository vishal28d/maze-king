import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maze_king/repositories/pan_card/pan_card_repository.dart';

import '../../../../data/models/pan_card/pan_card_model.dart';

class PanCardDetailScreenController extends GetxController {
  RxBool isEdit = true.obs;
  RxBool isDisable = true.obs;
  RxBool isLoader = false.obs;
  RxBool isWithdraw = false.obs;

  RxBool isPanVerified = false.obs;

  TextEditingController userNameCon = TextEditingController(text: "");

  // TextEditingController stateCon = TextEditingController(text: "");
  // Rx<StateModel> selectedStateModel = StateModel().obs;
  // RxString stateError = "".obs;
  // RxBool stateHasError = false.obs;

  Rx<PanCardModel> panCardModel = PanCardModel().obs;
  TextEditingController panCardNumCon = TextEditingController(text: "");
  RxString panCardNumError = "".obs;
  RxBool panCardNumHasError = false.obs;

  bool validate() {
    /// Name Validation
    // if (isValEmpty(stateCon.text)) {
    //   stateError.value = "Please select state";
    //   stateHasError.value = true;
    // } else {
    //   stateHasError.value = false;
    // }

    /// Account Number Validation
    if (panCardNumCon.value.text.trim().isEmpty) {
      panCardNumError.value = "Please Enter Pan Card Number";
      panCardNumHasError.value = true;
    } else if (panCardNumCon.value.text.trim().length != 10) {
      panCardNumError.value = "Enter Valid Pan Card Number";
      panCardNumHasError.value = true;
    } else if (panCardNumCon.value.text.trim().contains("*")) {
      panCardNumError.value = "Enter Valid Pan Card Number";
      panCardNumHasError.value = true;
    } else {
      panCardNumHasError.value = false;
    }

    isDisable.value = /*stateHasError.isFalse &&*/ panCardNumHasError.isFalse;

    return isDisable.value;
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {}
  }

  @override
  void onReady() {
    super.onReady();
    PanCardRepository.getPanCardDetailsAPI(isLoader: isLoader);
  }
}
