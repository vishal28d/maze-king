import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../exports.dart';
import '../views/game_view_screen/game_controller.dart';

const double defaultPadding = 16.0;
const double defaultRadius = 8.0;
const int defaultAmountLength = 12;
const int defaultQuantityLength = 12;
const Duration defaultDuration = Duration(milliseconds: 200);

List<BoxShadow> defaultShadow(BuildContext context) => [
      BoxShadow(blurStyle: BlurStyle.outer, color: Theme.of(context).iconTheme.color!.withOpacity(1), blurRadius: 1, spreadRadius: 20),
    ];

bool isValEmpty(dynamic val) {
  String? value = val.toString();
  return (val == null || value.isEmpty || value == "null" || value == "" || value == "NULL" || value == '');
}

bool isValZero(num? number) {
  return number != null && number.isEqual(0);
}

bool isAmountValid(dynamic val) {
  if (double.parse(val.isEmpty ? "0.1" : val) > 100.0) {
    return false;
  } else {
    return true;
  }
}

bool isPeriodValid(dynamic val) {
  if (double.parse(val.isEmpty ? "0.1" : val) < 15.0) {
    return false;
  } else {
    return true;
  }
}

bool isProcessingFeesValid(dynamic val) {
  if (double.parse(val.isEmpty ? "0.1" : val) > 50.0) {
    return false;
  } else {
    return true;
  }
}

String formatAmount(amount) {
  num myAmount = num.parse((amount ?? "0").toString());
  final formatter = NumberFormat('#,##,###.####');
  return formatter.format(myAmount);
}

bool isRegistered<S>() {
  if (Get.isRegistered<S>()) {
    return true;
  } else {
    printErrors(type: "Function 'isRegistered' in utils:", errText: "$S Controller not initialize");
    /* if (forcePut == true) {
      printData(key: "Force Putting", value: "Controller $S");
    } */
    return false;
  }
}

void deleteGameViewController() {
  if (isRegistered<MazeGameController>()) {
    // UiUtils.toast("MazeGameController REMOVED -----");
    Get.delete<MazeGameController>();
    printOkStatus("deleteGameViewController - END");
  }
}

/// ***********************************************************************************
///                                       DEBOUNCE TIMER
/// ***********************************************************************************

Timer? _debounceTimer;

void commonDebounce({
  required Future<void> Function() callback,
  Duration duration = const Duration(milliseconds: 400),
}) {
  if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
  _debounceTimer = Timer(
    duration,
    () async {
      ///  CALL
      await callback();
    },
  );
}

LinearGradient appButtonLinearGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: <Color>[
    Theme.of(Get.context!).colorScheme.secondary,
    const Color(0xffEF463C),
    Theme.of(Get.context!).colorScheme.tertiary,
  ],
);

/// ***********************************************************************************
///                                 Check Internet Ability
/// ***********************************************************************************

ConnectivityResult? connectivityResult;
final Connectivity connectivity = Connectivity();

Future<bool> getConnectivityResult({bool showToast = true, RxBool? isLoader}) async {
  try {
    connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else {
      if (showToast == true) {
        UiUtils.toast(AppStrings.noInternetAvailable);
      }
      return false;
    }
  } on PlatformException catch (e) {
    printErrors(type: "getConnectivityResult Function", errText: e);
    UiUtils.toast(AppStrings.noInternetAvailable);
    isLoader?.value = false;
    return false;
  }
}

BoxBorder defaultBorder = Border.all(color: const Color(0xffE8E8E8));

DateTime defaultDateTime = DateTime.parse("1999-01-01 12:00:00.974368");

Future<void> storeDeviceInformation(fcmToken) async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = (await deviceInfoPlugin.androidInfo);
      await LocalStorage.storeDeviceInfo(
        deviceID: androidDeviceInfo.id,
        deviceTOKEN: fcmToken,
        deviceTYPE: AppStrings.androidSlag,
        deviceNAME: androidDeviceInfo.model,
      );
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = (await deviceInfoPlugin.iosInfo);
      await LocalStorage.storeDeviceInfo(
        deviceID: iosDeviceInfo.identifierForVendor ?? "",
        deviceTOKEN: fcmToken,
        deviceTYPE: AppStrings.iOSSlag,
        deviceNAME: iosDeviceInfo.utsname.machine,
      );
    }
  } catch (k) {
    debugPrint(k.toString());
  }
}

