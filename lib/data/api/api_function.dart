
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../exports.dart';
import 'api_class.dart';

class APIFunction {
  /// ------ To Call Post API -------------------->>>
  static Future<dynamic> postApiCall({
    required String apiName,
    dynamic params,
    dynamic body,
    bool? isDecode,
    Duration? receiveTimeout,
    String? accessToken,
    bool withBaseUrl = true,
  }) async {
    if (await getConnectivityResult()) {
      // if (kDebugMode) {
      //   if (!isValEmpty(params)) {
      //     printTitle("Post API params (Start)");
      //     log("$apiName - With params $params");
      //     printTitle("Post API params (End)");
      //   }
      //
      //   if (!isValEmpty(body)) {
      //     printTitle("Post API Body (Start)");
      //     log("$apiName - With Body $body");
      //     printTitle("Post API Body (End)");
      //   }
      // }

      dynamic response = await HttpUtil().post(
        withBaseUrl == true ? (ApiUrls.baseUrl + apiName) : apiName,
        isDecode: isDecode ?? false,
        body: body,
        queryParameters: params,
        options: Options(
          receiveTimeout: receiveTimeout ?? HttpUtil.defaultTimeoutDuration,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${accessToken ?? LocalStorage.accessToken.value}",
          },
        ),
      );
      return response;
    }
  }

  /// ------ To Call Put API -------------------->>>
  static Future<dynamic> putApiCall({
    required String apiName,
    dynamic params,
    dynamic body,
    bool? isDecode,
    Duration? receiveTimeout,
    bool withBaseUrl = true,
  }) async {
    if (await getConnectivityResult()) {
      // if (kDebugMode) {
      //   if (!isValEmpty(params)) {
      //     printTitle("Put API params (Start)");
      //     log("$apiName - With params $params");
      //     printTitle("Put API params (End)");
      //   }
      //
      //   if (!isValEmpty(body)) {
      //     printTitle("Put API Body (Start)");
      //     log("$apiName - With Body $body");
      //     printTitle("Put API Body (End)");
      //   }
      // }

      dynamic response = await HttpUtil().put(
        withBaseUrl == true ? (ApiUrls.baseUrl + apiName) : apiName,
        isDecode: isDecode ?? false,
        body: body,
        queryParameters: params,
        options: Options(
          receiveTimeout: receiveTimeout ?? HttpUtil.defaultTimeoutDuration,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${LocalStorage.accessToken.value}",
          },
        ),
      );
      return response;
    }
  }

  /// ------ To Call Get API -------------------->>>
  static Future<dynamic> getApiCall({
    required String apiName,
    dynamic body,
    bool? isDecode,
    dynamic params,
    RxBool? isLoading,
    Duration? receiveTimeout,
    bool withBaseUrl = true,
    Function()? notInternetConnectionActivity,
  }) async {
    if (await getConnectivityResult()) {
      isLoading?.value = true;

      // if (kDebugMode) {
      //   if (!isValEmpty(body)) {
      //     printTitle("Get API Body (Start)");
      //     log("$apiName - With Body $body");
      //     printTitle("Get API Body (End)");
      //   }
      //
      //   if (!isValEmpty(params)) {
      //     printTitle("Get API Query Parameters (Start)");
      //     log("$apiName - Query Parameters $params");
      //     printTitle("Get API Query Parameters (End)");
      //   }
      // }

      dynamic response = await HttpUtil().get(
        withBaseUrl == true ? (ApiUrls.baseUrl + apiName) : apiName,
        body: body,
        queryParameters: params,
        isDecode: isDecode ?? false,
        options: Options(
          receiveTimeout: receiveTimeout ?? HttpUtil.defaultTimeoutDuration,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${LocalStorage.accessToken.value}",
          },
        ),
      );
      return response;
    } else {
      if (notInternetConnectionActivity != null) notInternetConnectionActivity();
    }
  }

  /// ------ To Call Post API -------------------->>>
  static Future<dynamic> deleteApiCall({
    required String apiName,
    dynamic body,
    bool isFormData = false,
    Duration? receiveTimeout,
    bool withBaseUrl = true,
  }) async {
    if (await getConnectivityResult()) {
      // if (kDebugMode) {
      //   if (!isValEmpty(body)) {
      //     printTitle("Delete API Body (Start)");
      //     log("$apiName - With Body $body");
      //     printTitle("Delete API Body (End)");
      //   }
      // }
      dynamic response = await HttpUtil().delete(
        withBaseUrl == true ? (ApiUrls.baseUrl + apiName) : apiName,
        body: body,
        options: Options(
          receiveTimeout: receiveTimeout ?? HttpUtil.defaultTimeoutDuration,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${LocalStorage.accessToken.value}",
          },
        ),
      );
      return response;
    }
  }
}
