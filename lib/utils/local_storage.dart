import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../exports.dart';

class Prefs {
  static const String baseUrl = "base_URL";
  static const String userId = "ID";
  static const String userName = "NAME";
  static const String firstName = "FIRST_NAME";
  static const String lastName = "LAST_NAME";
  static const String userMobile = "MOBILE";
  static const String referralCode = "REFERRAL_CODE";
  static const String userImage = "USER_IMAGE";
  static const String accessToken = "TOKEN";
  static const String myBalance = "MY_BALANCE";

  static const String terms = "TERMS";
  static const String privacy = "PRIVACY";
  static const String aboutUs = "ABOUT-US";
  static const String contactUs = "CONTACT-US";
  static const String communityGuidelines = "COMMUNITY-GUIDELINES";
  static const String howToPlay = "HOW-TO-PLAY";
  static const String responsiblePlay = "RESPONSIBLE-PLAY";
  static const String legality = "LEGALITY";
  static const String pointsSystem = "POINTS-SYSTEM";
  static const String howToPlayVideoLink = "howToPlayVideoLink";
  static const String userGuideVideoLink = "userGuideVideoLink";
}

class DevicePrefs {
  //* =-=-=-=-=-=-=-=> Device Data <-=-=-=-=-=-=-=- //
  static const String deviceID = "DEVICE_ID";
  static const String deviceTOKEN = "DEVICE_TOKEN";
  static const String deviceTYPE = "DEVICE_TYPE";
  static const String deviceNAME = "DEVICE_NAME";
}

class LocalStorage {
  static GetStorage prefs = GetStorage();

  static RxString baseUrl = "".obs;

  static Future setAPIBaseUrl({required String? baseUrL}) async {
    if (!isValEmpty(baseUrL)) {
      await prefs.write(Prefs.baseUrl, baseUrL);
      baseUrl.value = prefs.read(Prefs.baseUrl) ?? "";
    }

    printData(key: "Update baseUrl", value: baseUrl.value);
  }

  static RxString communityGuidelinesURL = "".obs, howToPlayURL = "".obs, aboutUsURL = "".obs, responsiblePlayURL = "".obs, legalityURL = "".obs, termsAndConditionURL = "".obs, privacyURL = "".obs, contactUsURL = "".obs, pointsSystemURL = "".obs;

  static RxString userId = "".obs, userName = "".obs, firstName = "".obs, lastName = "".obs, userMobile = "".obs, userImage = "".obs, accessToken = "".obs, myBalance = "0".obs, referralCode = "".obs;

  static RxString howToPlayVideoLink = "".obs, userGuideVideoLink = "".obs;

  static Future storeUserDetails({
    String? userID,
    String? userNAME,
    String? firstNAME,
    String? referralCODE,
    String? lastNAME,
    String? userIMAGE,
    String? mobile,
    num? myBALANCE,
    String? accessTOKEN,
  }) async {
    if (!isValEmpty(userID)) {
      await prefs.write(Prefs.userId, userID);
      userId.value = prefs.read(Prefs.userId) ?? "";
    }
    if (!isValEmpty(userNAME)) {
      await prefs.write(Prefs.userName, userNAME);
      userName.value = prefs.read(Prefs.userName) ?? "";
    }
    if (!isValEmpty(firstNAME)) {
      await prefs.write(Prefs.firstName, firstNAME);
      firstName.value = prefs.read(Prefs.firstName) ?? "";
    }
    if (!isValEmpty(lastNAME)) {
      await prefs.write(Prefs.lastName, lastNAME);
      lastName.value = prefs.read(Prefs.lastName) ?? "";
    }
    if (!isValEmpty(myBALANCE)) {
      await prefs.write(Prefs.myBalance, myBALANCE.toString());
      myBalance.value = prefs.read(Prefs.myBalance) ?? "0";
    }
    if (!isValEmpty(userIMAGE)) {
      await prefs.write(Prefs.userImage, userIMAGE);
      userImage.value = prefs.read(Prefs.userImage) ?? "";
    }
    if (!isValEmpty(mobile)) {
      await prefs.write(Prefs.userMobile, mobile);
      userMobile.value = prefs.read(Prefs.userMobile) ?? "";
    }
    if (!isValEmpty(referralCODE)) {
      await prefs.write(Prefs.referralCode, referralCODE);
      referralCode.value = prefs.read(Prefs.referralCode) ?? "";
    }
    if (!isValEmpty(accessTOKEN)) {
      await prefs.write(Prefs.accessToken, accessTOKEN);
      accessToken.value = prefs.read(Prefs.accessToken) ?? "";
    }
    printData(key: "Id", value: userId.value);
    printData(key: "Mobile", value: userMobile.value);
    printData(key: "Name", value: userName.value);
    printData(key: "First Name", value: firstName.value);
    printData(key: "Last Name", value: lastName.value);
    printData(key: "Referral Code", value: referralCode.value);
    printData(key: "Image", value: userImage.value);
    printData(key: "Balance", value: myBalance.value);
    printData(key: "Access Token", value: accessToken.value);
  }

