import 'package:get/get.dart';
import 'package:maze_king/data/models/bank/get_bank_detail_model.dart';
import 'package:maze_king/views/profile/widgets/bank_detail_screen/bank_detail_screen_controller.dart';

import '../../exports.dart';

class BankRepository {
  /// ***********************************************************************************
  ///                              GET BANK DETAILS
  /// ***********************************************************************************

  static Future<dynamic> getBankDetailsAPI({
    RxBool? isLoader,
    bool isWithdraw = false,
    String? type,
  }) async {
    try {
      isLoader?.value = true;

      return await APIFunction.getApiCall(apiName: ApiUrls.getBankDetailUrl, params: {
        if ((!isValEmpty(type))) 'type': type,
      }).then(
        (response) async {
          if (response != null && response['success'] == true) {
            if (!isWithdraw) {
              final BankDetailScreenController con = Get.find<BankDetailScreenController>();
              BankModel bankModel = BankModel.fromJson(response['data']);
              con.bankModel.value = bankModel;
              con.accountHolderNameCon.text = con.bankModel.value.name ?? "";
              con.accountNumCon.text = con.bankModel.value.accountNumber ?? "";
              con.confirmAccountNumCon.text = con.bankModel.value.accountNumber ?? "";
              con.ifscCon.text = con.bankModel.value.ifsc ?? "";
              con.bankNameCon.text = con.bankModel.value.bankName ?? "";
              con.branchNameCon.text = con.bankModel.value.branchName ?? "";
              con.bankAddressCon.text = con.bankModel.value.bankAddress ?? "";
              con.accountNumberMin.value = con.bankModel.value.accountNumberMin ?? 0;
              con.accountNumberMax.value = con.bankModel.value.accountNumberMax ?? 14;
              isLoader?.value = false;
            }
          }
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "getBankDetailAPI", errText: e);
    }
  }

  /// ***********************************************************************************
  ///                              ADD BANK DETAILS
  /// ***********************************************************************************

  Future<dynamic> addBankDetailAPI({
    RxBool? isLoader,
    required String name,
    required String accountNum,
    required String ifsc,
    required String bankName,
    required String branchName,
    required String bankAddress,
    Function()? onSuccess,
  }) async {
    try {
      isLoader?.value = true;

      await APIFunction.postApiCall(
        apiName: ApiUrls.addBankDetailUrl,
        body: {"recipient_name": name, "ifsc": ifsc, "bank_name": bankName, "branch_name": branchName, "bank_address": bankAddress, "account_number": accountNum},
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            isLoader?.value = false;
            if (onSuccess != null) onSuccess();
            UiUtils.toast("Update Successfully");
          }
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: this, errText: "$e");
    }
  }
}
