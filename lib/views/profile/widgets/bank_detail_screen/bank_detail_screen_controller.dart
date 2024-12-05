import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maze_king/data/models/bank/get_bank_detail_model.dart';
import 'package:maze_king/repositories/bank/bank_repository.dart';

class BankDetailScreenController extends GetxController {
  RxBool isEdit = true.obs;
  RxBool isDisable = true.obs;
  RxBool isLoader = false.obs;
  RxBool isWithdraw = false.obs;

  Rx<BankModel> bankModel = BankModel().obs;

  TextEditingController accountHolderNameCon = TextEditingController(text: "");
  RxString accountHolderNameError = "".obs;
  RxBool accountHolderNameHasError = false.obs;
  RxInt accountNumberMin = 0.obs;
  RxInt accountNumberMax = 14.obs;

  TextEditingController accountNumCon = TextEditingController(text: "");
  RxString accountNumError = "".obs;
  RxBool accountNumHasError = false.obs;

  TextEditingController confirmAccountNumCon = TextEditingController(text: "");
  RxString confirmAccountNumError = "".obs;
  RxBool confirmAccountNumHasError = false.obs;

  TextEditingController ifscCon = TextEditingController(text: "");
  RxString ifscError = "".obs;
  RxBool ifscHasError = false.obs;

  TextEditingController bankNameCon = TextEditingController(text: "");
  RxString bankNameError = "".obs;
  RxBool bankNameHasError = false.obs;

  TextEditingController branchNameCon = TextEditingController(text: "");
  RxString branchNameError = "".obs;
  RxBool branchNameHasError = false.obs;

  TextEditingController bankAddressCon = TextEditingController(text: "");
  RxString bankAddressError = "".obs;
  RxBool bankAddressHasError = false.obs;

  bool validate() {
    /// Name Validation
    if (accountHolderNameCon.value.text.trim().length <= 2) {
      accountHolderNameError.value = "Please Enter Valid Name";
      accountHolderNameHasError.value = true;
    } else {
      accountHolderNameHasError.value = false;
    }

    /// Account Number Validation
    if (accountNumCon.value.text.trim().isEmpty) {
      accountNumError.value = "Please Enter Account Number";
      accountNumHasError.value = true;
    } else if (accountNumCon.value.text.trim().length < accountNumberMin.value) {
      accountNumError.value = "Enter Valid Account Number";
      accountNumHasError.value = true;
    } else if (accountNumCon.value.text.trim().contains("*")) {
      accountNumError.value = "Enter Valid Account Number";
      accountNumHasError.value = true;
    } else {
      accountNumHasError.value = false;
    }

    if (confirmAccountNumCon.value.text.trim().isEmpty) {
      confirmAccountNumError.value = "Please Enter Confirm Account Number";
      confirmAccountNumHasError.value = true;
    }
    /*else if (confirmAccountNumCon.value.text.trim().length < 11) {
      confirmAccountNumError.value = "Enter Valid Account Number";
      confirmAccountNumHasError.value = true;
    } */
    else if (accountNumCon.value.text.trim().toLowerCase() != confirmAccountNumCon.value.text.trim().toLowerCase()) {
      confirmAccountNumError.value = "Account numbers do not match";
      confirmAccountNumHasError.value = true;
    } else {
      confirmAccountNumHasError.value = false;
    }

    /// IFSC Code Validation
    if (ifscCon.value.text.trim().isEmpty) {
      ifscError.value = "Please Enter IFSC Code";
      ifscHasError.value = true;
    } else if (!(ifscCon.value.text.trim().length == 11)) {
      ifscError.value = "The IFSC Must be 11 Characters";
      ifscHasError.value = true;
    } else {
      ifscHasError.value = false;
    }

    /// Bank Name Validation
    if (bankNameCon.value.text.trim().isEmpty) {
      bankNameError.value = "Please Enter Bank Name";
      bankNameHasError.value = true;
    } else {
      bankNameHasError.value = false;
    }

    /// Branch Name Validation
    if (branchNameCon.value.text.trim().isEmpty) {
      branchNameError.value = "Please Enter Branch Name";
      branchNameHasError.value = true;
    } else {
      branchNameHasError.value = false;
    }

    /// Bank Address Validation
    if (bankAddressCon.value.text.trim().isEmpty) {
      bankAddressError.value = "Please Enter Bank Address";
      bankAddressHasError.value = true;
    } else {
      bankAddressHasError.value = false;
    }

    isDisable.value = accountHolderNameHasError.isFalse && confirmAccountNumHasError.isFalse && accountNumHasError.isFalse && ifscHasError.isFalse && bankNameHasError.isFalse && branchNameHasError.isFalse && bankAddressHasError.isFalse;

    return isDisable.value;
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['isWithdraw'].runtimeType == bool) {
        isWithdraw.value = Get.arguments['isWithdraw'];
        isEdit.value = !Get.arguments['isWithdraw'];
        isDisable.value = !Get.arguments['isWithdraw'];
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    BankRepository.getBankDetailsAPI(isLoader: isLoader).then(
      (value) {
        accountHolderNameCon.text = bankModel.value.name ?? "";
        accountNumCon.text = bankModel.value.accountNumber ?? "";
        ifscCon.text = bankModel.value.ifsc ?? "";
      },
    );
  }
}