  static Future storeAppConfigs({
    String? terms,
    String? privacy,
    String? aboutUs,
    String? contactUs,
    String? communityGuidelines,
    String? howToPlay,
    String? responsiblePlay,
    String? legality,
    String? pointsSystem,
    String? howToPlayVideoLinkUrl,
    String? userGuideVideoLinkUrl,
  }) async {
    if (!isValEmpty(terms)) {
      await prefs.write(Prefs.terms, terms);
      termsAndConditionURL.value = prefs.read(Prefs.terms) ?? "";
    }
    if (!isValEmpty(privacy)) {
      await prefs.write(Prefs.privacy, privacy);
      privacyURL.value = prefs.read(Prefs.privacy) ?? "";
    }
    if (!isValEmpty(aboutUs)) {
      await prefs.write(Prefs.aboutUs, aboutUs);
      aboutUsURL.value = prefs.read(Prefs.aboutUs) ?? "";
    }
    if (!isValEmpty(contactUs)) {
      await prefs.write(Prefs.contactUs, contactUs);
      contactUsURL.value = prefs.read(Prefs.contactUs) ?? "";
    }
    if (!isValEmpty(communityGuidelines)) {
      await prefs.write(Prefs.communityGuidelines, communityGuidelines);
      communityGuidelinesURL.value = prefs.read(Prefs.communityGuidelines) ?? "";
    }
    if (!isValEmpty(howToPlay)) {
      await prefs.write(Prefs.howToPlay, howToPlay);
      howToPlayURL.value = prefs.read(Prefs.howToPlay) ?? "";
    }
    if (!isValEmpty(responsiblePlay)) {
      await prefs.write(Prefs.responsiblePlay, responsiblePlay);
      responsiblePlayURL.value = prefs.read(Prefs.responsiblePlay) ?? "";
    }
    if (!isValEmpty(legality)) {
      await prefs.write(Prefs.legality, legality);
      legalityURL.value = prefs.read(Prefs.legality) ?? "";
    }
    if (!isValEmpty(pointsSystem)) {
      await prefs.write(Prefs.pointsSystem, pointsSystem);
      pointsSystemURL.value = prefs.read(Prefs.pointsSystem) ?? "";
    }

    if (!isValEmpty(howToPlayVideoLinkUrl)) {
      await prefs.write(Prefs.howToPlayVideoLink, howToPlayVideoLinkUrl);
      howToPlayVideoLink.value = prefs.read(Prefs.howToPlayVideoLink) ?? "";
    }
    if (!isValEmpty(userGuideVideoLinkUrl)) {
      await prefs.write(Prefs.userGuideVideoLink, userGuideVideoLinkUrl);
      userGuideVideoLink.value = prefs.read(Prefs.userGuideVideoLink) ?? "";
    }
  }