Future<PackageInfo> getPackageInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  printData(key: "AppName", value: packageInfo.appName);
  printData(key: "Version", value: packageInfo.version);
  printData(key: "PackageName", value: packageInfo.packageName);

  return packageInfo;
}

extension StrExtension on String {
  static String capitalize(String s) {
    return "${s[0].toUpperCase()}${s.substring(1).toLowerCase()}";
  }

  static String defaultDateTimeFormat(DateTime dateTime) {
    return DateFormat("dd/MM/yyyy").format(dateTime);
  }
}

Future<void> launchUrlFunction(url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

DateTime findFutureDate({DateTime? futureDate, required double totalMonths}) {
  futureDate ??= DateTime.now();

  for (int i = 1; i <= totalMonths; i++) {
    int year = futureDate!.year;
    int month = futureDate.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }

    futureDate = DateTime(year, month, futureDate.day, futureDate.hour, futureDate.minute, futureDate.second, futureDate.millisecond, futureDate.microsecond);
  }

  return futureDate!;
}

Future<File> createTempFile(Uint8List uint8List) async {
  // Create a temporary directory
  Directory tempDir = await Directory.systemTemp.createTemp();

  // Create a temporary file
  File tempFile = File('${tempDir.path}/temp_image.png');

  // Write the image bytes to the file
  await tempFile.writeAsBytes(uint8List);

  return tempFile;
}

UnsupportedError get platformUnsupportedError => UnsupportedError("Sorry, this app is Android and iOS so it does not support another platform.");

Future<void> deleteCacheDir() async {
  final Directory cacheDir = await getTemporaryDirectory();

  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
}

class Restart {
  /// A private constant `MethodChannel`. This channel is used to communicate with the
  /// platform-specific code to perform the restart operation.
  static const MethodChannel _channel = MethodChannel('restart');

  /// Restarts the Flutter application.

  /// The `webOrigin` parameter is optional. If it's null, the method uses the `window.origin`
  /// to get the site origin. This parameter should only be filled when your current origin
  /// is different than the app's origin. It defaults to null.

  /// This method communicates with the platform-specific code to perform the restart operation,
  /// and then checks the response. If the response is "ok", it returns true, signifying that
  /// the restart operation was successful. Otherwise, it returns false.
  static Future<bool> restartApp({String? webOrigin}) async => (await _channel.invokeMethod('restartApp', webOrigin)) == "ok";
}

Future<void> pickImages(
  BuildContext context, {
  bool isSingleImage = true,
  bool withCropper = true,
  ImageSource? source,
  // CropStyle? cropStyle,
  CropAspectRatio? aspectRatio,
  void Function(XFile?)? xFileChange,
  void Function(List<XFile>?)? imageListOnChange,
  void Function(CroppedFile?)? croppedFileChange,
}) async {
  void callingAllNull() {
    xFileChange != null ? xFileChange(null) : null;
    croppedFileChange != null ? croppedFileChange(null) : null;
    imageListOnChange != null ? imageListOnChange(null) : null;
  }

  final ImagePicker imagePicker = ImagePicker();

  if (isSingleImage) {
    final XFile? image = await imagePicker.pickImage(source: source ?? ImageSource.gallery);

    if (image != null && withCropper) {
      XFile? compressedFile = await _compressImage(image.path);

      CroppedFile? cropper = await singleImageCropper(
        context, // ignore: use_build_context_synchronously
        fileImage: compressedFile!,
        // cropStyle: cropStyle,
        aspectRatio: aspectRatio,
      );

      if (withCropper) {
        croppedFileChange != null ? croppedFileChange(cropper) : null;
      } else {
        xFileChange != null ? xFileChange(compressedFile) : null;
      }
    } else {
      //? Null calling...
      callingAllNull();
    }
  } else {
    List<XFile>? pickedImages = await imagePicker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      imageListOnChange != null ? imageListOnChange(pickedImages) : null;

      //? Null calling...
      xFileChange != null ? xFileChange(null) : null;
      croppedFileChange != null ? croppedFileChange(null) : null;
    } else {
      //? Null calling...
      callingAllNull();
    }
  }
}

// Future<XFile?> _compressImage(String path) async {
//   XFile? result = await FlutterImageCompress.compressAndGetFile(
//     path,
//     '${path}_compressed.jpg',
//     // '${path}_compressed.png',
//     quality: 50,
//   );
//   return result;
// }


