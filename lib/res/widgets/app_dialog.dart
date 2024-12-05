import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/data/handler/app_environment.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../exports.dart';

class AppDialogs {
  static Future<void> splashApiDialog({required VoidCallback onSuccess}) {
    final Rx<TextEditingController> apiCon = TextEditingController(text: !isValEmpty(LocalStorage.baseUrl.value) ? LocalStorage.baseUrl.value : AppEnvironment.getApiURL()).obs;

    return Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop: false,
        onPopInvoked: (value) {},
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(defaultRadius),
            ),
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Set your API base URL",
                  style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(fontSize: 17.sp),
                ).paddingOnly(left: defaultPadding / 2, bottom: defaultPadding / 1.5),
                AppTextField(
                  controller: apiCon.value,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: defaultPadding / 2),
                Text(
                  "• Wrong URl enter kari to app restart karvi padse.",
                  style: Theme.of(Get.context!).textTheme.titleMedium,
                ).paddingOnly(left: defaultPadding / 2, bottom: defaultPadding / 1.5),
                AppButton(
                  title: "SAVE",
                  onPressed: () async {
                    await LocalStorage.setAPIBaseUrl(baseUrL: apiCon.value.text.trim()).then((value) => onSuccess());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> backOperation(BuildContext context) {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
          padding: const EdgeInsets.only(top: defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                margin: const EdgeInsets.symmetric(vertical: defaultPadding / 2).copyWith(top: 0),
                padding: const EdgeInsets.all(defaultPadding),
                child: const Icon(
                  Icons.exit_to_app,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2, horizontal: defaultPadding),
                child: Text(
                  AppStrings.exitAppString,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 46,
                        padding: const EdgeInsets.all(defaultPadding / 2.5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(.2),
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(defaultRadius)),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final cacheDir = await getTemporaryDirectory();
                        if (cacheDir.existsSync()) {
                          cacheDir.deleteSync(recursive: true);
                        }
                        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                      },
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(defaultRadius)),
                        ),
                        padding: const EdgeInsets.all(defaultPadding / 2.5),
                        child: Center(
                          child: Text(
                            "Exit",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> dashboardCommonDialog(
    BuildContext context, {
    required String dialogTitle,
    String? buttonTitle,
    VoidCallback? buttonOnTap,
    required Widget descriptionChild,
    RxBool? buttonLoader,
    RxBool? barrierDismissible,
    RxBool? showButton,
  }) async {
    return Get.dialog(
      Obx(
        () => PopScope(
          canPop: barrierDismissible?.isFalse ?? true,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Dialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
              clipBehavior: Clip.antiAlias,
              insetPadding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2, vertical: defaultPadding),
              elevation: 0,
              child: IntrinsicHeight(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dialogTitle,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
                        ),
                        AppButton(
                          width: 25.w,
                          height: 25.w,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          // padding: const EdgeInsets.only(bottom: defaultPadding / 2),
                          onPressed: () => Get.back(),
                          child: Center(
                            child: Icon(
                              Icons.clear,
                              size: 18.sp,
                              color: Theme.of(Get.context!).cardColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  descriptionChild,
                  if (showButton != null && showButton.isTrue)
                    AppButton(
                      padding: const EdgeInsets.all(defaultPadding),
                      title: buttonTitle ?? "-",
                      onPressed: buttonOnTap ?? () => Get.back(),
                      loader: buttonLoader?.value ?? false.obs.value,
                      loaderColor: AppColors.primary,
                      // col: AppColors.secondary,
                    ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> logoutDialog(BuildContext context, {required VoidCallback onTap, required RxBool isLoader}) {
    return Get.dialog(
      barrierDismissible: !isLoader.value,
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(defaultRadius),
            ),
            padding: const EdgeInsets.only(top: defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                  margin: const EdgeInsets.symmetric(vertical: defaultPadding / 2).copyWith(top: 0),
                  padding: const EdgeInsets.all(defaultPadding),
                  child: const Icon(
                    Icons.logout,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2, horizontal: defaultPadding),
                  child: Text(
                    AppStrings.logoutString,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.all(defaultPadding / 2.5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(.2),
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(defaultRadius)),
                          ),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: isLoader.isFalse ? onTap : null,
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(defaultRadius)),
                          ),
                          padding: const EdgeInsets.all(defaultPadding / 2.5),
                          child: Obx(
                            () => Center(
                              child: isLoader.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14.sp),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to show the Android-style dialog
  static Future<void> materialAppUpdateDialog(BuildContext context, {required VoidCallback onUpdate, required VoidCallback onLater, required RxBool isLoader, required bool isForceUpdate}) async {
    Get.dialog(
      PopScope(
        canPop: false,
        onPopInvoked: (didPop) {},
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Dialog(
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultRadius),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
              padding: const EdgeInsets.only(top: defaultPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                    margin: const EdgeInsets.symmetric(vertical: defaultPadding / 2).copyWith(top: 0),
                    padding: const EdgeInsets.all(defaultPadding),
                    child: SvgPicture.asset(
                      AppAssets.logoSVG,
                      height: 40.h,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2, horizontal: defaultPadding),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: AppTheme.fontFamilyName, height: 1.5),
                        children: [
                          TextSpan(
                            text: "A new version of ",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16, height: 1.5),
                          ),
                          TextSpan(
                            text: "${AppStrings.appName} ",
                            style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor, fontSize: 16),
                          ),
                          TextSpan(
                            text: "is available with important enhancements and bug fixes. Please update to the latest version for the best experience. Click ",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16, height: 1.5),
                          ),
                          TextSpan(
                            text: "'Update' ",
                            style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor, fontSize: 16),
                          ),
                          TextSpan(
                            text: "to get the latest features.",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    children: [
                      isForceUpdate == false
                          ? Expanded(
                              child: InkWell(
                                onTap: onLater,
                                child: Container(
                                  height: 46,
                                  padding: const EdgeInsets.all(defaultPadding / 2.5),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(.2),
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(defaultRadius)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "May be later",
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (isLoader.isFalse) {
                              onUpdate();
                            }
                          },
                          child: Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: isForceUpdate != true
                                  ? const BorderRadius.only(bottomRight: Radius.circular(defaultRadius))
                                  : const BorderRadius.only(
                                      bottomRight: Radius.circular(defaultRadius),
                                      bottomLeft: Radius.circular(defaultRadius),
                                    ),
                            ),
                            padding: const EdgeInsets.all(defaultPadding / 2.5),
                            child: Obx(
                              () => Center(
                                child: isLoader.isTrue
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Text(
                                        "Update",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14.sp),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to show the iOS-style dialog
  static Future<void> cupertinoAppUpdateDialog(BuildContext context, {required VoidCallback onUpdate, VoidCallback? onLater, required RxBool isLoader, required bool isForceUpdate}) async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Update Require'),
          content: Padding(
            padding: const EdgeInsets.only(top: defaultPadding / 3),
            child: Text(
              'We have launched a new and improved app. Please update to continue using the app.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          actions: <Widget>[
            if (isForceUpdate == false)
              CupertinoDialogAction(
                onPressed: onLater,
                isDefaultAction: true,
                child: const Text('Later'),
              ),
            CupertinoDialogAction(
              onPressed: () {
                if (isLoader.isFalse) {
                  onUpdate();
                }
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> videoInstructionDialogueFunction({
    required String title,
    required String assetVideoPath,
    RxBool? loader,
  }) async {
    printYellow(assetVideoPath);
    // Get.dialog();
    Future.delayed(
      const Duration(seconds: 15),
      () => loader?.value = false,
    );
    try {
      loader?.value = true;

      final videoPlayerController = (assetVideoPath.contains("http://") || assetVideoPath.contains("https://")) ? VideoPlayerController.networkUrl(Uri.parse(assetVideoPath)) : VideoPlayerController.asset(assetVideoPath);

      await videoPlayerController.initialize();

      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        allowFullScreen: false,
        showControls: false,
        showOptions: false,
        zoomAndPan: false,
        useRootNavigator: false,
        allowedScreenSleep: false,
        draggableProgressBar: false,
        allowPlaybackSpeedChanging: false,
        allowMuting: false,
        isLive: false,
        showControlsOnInitialize: false,
        aspectRatio: videoPlayerController.value.aspectRatio,
      );

      final playerWidget = ClipRRect(
        borderRadius: BorderRadius.circular(defaultRadius),
        child: Chewie(
          controller: chewieController,
        ),
      );
      loader?.value = false;
      return await showDialog(
        context: Get.context!,
        builder: (context) {
          return videoDialogue(context, widget: playerWidget, title: title, aspectRatio: videoPlayerController.value.aspectRatio ?? 1);
        },
      ).whenComplete(() {
        videoPlayerController.dispose();
        chewieController.dispose();
      });
    } catch (e) {
      loader?.value = true;
    }
  }

  static Widget videoDialogue(
    BuildContext context, {
    required Widget widget,
    required String title,
    required double aspectRatio,
  }) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: defaultPadding / 2),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Get.back();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).primaryColor.withOpacity(0.1),
              ),
            ),
            icon: const Icon(
              Icons.close,
            ),
          )
        ],
      ),
      content: AspectRatio(
        aspectRatio: aspectRatio,
        child: GestureDetector(
          onTap: () {},
          child: widget,
        ),
      ),
    );
  }
}