  //* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-> Devices Module <=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *//
  static GetStorage devicePrefs = GetStorage();
  static RxString deviceId = "".obs, deviceName = "".obs, deviceType = "".obs, deviceToken = "".obs;

  static Future storeDeviceInfo({
    required String deviceID,
    required String deviceTOKEN,
    required String deviceTYPE,
    required String deviceNAME,
  }) async {
    await devicePrefs.write(DevicePrefs.deviceID, deviceID);
    await devicePrefs.write(DevicePrefs.deviceTOKEN, deviceTOKEN);
    await devicePrefs.write(DevicePrefs.deviceTYPE, deviceTYPE);
    await devicePrefs.write(DevicePrefs.deviceNAME, deviceNAME);

    deviceId.value = devicePrefs.read(DevicePrefs.deviceID) ?? '';
    deviceToken.value = devicePrefs.read(DevicePrefs.deviceTOKEN) ?? '';
    deviceType.value = devicePrefs.read(DevicePrefs.deviceTYPE) ?? '';
    deviceName.value = devicePrefs.read(DevicePrefs.deviceNAME) ?? '';
    deviceId.refresh();
    deviceToken.refresh();
    deviceType.refresh();
    deviceName.refresh();
  }

  //* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-> Common Functions <=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- *//

  //* -=-=-=-=-=-=-=-> Read Local Storage <-=-=-=-=-=-=-=- //
  static Future<void> readDataInfo() async {
    baseUrl.value = prefs.read(Prefs.baseUrl) ?? "";

    userId.value = prefs.read(Prefs.userId) ?? "";
    userName.value = prefs.read(Prefs.userName) ?? "";
    firstName.value = prefs.read(Prefs.firstName) ?? "";
    lastName.value = prefs.read(Prefs.lastName) ?? "";
    userMobile.value = prefs.read(Prefs.userMobile) ?? "";
    referralCode.value = prefs.read(Prefs.referralCode) ?? "";
    userImage.value = prefs.read(Prefs.userImage) ?? "";
    myBalance.value = prefs.read(Prefs.myBalance) ?? "0";
    accessToken.value = prefs.read(Prefs.accessToken) ?? "";

    deviceId.value = devicePrefs.read(DevicePrefs.deviceID) ?? '';
    deviceToken.value = devicePrefs.read(DevicePrefs.deviceTOKEN) ?? '';
    deviceType.value = devicePrefs.read(DevicePrefs.deviceTYPE) ?? '';
    deviceName.value = devicePrefs.read(DevicePrefs.deviceNAME) ?? '';
  }

  //! -=-=-=-=-=-=-=> Clear Local Storage  <-=-=-=-=-=-=-= //
  static Future<void> clearLocalStorage() async {
    await prefs.erase(); //? Prefs Storage Erase

    userId = "".obs;
    userName = "".obs;
    firstName = "".obs;
    lastName = "".obs;
    userMobile = "".obs;
    userImage = "".obs;
    myBalance = "0".obs;
    referralCode = "".obs;
    accessToken = "".obs;
  }

  static Future<void> printLocalStorageData() async {
    printData(key: "Id", value: userId.value);
    printData(key: "Name", value: userName.value);
    printData(key: "First Name", value: firstName.value);
    printData(key: "Last Name", value: lastName.value);
    printData(key: "Referral Code", value: referralCode.value);
    printData(key: "Mobile", value: userMobile.value);
    printData(key: "User Image", value: userImage.value);
    printData(key: "My Balance", value: myBalance.value);
    printData(key: "Access Token", value: accessToken.value);

    printDate("Device Permanent Data");

    printData(key: "Local Device Id", value: deviceId);
    printData(key: "Local Device Type", value: deviceType);
    printData(key: "Local Device Name", value: deviceName);
    printData(key: "Local Device Token", value: deviceToken);
  }
}
