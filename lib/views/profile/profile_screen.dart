import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/res/widgets/webview.dart';
import 'package:maze_king/views/profile/components/profile_detail_app_bar.dart';
import 'package:maze_king/views/profile/profile_controller.dart';

import '../../data/api/api_utils.dart';
import '../../data/models/wallet/wallet_model.dart';
import '../../repositories/wallet/wallet_repository.dart';
import '../../res/widgets/app_dialog.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController con = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent.withOpacity(0.08),
      body: Obx(() {
        return Column(
          children: [
            ProfileDetailAppBar(
              title: "${LocalStorage.userName}",
              subTitle: "${LocalStorage.userMobile}",
              imgUrl: "${LocalStorage.userImage}",
            ),
            Expanded(
              child: ListView(
                physics: const RangeMaintainingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 0).copyWith(bottom: defaultPadding),
                children: [
                  Container(
                    margin: const EdgeInsets.all(defaultPadding).copyWith(bottom: 0),
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: AppColors.authSubTitle.withOpacity(0.4),
                      ),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.walletScreen);
                          },
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.walletOutlinedSVG,
                                  color: AppColors.primary,
                                ),
                                10.horizontalSpace,
                                Text(
                                  "My Balance",
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const Spacer(),
                                Text(
                                  AppStrings.rupeeSymbol + formatAmount(LocalStorage.myBalance.value),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.tertiary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                )
                              ],
                            ),
                          ),
                        ),
                        12.verticalSpace,
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: amountButton(
                                context,
                                title: "Withdraw",
                                loader: con.isWithdrawButtonLoading,
                                onPressed: () async {
                                  WalletModel? walletModel = await WalletRepository.getWalletDetailsAPI(isLoader: con.isWithdrawButtonLoading);
                                  if (walletModel != null && walletModel.accountDetails?.accountNumber != null && (walletModel.panCardVerify ?? false) && (walletModel.profileVerified ?? false)) {
                                    Get.toNamed(AppRoutes.withdrawScreen);
                                  } else {
                                    bool bankVerified = walletModel?.bankVerified ?? false;
                                    bool panCardVerify = walletModel?.panCardVerify ?? false;
                                    bool profileVerified = walletModel?.profileVerified ?? false;

                                    String getMessage(bool var1, bool var2, bool var3) {
                                      String msg1 = "complete profile details";
                                      String msg2 = "add bank details";
                                      String msg3 = "complete KYC";
                                      return "Please ${!var1 ? '$msg1${!var1 ? ', ' : ''}' : ''}${!var2 ? '$msg2${!var3 ? ', ' : ''}' : ''}${!var3 ? msg3 : ''} first";
                                    }

                                    String msg = getMessage(profileVerified, bankVerified, panCardVerify);
                                    UiUtils.toast(msg, toastLength: Toast.LENGTH_LONG);
                                  }
                                },
                              ),
                            ),
                            defaultPadding.horizontalSpace,
                            Expanded(
                              child: amountButton(
                                context,
                                title: "Add Cash",
                                loader: con.addCashLoader,
                                onPressed: () {
                                  initApiCall() async {
                                    WalletModel? walletModel = await WalletRepository.getWalletDetailsAPI(isLoader: con.addCashLoader);
                                    // await Future.delayed(const Duration(seconds: 2));
                                    if (walletModel != null && (walletModel.profileVerified ?? false)) {
                                      Get.toNamed(
                                        AppRoutes.addCashScreen,
                                        arguments: {
                                          'money': "100",
                                        },
                                      );
                                    } else if (walletModel == null) {
                                      UiUtils.toast("Please try later");
                                    } else {
                                      String msg = "Please complete profile details first from My Info & Settings";
                                      UiUtils.toast(msg);
                                    }
                                  }

                                  initApiCall();
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  15.verticalSpace,
                  detailTile(
                    context,
                    title: "My Info & Settings",
                    icon: AppAssets.settingOutlineSVG,
                    topRadius: true,
                    onPressed: () {
                      Get.toNamed(AppRoutes.myInfoAndSettingScreen);
                    },
                  ),
                  detailTile(
                    context,
                    title: "Refer & Earn",
                    icon: AppAssets.referAndEarnOutlineSVG,
                    onPressed: () {
                      Get.toNamed(AppRoutes.referAndEarnScreen);
                    },
                  ),
                  detailTile(
                    context,
                    title: "Bank & KYC Details",
                    icon: AppAssets.bankOutlineSVG,
                    bottomRadius: true,
                    onPressed: () {
                      Get.toNamed(AppRoutes.kycDetailScreen);
                    },
                  ),
                  15.verticalSpace,
                  detailTile(
                    context,
                    title: "Help & Support",
                    icon: AppAssets.helpAndSupportOutlineSVG,
                    topRadius: true,
                    onPressed: () {
                      Get.to(
                        () => AppWebView(
                          webURL: LocalStorage.contactUsURL.value,
                          title: "Help & Support",
                        ),
                      );
                    },
                  ),
                  detailTile(
                    context,
                    title: "More",
                    icon: AppAssets.moreRoundedSVG,
                    onPressed: () {
                      Get.toNamed(AppRoutes.moreScreen);
                    },
                  ),
                  detailTile(
                    context,
                    title: "Log Out",
                    icon: AppAssets.logOutOutlineSVG,
                    bottomRadius: true,
                    onPressed: () {
                      AppDialogs.logoutDialog(context, onTap: () {
                        ApiUtils.logoutAndClean(loader: con.isLoading);
                      }, isLoader: con.isLoading);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget amountButton(BuildContext context, {required String title, required RxBool loader, required VoidCallback onPressed}) {
    return InkWell(
      onTap: (loader.value) ? () {} : onPressed,
      child: Ink(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.r),
            color: AppColors.whiteSmoke,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: loader.isTrue ? 7.h : 11.h, horizontal: defaultPadding.w),
          child: !loader.isTrue
              ? Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                )
              : SizedBox(
                  height: 14.sp + 11.h,
                  child: const CircularLoader(
                    padding: EdgeInsets.zero,
                  ),
                ),
        ),
      ),
    );
  }

  Widget detailTile(BuildContext context, {required String title, required String icon, final bool topRadius = false, final bool bottomRadius = false, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: AppColors.authSubTitle.withOpacity(0.4),
          ),
          borderRadius: topRadius
              ? BorderRadius.vertical(
                  top: Radius.circular(10.r),
                )
              : (bottomRadius)
                  ? BorderRadius.vertical(
                      bottom: Radius.circular(10.r),
                    )
                  : const BorderRadius.vertical(
                      bottom: Radius.circular(0),
                    ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14.h).copyWith(right: 12.h),
              child: SvgPicture.asset(icon),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
