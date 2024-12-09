import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../exports.dart';
import '../../repositories/game/game_repository.dart';
import '../../views/contest_details/contest_details_controller.dart';
import '../models/game/game_details_model.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
String deviceToken = '';

abstract class NotificationService {
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
    enableVibration: true,
    playSound: true,
    enableLights: true,
  );

  static Future<void> init() async {
    getNotificationPermission();
    firebaseMessagingInit();
    getMessage();
  }

  static Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.requestPermission().then(
      (_) {
        return FirebaseMessaging.instance.getToken().then(
          (token) {
            storeDeviceInformation(token);
            return token;
          },
        );
      },
    );
  }

  static Future getNotificationPermission() async {
    await getFCMToken();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          critical: true,
        );
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  static void firebaseMessagingInit() async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      // defaultPresentSound: true,
      // defaultPresentAlert: true,
    );
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
  }

  static Future<dynamic> onSelectNotification(NotificationResponse notificationResponse) async {
    debugPrint("-=-=-=-=-=-=-> onSelectNotification <-=-=-=-=-=--=-");
    if (notificationResponse.payload != null && notificationResponse.payload!.isNotEmpty) {
      navigation(notificationResponse.payload);
    }
  }

  static void getMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // KILL APP
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      printData(key: "getMessage Function", value: "Initial Get Message");
      if (message != null) {
        navigation(message.data);
      }
    });
    // BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      debugPrint('-=-=-=-=-=-=-> onMessageOpenedApp <-=-=-=-=-=--');
      if (message != null) {
        navigation(message.data);
      }
    });
    // OPEN APP
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage? message) async {
        debugPrint('-=-=-=-=-=-=-> onMessage <-=-=-=-=-=--');
        printOkStatus("title: ${message?.notification?.title}");
        printOkStatus("desc: ${message?.notification?.body}");
        // log(jsonEncode(message?.data));

        if (message != null) {
          /// refresh requirement screen

          ///
          if (Platform.isAndroid) {
            await showNotification(remoteMessage: message);
          }
        } else {
          debugPrint('onMessage NULL');
        }
      },
    );
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
      alert: true,
      sound: true,
    );
  }

  static Future<void> showNotification({RemoteMessage? remoteMessage}) async {
    AndroidNotificationDetails android = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      color: Theme.of(Get.context!).primaryColor,
      importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,
      priority: Priority.high,
      showWhen: false,
    );
    DarwinNotificationDetails iOS = const DarwinNotificationDetails(
      sound: 'notification_sound.wav',
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
      // interruptionLevel: InterruptionLevel.critical,
    );
    NotificationDetails platform = NotificationDetails(android: android, iOS: iOS);
    if (remoteMessage != null && !isValEmpty(remoteMessage.notification) && !isValEmpty(remoteMessage.notification?.title) && !isValEmpty(remoteMessage.notification?.body)) {
      await flutterLocalNotificationsPlugin.show(
        remoteMessage.notification.hashCode,
        remoteMessage.notification?.title,
        remoteMessage.notification?.body,
        platform,
        payload: jsonEncode(remoteMessage.data),
      );
    }

    /*await flutterLocalNotificationsPlugin.show(
      remoteMessage!.notification.hashCode,
      remoteMessage.notification?.title,
      remoteMessage.notification?.body,
      platform,
      payload: jsonEncode(remoteMessage.data),
    );*/
  }

  /// ------------------- TOPIC SUBSCRIPTION -------------------
  /// SUBSCRIBE
  static Future<void> subscribeTopic(String topicName) async {
    await FirebaseMessaging.instance.subscribeToTopic(topicName);
  }

  /// UN-SUBSCRIBE
  static Future<void> unSubscribeTopic(String topicName) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topicName);
  }

  /// ---------------------------------------------------------

  static navigation(notificationPayload) async {
    try {
      printData(key: "payload ", value: notificationPayload);
      Map<String, dynamic> payload = {};
      if (notificationPayload.runtimeType == String) {
        payload = jsonDecode(notificationPayload);
      } else {
        payload = notificationPayload;
      }

      /// --------------- My upcoming contest => countdown screen navigation ---------------

      if (payload['type'] == 'timer_screen' && !isValEmpty(payload['contest'])) {
        String contestId = payload['contest'] ?? "";
        String recurringId = payload['recurring'] ?? "";

        // final MyUpcomingContestModel model = MyUpcomingContestModel.fromJson(data);
        if (!isValEmpty(LocalStorage.accessToken.value) && Get.currentRoute != AppRoutes.gameCountdownScreen && Get.currentRoute != AppRoutes.gameViewScreen) {
          Get.toNamed(
            AppRoutes.gameCountdownScreen,
            arguments: {
              "contestId": contestId,
              "recurringId": recurringId,
              "whenCompleteFunction": () {},
            },
          );
        }
      }

      /// --------------- My upcoming contest => countdown screen navigation ---------------

      if (payload['type'] == 'un_joined_contest' && !isValEmpty(payload['contest'])) {
        String contestId = payload['contest'] ?? "";

        GameDetailsModel? gameDetailsModel = await GameRepository.getGameDetailsAPI(contestId: contestId, recurringId: '', isJoined: false);

        if (Get.currentRoute == AppRoutes.gameCountdownScreen) {
          Get.back();
        }

        if (!isValEmpty(LocalStorage.accessToken.value) && Get.currentRoute != AppRoutes.gameCountdownScreen && Get.currentRoute != AppRoutes.gameViewScreen) {
          Get.toNamed(
            AppRoutes.contestDetailsScreen,
            arguments: {
              "contestDetailsType": ContestDetailsType.unJoined,
              "contestId": contestId,
              "recurringId": gameDetailsModel!.recurringId,
            },
          );
        }
            }

      /// ----------------------------------- OTHER --------------------------------------
    } catch (e) {
      printErrors(type: "Notification Navigation", errText: "$e");
    }
  }

  static Future<void> storeDeviceInformation(fcmToken) async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = (await deviceInfoPlugin.androidInfo);
        await LocalStorage.storeDeviceInfo(
          deviceID: androidDeviceInfo.id,
          deviceTOKEN: fcmToken,
          deviceTYPE: AppStrings.androidSlag,
          deviceNAME: androidDeviceInfo.device,
        );
      } else if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = (await deviceInfoPlugin.iosInfo);
        await LocalStorage.storeDeviceInfo(
          deviceID: iosDeviceInfo.identifierForVendor ?? "",
          deviceTOKEN: fcmToken,
          deviceTYPE: AppStrings.iOSSlag,
          deviceNAME: iosDeviceInfo.model,
        );
      }
    } catch (k) {
      debugPrint(k.toString());
    }
  }
}
