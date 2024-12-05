import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'data/services/firebase_service.dart';
import 'data/services/notification_service.dart';
import 'exports.dart';
import 'firebase_options.dart';
import 'res/widgets/stretch_scroll_behavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await LocalStorage.readDataInfo();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light);
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // printOkStatus(LocalStorage.baseUrl);
    LocalStorage.printLocalStorageData();
    printData(key: "accessToken", value: LocalStorage.accessToken);
    printData(key: "device_token", value: LocalStorage.deviceToken);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return GetMaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          initialBinding: LazyBinding(),
          themeMode: ThemeMode.light,
          theme: AppTheme.lightMode(
            context,
            kPrimaryColor: AppColors.primary,
            kBackgroundColor: AppColors.backgroundLight,
            errorColor: AppColors.error,
            fontFamily: AppTheme.fontFamilyName,
            kSecondaryColor: AppColors.secondary,
            kTertiaryColor: AppColors.tertiary,
          ),
          darkTheme: AppTheme.darkMode(
            context,
            kPrimaryColor: AppColors.primary,
            kBackgroundColor: AppColors.backgroundDark,
            errorColor: AppColors.error,
            fontFamily: AppTheme.fontFamilyName, 
          ),
          scrollBehavior: ScrollBehaviorModified(),
          getPages: AppPages.pages,
          // initialRoute: AppRoutes.onBoardingScreen,
          initialRoute: AppRoutes.splashScreen,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
              child: child!,
            );
          },
        );
      },
    );
  }
}

class LazyBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(BaseController(), permanent: true);
    Get.put(FirebaseService(), permanent: true);
    printData(key: "Get.put", value: BaseController);
  }
}
