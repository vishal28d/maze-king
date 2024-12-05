import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/res/widgets/auth_background_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../res/widgets/webview.dart';
import 'on_boarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});

  final OnBoardingController con = Get.put(OnBoardingController());

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundWidget(
      child: Obx(() {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: UiUtils.systemUiOverlayStyle(isReverse: true),
            actions: [
              if (currentLastIndex)
                TextButton(
                  onPressed: () {
                    nextNavigation();
                  },
                  child: Row(
                    children: [
                      Text(
                        "Skip",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.authSubTitle),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14.sp,
                        color: AppColors.authSubTitle,
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: defaultPadding / 4),
            ],
          ),
          body: Obx(
            () => Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  itemCount: con.introDataList.length,
                  controller: con.pageController.value,
                  itemBuilder: (context, index) {
                    return boardingPageTile(
                      context,
                      title: con.introDataList[index]["title"],
                      subTitle: con.introDataList[index]["subTitle"],
                      imageUrl: con.introDataList[index]["imageUrl"],
                      webDocUrlTitle: con.introDataList[index]["webDocUrlTitle"],
                      webDocUrl: con.introDataList[index]["webDocUrl"],
                    );
                  },
                  onPageChanged: (pageIndex) {
                    con.currentPageIndex.value = (pageIndex + 1);
                  },
                ),
                IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SmoothPageIndicator(
                        controller: con.pageController.value,
                        count: con.introDataList.length,
                        effect: ExpandingDotsEffect(
                          dotWidth: 07.5.sp,
                          dotHeight: 07.5.sp,
                          activeDotColor: Theme.of(context).colorScheme.secondary,
                          dotColor: /*con.currentPageIndex.value == 6 ? Theme.of(context).primaryColor.withOpacity(0.1) :*/ Theme.of(context).cardColor,
                        ),
                      ),
                      Hero(
                        tag: "heroButton",
                        child: AppButton(
                          title: currentLastIndex ? "Next" : "Get Stated",
                          padding: const EdgeInsets.symmetric(horizontal: defaultPadding).copyWith(top: defaultPadding.h + 5, bottom: bottomPadding(context)),
                          onPressed: () {
                            if (!currentLastIndex) {
                              nextNavigation();
                            } else {
                              con.pageController.value.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastEaseInToSlowEaseOut,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  bool get currentLastIndex {
    return con.introDataList.length != con.currentPageIndex.value;
  }

  VoidCallback get nextNavigation {
    return () {
      Get.offAndToNamed(AppRoutes.mobileAuthScreen);
    };
  }

  double bottomPadding(BuildContext context) => MediaQuery.of(context).padding.bottom + (defaultPadding.h) * 2;

  Widget boardingPageTile(context, {required String imageUrl, required String title, required String subTitle, String? webDocUrlTitle, String? webDocUrl}) {
    final OnBoardingController con = Get.find<OnBoardingController>();

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding).copyWith(top: defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                defaultPadding.verticalSpace,
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 24, color: AppColors.authTitle),
                ),
                13.verticalSpace,
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: subTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.authSubTitle),
                    children: [
                      if (!isValEmpty(webDocUrlTitle))
                        TextSpan(
                            text: webDocUrlTitle,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.authSubTitle, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (!isValEmpty(webDocUrl)) {
                                  Get.to(
                                    () => AppWebView(
                                      webURL: webDocUrl!,
                                      title: webDocUrlTitle,
                                    ),
                                  );
                                }
                              }),
                    ],
                  ),
                ).paddingSymmetric(horizontal: Get.width * 0.1),
                /*Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.authSubTitle),
                ).paddingSymmetric(horizontal: Get.width * 0.1),*/
              ],
            ),
          ),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              foregroundDecoration: BoxDecoration(
                gradient: con.currentPageIndex.value == 1 || con.currentPageIndex.value == 5 /* || con.currentPageIndex.value == 6*/
                    ? null
                    : LinearGradient(
                        end: Alignment.bottomCenter,
                        begin: Alignment.center,
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(.0),
                          Theme.of(context).primaryColor.withOpacity(.8),
                          Theme.of(context).primaryColor.withOpacity(1),
                          Theme.of(context).primaryColor.withOpacity(1),
                        ],
                      ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                ),
                child: Image.asset(
                  imageUrl,
                  alignment: con.currentPageIndex.value == 1 ? Alignment.center : Alignment.center,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
