
import 'package:get/get.dart';

import '../../data/models/common/get_state_model.dart';
import '../../exports.dart';

class CommonRepository {
  CommonRepository._();

  /// ***********************************************************************************
  /// *                                 FILE TO URL                                     *
  /// ***********************************************************************************

  ///* =-=-=-=-=-=-=-= UPLOAD TO SERVER TEMP FOLDER =-=-=-=-=-=-=->>
  /*static Future<String?> uploadFileToUrlAPI({RxBool? isLoader, bool skipCall = false, bool hideLoaderOnSuccess = false, required String filePath}) async {
    if (await getConnectivityResult()) {
      if (skipCall == false) {
        try {
          isLoader?.value = true;
          return await APIFunction.postApiCall(
            apiName: ApiUrls.uploadFile,
            isDecode: true,
            receiveTimeout: Duration.zero,
            body: {
              "file": await dio.MultipartFile.fromFile(
                filePath,
                filename: filePath.split("/").last,
              )
            },
          ).then(
            (response) async {
              if (response != null && response['success'] == true) {
                if (hideLoaderOnSuccess) {
                  isLoader?.value = false;
                }
                return response['file'].toString();
              } else {
                printErrors(type: "uploadFileToUrlAPI Function", errText: "Image URL not found");

                if (hideLoaderOnSuccess) {
                  isLoader?.value = false;
                }
                return null;
              }
            },
          );
        } catch (e) {
          isLoader?.value = false;
          printErrors(type: "uploadFileToUrlAPI Function", errText: e);
          return null;
        }
      } else {
        isLoader?.value = false;
        printErrors(type: "uploadFileToUrlAPI Function", errText: "Skip calling");
        return null;
      }
    } else {
      return null;
    }
  }*/

  ///* =-=-=-=-=-=-=-= DELETE IMAGE TO SERVER TEMP FOLDER =-=-=-=->>
  //! Delete image not working on backend.
  /* static Future<bool?> deleteUrlToFile({RxBool? isLoader, bool hideLoaderOnSuccess = false, required String deleteUrl}) async {
    if (await getConnectivityResult(showToast: false)) {
      try {
        isLoader?.value = true;

        return await APIFunction.deleteApiCall(
          apiName: ApiUrls.deleteFile,
          body: {
            "file": deleteUrl,
          },
        ).then(
          (response) async {
            if (response != null && response['success'] == true) {
              if (hideLoaderOnSuccess) {
                isLoader?.value = false;
              }

              return true;
            } else {
              printErrors(type: "deleteUrlToFile Function", errText: "Image File not found");

              if (hideLoaderOnSuccess) {
                isLoader?.value = false;
              }
              return null;
            }
          },
        );
      } catch (e) {
        isLoader?.value = false;
        printErrors(type: "deleteUrlToFile Function", errText: e);
        return null;
      }
    }
    return null;
  } */

  /// ***********************************************************************************
  /// *                      GET COUNTRY, STATE, AND CITY DATA                          *
  /// ***********************************************************************************

  ///* =-=-=-=-=-=-=-= COUNTRY =-=-=-=-=-=-=-=-=->>
  /*static Future<List<CountryModel>?> getCountryList({RxBool? isLoader}) async {
    if (await getConnectivityResult()) {
      try {
        isLoader?.value = true;

        return await APIFunction.getApiCall(apiName: ApiUrls.getAllCountry).then(
          (response) async {
            if (!isValEmpty(response) && response["success"] == true && !isValEmpty(response["data"])) {
              final GetCountryModel getCountryModel = GetCountryModel.fromJson(response);
              isLoader?.value = false;

              return getCountryModel.data;
            } else {
              return null;
            }
          },
        );
      } catch (e) {
        printErrors(type: "getCountryList Function", errText: e);
        isLoader?.value = false;
        return null;
      }
    } else {
      return null;
    }
  }*/

  ///* =-=-=-=-=-=-=-= STATE =-=-=-=-=-=-=-=-=-=->>
  static Future<List<StateModel>?> getStateListByCountry({RxBool? isLoader, required String countryId}) async {
    if (await getConnectivityResult()) {
      try {
        isLoader?.value = true;

        return await APIFunction.getApiCall(
          apiName: ApiUrls.getStatesByCountry(countryId: countryId),
          params: {"page": 1, "limit": 100},
        ).then(
          (response) async {
            if (!isValEmpty(response) && response["success"] == true && !isValEmpty(response["data"])) {
              // log(jsonEncode(response));
              final GetStateModel getStateModel = GetStateModel.fromJson(response);
              isLoader?.value = false;

              return getStateModel.data?.states;
            } else {
              return null;
            }
          },
        );
      } catch (e) {
        printErrors(type: "getStateListByCountry Function", errText: e);
        isLoader?.value = false;
        return null;
      }
    } else {
      return null;
    }
  }

  ///* =-=-=-=-=-=-=-= CITY -=-=-=-=-=-=-=-=-=-=->>
/*static Future<List<CityModel>?> getCityListByStates({RxBool? isLoader, required String stateId}) async {
    if (await getConnectivityResult()) {
      try {
        isLoader?.value = true;

        return await APIFunction.getApiCall(apiName: ApiUrls.getCityByStates(stateId: stateId)).then(
          (response) async {
            if (!isValEmpty(response) && response["success"] == true && !isValEmpty(response["data"])) {
              final GetCityModel getCityModel = GetCityModel.fromJson(response);
              isLoader?.value = false;

              return getCityModel.data;
            } else {
              return null;
            }
          },
        );
      } catch (e) {
        printErrors(type: "getCityList Function", errText: e);
        isLoader?.value = false;
        return null;
      }
    } else {
      return null;
    }
  }*/
}
