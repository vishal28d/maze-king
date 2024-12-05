import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/repositories/auth/auth_repository.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/res/widgets/app_bar.dart';
import 'package:maze_king/res/widgets/app_dialog.dart';
import 'package:maze_king/views/profile/widgets/more_screen/more_screen_controller.dart';

import '../../../../data/api/api_utils.dart';
import '../../../../res/widgets/webview.dart';

class MoreScreen extends StatelessWidget {
  MoreScreen({super.key});

  final MoreScreenController con = Get.put(MoreScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyanBg,
      body: Column(
        children: [
          MyAppBar(
            title: "More",
            myAppBarSize: MyAppBarSize.medium,
            showBackIcon: true,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const RangeMaintainingScrollPhysics(),
              children: [
                moreTile(
                  context,
                  title: "Community Guidelines",
                  icon: AppAssets.guidelinesSVG,
                  onPressed: () {
                    Get.to(() => AppWebView(
                          webURL: LocalStorage.communityGuidelinesURL.value,
                          title: "Community Guidelines",
                        ));
                  },
                ),
                moreTile(
                  context,
                  title: "How to Play",
                  icon: AppAssets.gameControllerSVG,
                  onPressed: () {
                    Get.to(() => AppWebView(
                          webURL: LocalStorage.howToPlayURL.value,
                          title: "How to Play",
                        ));
                  },
                ),
                moreTile(
                  context,
                  title: "Responsible Play",
                  icon: AppAssets.responsiblePlaySVG,
                  onPressed: () {
                    Get.to(() => AppWebView(
                          webURL: LocalStorage.responsiblePlayURL.value,
                          title: "Responsible Play",
                        ));
                  },
                ),
                moreTile(
                  context,
                  title: "About Us",
                  icon: AppAssets.aboutUsSVG,
                  onPressed: () {
                    Get.to(() => AppWebView(
                          webURL: LocalStorage.aboutUsURL.value,
                          title: "About Us",
                        ));
                  },
                ),
                moreTile(
                  context,
                  title: "Game Points System",
                  icon: AppAssets.gameControllerSVG,
                  onPressed: () {
                    Get.to(() => AppWebView(
                          webURL: LocalStorage.pointsSystemURL.value,
                          title: "Game Points System",
                        ));
                  },
                ),
                moreTile(
                  context,
                  title: "Legality",
                  icon: AppAssets.legalitySVG,
                  onPressed: () {
                    Get.to(() => AppWebView(
                          webURL: LocalStorage.legalityURL.value,
                          title: "Legality",
                        ));
                  },
                ),
                moreTile(
                  context,
                  title: AppStrings.termAndConditions,
                  icon: AppAssets.termsAndConditionSVG,
                  onPressed: () {
                    Get.to(() => AppWebView(
                          webURL: LocalStorage.termsAndConditionURL.value,
                          title: "Terms And Conditions",
                        ));
                  },
                ),
                moreTile(
                  context,
                  title: AppStrings.deleteAccount,
                  icon: AppAssets.deleteAccountSVG,
                  onPressed: () {
                    AppDialogs.dashboardCommonDialog(
                      context,
                      dialogTitle: AppStrings.deleteAccount,
                      buttonTitle: 'Delete',
                      showButton: RxBool(true),
                      buttonLoader: con.deleteAccountLoader,
                      descriptionChild: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
                        child: Text("Are you sure? you want to delete your account. Your all data will be erased."),
                      ),
                      barrierDismissible: con.deleteAccountLoader,
                      buttonOnTap: () {
                        AuthRepository.deleteAccountAPI(
                          loader: con.deleteAccountLoader,
                          onSuccess: () {
                            ApiUtils.logoutWithoutAPI();
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget moreTile(BuildContext context, {required String title, required String icon, VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding).copyWith(bottom: 0),
      child: InkWell(
        splashColor: Colors.white70,
        borderRadius: BorderRadius.circular(10.r),
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                width: 1,
                color: AppColors.authSubTitle.withOpacity(0.4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 1.2, vertical: defaultPadding),
            child: Row(
              children: [
                SvgPicture.asset(icon),
                14.horizontalSpace,
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                      ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
