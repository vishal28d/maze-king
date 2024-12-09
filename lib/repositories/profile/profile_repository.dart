// import 'package:get/get.dart';

// import 'package:dio/dio.dart' as dio;
// import 'package:maze_king/data/models/profile/user_details_model.dart';
// import 'package:maze_king/exports.dart';
// import 'package:maze_king/views/profile/widgets/info_and_setting_screen/info_and_setting_controller.dart';

// import '../../data/models/common/get_state_model.dart';

// class ProfileRepository {
//   /// ***********************************************************************************
//   ///                              GET USER DETAILS
//   /// ***********************************************************************************

//   static Future<dynamic> getUserDetailsAPI({RxBool? isLoader}) async {
//     try {
//       isLoader?.value = true;

//       return await APIFunction.getApiCall(apiName: ApiUrls.getUserDetailsUrl).then(
//         (response) async {
//           if (response != null && response['success'] == true) {
//             final MyInfoAndSettingController con = Get.find<MyInfoAndSettingController>();
//             con.userDetails.value = UserDetailsModel.fromJson(response['data']);
//             // printOkStatus(con.userDetails.value.image);

//             isLoader?.value = false;
//             return con.userDetails.value;
//           }
//           return response;
//         },
//       );
//     } catch (e) {
//       isLoader?.value = false;
//       printErrors(type: "getUserDetailsAPI", errText: e);
//     }
//   }

//   /// ***********************************************************************************
//   ///                              UPDATE PROFILE
//   /// ***********************************************************************************

//   static Future<dynamic> updateProfileAPI({
//     String? firstName,
//     String? lastName,
//     String? image,
//     String? gender,
//     String? address,
//     String? city,
//     StateModel? stateModel,
//     RxBool? isLoader,
//   }) async {
//     try {
//       isLoader?.value = true;

//       await APIFunction.putApiCall(
//         apiName: ApiUrls.updateProfileUrl,
//         isDecode: true,
//         body: {
//           if (!isValEmpty(firstName)) "first_name": firstName,
//           if (!isValEmpty(lastName)) "last_name": lastName,
//           if (!isValEmpty(image) && !(image!.startsWith(AppStrings.httpPrefix) || image.startsWith(AppStrings.httpsPrefix)))
//             "image": await dio.MultipartFile.fromFile(
//               image,
//               filename: image.split("/").last,
               
//             ),
//           if (!isValEmpty(city)) "city": city,
//           if (!isValEmpty(gender)) "gender": gender,
//           if (!isValEmpty(address)) "address": address,
//           if (!isValEmpty(stateModel?.id)) "state": stateModel!.id,
//         },
//       ).then(
//         (response) async {
//           if (response != null) {
//             if (response['data'] != null) {
//               Map userData = response['data'];
//               LocalStorage.storeUserDetails(
//                 userNAME: userData['user_name'] ?? "",
//                 userIMAGE: userData['image'] ?? "",
//                 firstNAME: userData['first_name'] ?? "",
//                 lastNAME: userData['last_name'] ?? "",
//               );
//             }
//             isLoader?.value = false;
//             UiUtils.toast("Update Successfully");
//           }
//           return response;
//         },
//       );
//     } catch (e) {
//       isLoader?.value = false;
//       printErrors(type: "updateProfile", errText: "$e");
//     }
//   }
// }



import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:maze_king/data/models/profile/user_details_model.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/views/profile/widgets/info_and_setting_screen/info_and_setting_controller.dart';
import '../../data/models/common/get_state_model.dart';

class ProfileRepository {
  /// Utility function to validate image file format
  static bool _isValidImage(String? path) {
    if (path == null || path.isEmpty) return false;
    final allowedExtensions = ['jpg', 'jpeg', 'png'];
    final extension = path.split('.').last.toLowerCase();
    return allowedExtensions.contains(extension);
  }

  /// ***********************************************************************************
  ///                              GET USER DETAILS
  /// ***********************************************************************************

