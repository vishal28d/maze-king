/*
import 'package:get/get.dart';
/// -------- Api CAll And Response Menage ------------------>>>

class SplashController extends GetxController {
    ApiResponse<[API RESPONSE MODEL]> apiDataVar = ApiResponse.loading();

  callAPI() async {
  => NOTE: If you passing data in "row" format use this one
    dynamic formData = ({
      "user_id": 1,
      "name": "hell",
    });

  => NOTE: If you passing data in "form-data" format use this one
    FormData formData = FormData.fromMap({
      "user_id": 1,
      "name": "hell",
    });

    await APIFunction().postApiCall(
      apiName: "API NAME",
      params: formData,
    => NOTE: If data is in "form-data" format then pass "true" and if data is in "row" format then pass "false" in "isFormData" parameter
      isFormData: false
    ).then((value) {
      apiDataVar = ApiResponse.completed([API RESPONSE MODEL].fromJson(value));
    });
  }
}


*/
