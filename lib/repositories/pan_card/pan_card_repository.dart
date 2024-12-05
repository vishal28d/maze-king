import 'package:get/get.dart';

import '../../data/models/pan_card/pan_card_model.dart';
import '../../exports.dart';
import '../../views/profile/widgets/pan_card_details_screen/pan_card_detail_screen_controller.dart';

class PanCardRepository {
  /// ***********************************************************************************
  ///                              GET PAN CARD DETAILS
  /// ***********************************************************************************

  static Future<dynamic> getPanCardDetailsAPI({
    RxBool? isLoader,
    bool isWithdraw = false,
    String? type,
  }) async {
    try {
      isLoader?.value = true;

      return await APIFunction.getApiCall(apiName: ApiUrls.getPanCardDetailUrl, params: {
        if ((!isValEmpty(type))) 'type': type,
      }).then(
        (response) async {
          if (response != null) {
            if (!isWithdraw) {
              final PanCardDetailScreenController con = Get.find<PanCardDetailScreenController>();
              // log(jsonEncode(response));
              GetPanCardModel model = GetPanCardModel.fromJson(response);
              if (model.data != null) {
                con.panCardModel.value = model.data!.panInfo ?? PanCardModel();
                con.userNameCon.text = con.panCardModel.value.registeredName ?? "";
                con.panCardNumCon.text = con.panCardModel.value.pan ?? "";
                con.isPanVerified.value = con.panCardModel.value.valid ?? false;
                isLoader?.value = false;

                // con.selectedStateModel.value = model.data!.state ?? StateModel();
                // con.stateCon.text = con.selectedStateModel.value.name ?? "";
              }
            }
          }
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "getPanCardDetailsAPI", errText: e);
    }
  }

  /// ***********************************************************************************
  ///                              ADD PANCARD DETAILS
  /// ***********************************************************************************

  Future<dynamic> addPanCardDetailAPI({
    RxBool? isLoader,
    // required String name,
    required String panNum,
    Function()? onSuccess,
    // required StateModel stateModel,
  }) async {
    try {
      isLoader?.value = true;

      await APIFunction.postApiCall(
        apiName: ApiUrls.addPanCardDetailUrl,
        body: {
          "pan_number": panNum,
          // "state": stateModel.id,
        },
      ).then(
        (response) async {
          if (response != null && response['success'] == true) {
            await PanCardRepository.getPanCardDetailsAPI(isLoader: isLoader);
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