  static Future<dynamic> getUserDetailsAPI({RxBool? isLoader}) async {
    try {
      isLoader?.value = true;

      return await APIFunction.getApiCall(apiName: ApiUrls.getUserDetailsUrl).then(
        (response) async {
          if (response != null && response['success'] == true) {
            final MyInfoAndSettingController con = Get.find<MyInfoAndSettingController>();
            con.userDetails.value = UserDetailsModel.fromJson(response['data']);
            isLoader?.value = false;
            return con.userDetails.value;
          }
          isLoader?.value = false;
          UiUtils.toast("Failed to fetch user details.");
          return response;
        },
      );
    } catch (e) {
      isLoader?.value = false;
      printErrors(type: "getUserDetailsAPI", errText: e.toString());
      UiUtils.toast("Error fetching user details.");
    }
  }

  /// ***********************************************************************************
  ///                              UPDATE PROFILE
  /// ***********************************************************************************

  static Future<dynamic> updateProfileAPI({
  String? firstName,
  String? lastName,
  String? image,
  String? gender,
  String? address,
  String? city,
  StateModel? stateModel,
  RxBool? isLoader,
}) async {
  try {
    isLoader?.value = true;

    // Prepare the body as a Map first
    final Map<String, dynamic> body = {};

    if (!isValEmpty(firstName)) body["first_name"] = firstName;
    if (!isValEmpty(lastName)) body["last_name"] = lastName;
    if (!isValEmpty(city)) body["city"] = city;
    if (!isValEmpty(gender)) body["gender"] = gender;
    if (!isValEmpty(address)) body["address"] = address;
    if (!isValEmpty(stateModel?.id)) body["state"] = stateModel!.id;

    // If there's an image, prepare FormData for image
    if (!isValEmpty(image) &&
        !(image!.startsWith(AppStrings.httpPrefix) || image.startsWith(AppStrings.httpsPrefix)) &&
        _isValidImage(image)) {
      // Add the image as a multipart file
      final imageFile = await _createMultipartFile(image);
      // If image is valid, add the image to the request body as multipart
      body["image"] = imageFile; // The image here is handled as MultipartFile
    }

    // Convert the entire body to FormData if there is an image
    final formData = dio.FormData.fromMap(body);

    // Now make the API call, pass the formData if an image is included
    final response = await APIFunction.putApiCall(
      apiName: ApiUrls.updateProfileUrl,
      isDecode: true,
      body: body, // Send FormData when image is included, else just body
    ).then((response) async {
      if (response != null && response['success'] == true) {
        // Update local storage with the new details
        final userData = response['data'];
        LocalStorage.storeUserDetails(
          userNAME: userData['user_name'] ?? "",
          userIMAGE: userData['image'] ?? "",
          firstNAME: userData['first_name'] ?? "",
          lastNAME: userData['last_name'] ?? "",
        );
        isLoader?.value = false;
        UiUtils.toast("Profile updated successfully.");
      } else {
        isLoader?.value = false;
        UiUtils.toast(response?['message'] ?? "Failed to update profile.");
      }
      return response;
    });

    return response;
  } catch (e) {
    isLoader?.value = false;
    printErrors(type: "updateProfile", errText: e.toString());
    UiUtils.toast("Error updating profile. Please try again.");
  }
}



  // Utility function to create MultipartFile from image
  static Future<dio.MultipartFile> _createMultipartFile(String imagePath) async {
    try {
      final mediaType = await _getImageMimeType(imagePath);
      return dio.MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split("/").last, // Extract filename
        contentType: dio.DioMediaType.parse(mediaType), // Ensure correct media type
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error creating multipart file: $e");
      }
      rethrow;
    }
  }

  /// Function to get the image MIME type based on file extension
  static Future<String> _getImageMimeType(String imagePath) async {
    // Determine MIME type based on the file extension
    String extension = imagePath.split('.').last.toLowerCase();
    if (extension == 'png') {
      return 'image/png'; // Set MIME type for PNG images
    } else if (extension == 'jpeg' || extension == 'jpg') {
      return 'image/jpeg'; // Set MIME type for JPEG images
    } else {
      // If the file is neither PNG nor JPEG, return an error or default to JPEG
      throw Exception('Invalid image format. Only JPG and PNG are allowed.');
    }
  }
}