Future<XFile?> _compressImage(String path) async {
  try {
    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/compressed_image.jpg';

    // Compress the image and save it in the temp directory
    XFile? result = await FlutterImageCompress.compressAndGetFile(
      path,
      tempPath,
      quality: 50, // Compression quality
    );

    // Return the compressed file
    return result;
  } catch (e) {
    if (kDebugMode) {
      print('Error compressing image: $e');
    }
    return null;
  }
}




// Future<CroppedFile?> singleImageCropper(
//   BuildContext context, {
//   required XFile fileImage,
//   String? cropperTitle,
//   CropStyle? cropStyle,
//   CropAspectRatio? aspectRatio,
// }) async {
//   String toolbarTitle = cropperTitle ?? "Cropper";

//   CroppedFile? cropper = await ImageCropper().cropImage(
//     sourcePath: fileImage.path,
//     cropStyle: cropStyle ?? CropStyle.rectangle,
//     aspectRatio: aspectRatio ??
//         const CropAspectRatio(
//           ratioX: 100,
//           ratioY: 100,
//         ),
//     uiSettings: [
//       AndroidUiSettings(
//         toolbarTitle: toolbarTitle,
//         lockAspectRatio: true,
//         initAspectRatio: CropAspectRatioPreset.original,
//         cropGridColor: Colors.grey,
//         cropFrameColor: Colors.grey,
//         toolbarColor: Theme.of(context).primaryColor,
//         // ignore: use_build_context_synchronously
//         toolbarWidgetColor: AppColors.getColorOnBackground(Theme.of(context).primaryColor),
//         // ignore: use_build_context_synchronously
//         statusBarColor: Theme.of(context).primaryColor,
//         // ignore: use_build_context_synchronously
//         activeControlsWidgetColor: Theme.of(context).primaryColor,
//       ),
//       IOSUiSettings(
//         title: toolbarTitle,
//         minimumAspectRatio: 1,
//         resetButtonHidden: true,
//         rotateClockwiseButtonHidden: true,
//         rotateButtonsHidden: true,
//         aspectRatioPickerButtonHidden: true,
//       ),
//     ],
//   );

//   return cropper;
// }

Future<CroppedFile?> singleImageCropper(
  BuildContext context, {
  required XFile fileImage,
  String? cropperTitle,
  CropStyle? cropStyle,
  CropAspectRatio? aspectRatio,
}) async {
  String toolbarTitle = cropperTitle ?? "Cropper";

  CroppedFile? cropper = await ImageCropper().cropImage(
    sourcePath: fileImage.path,
    cropStyle: cropStyle ?? CropStyle.rectangle,
    aspectRatio: aspectRatio ?? const CropAspectRatio(ratioX: 100, ratioY: 100),
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: toolbarTitle,
        lockAspectRatio: true,
        initAspectRatio: CropAspectRatioPreset.original,
        cropGridColor: Colors.grey,
        cropFrameColor: Colors.grey,
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: AppColors.getColorOnBackground(Theme.of(context).primaryColor),
        statusBarColor: Theme.of(context).primaryColor,
        activeControlsWidgetColor: Theme.of(context).primaryColor,
      ),
      IOSUiSettings(
        title: toolbarTitle,
        minimumAspectRatio: 1,
        resetButtonHidden: true,
        rotateClockwiseButtonHidden: true,
        rotateButtonsHidden: true,
        aspectRatioPickerButtonHidden: true,
      ),
    ],
  );

  return cropper; // Ensure to return the cropped file.
}


shareAppLink({required String link}) async {
  final result = await Share.shareWithResult(link, subject: AppStrings.appName);
  if (result.status == ShareResultStatus.success) {
    // printOkStatus('Thank you for sharing my website!');
  }
}

dateFormat({required DateTime? date}) {
  return DateFormat('MMM yyyy').format(date!);
}

String convertDateIntoString({int? day, int? month, int? year}) {
  final date = DateTime(year ?? 0, month ?? 0, day ?? 0).toIso8601String();
  return date;
}

String fullDateFormat({int? day, int? month, int? year}) {
  final formatDate = "$day ${DateFormat('MMM').format(
    DateTime(0, month ?? 0),
  )} $year";
  return formatDate;
}

String timeFormat({required DateTime time}) {
  return DateFormat('hh:mm a').format(time);
}
