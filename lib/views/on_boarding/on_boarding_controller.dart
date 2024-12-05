import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../exports.dart';

class OnBoardingController extends GetxController {
  Rx<PageController> pageController = PageController().obs;
  RxInt currentPageIndex = 1.obs;
  RxList<Map<String, dynamic>> introDataList = <Map<String, dynamic>>[
    {
      "title": "Welcome to Gotilo Maze King",
      "subTitle": "Ready to start winning? Swipe left to learn the basics of fantasy sport.",
      // "webDocUrl": null,
      "imageUrl": AppAssets.onboarding1PNG,
    },
    {
      "title": "Join Contests",
      "subTitle": "Compete with other Gotilo Maze King players for big rewards.",
      // "webDocUrl": null,
      "imageUrl": AppAssets.onboarding2PNG,
    },
    {
      "title": "Completed Game",
      "subTitle": "Use your skills to pick the right players and earn fantasy points.",
      // "webDocUrl": null,
      "imageUrl": AppAssets.onboarding3PNG,
    },
    {
      "title": "Free Practice Game",
      "subTitle": "Practice the game at free of cost!",
      // "webDocUrl": null,
      "imageUrl": AppAssets.onboarding4PNG,
    },
    {
      "title": "Game Points System",
      "subTitle": "How game points are calculated. Detailed documentation you can refer.",
      // "webDocUrl": null,
      "imageUrl": AppAssets.onboarding5PNG,
    },
    {
      "title": "How To Play",
      "subTitle": "Checkout detailed information ",
      "webDocUrlTitle": "How To Play",
      "webDocUrl": LocalStorage.howToPlayURL.value,
      "imageUrl": AppAssets.onboarding6PNG,
    },
  ].obs;
}
