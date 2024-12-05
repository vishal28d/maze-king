import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/res/widgets/app_bar.dart';
import 'package:maze_king/res/widgets/pull_to_refresh_indicator.dart';
import 'package:maze_king/views/profile/components/transaction_tile.dart';
import 'package:maze_king/views/profile/widgets/wallet_screen/wallet_screen_controller.dart';

import '../../../../repositories/wallet/wallet_repository.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final WalletScreenController con = Get.put(WalletScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyanBg,
      body: Obx(() {
        return Column(
          children: [
            MyAppBar(
              title: "Wallet",
              showBackIcon: true,
              myAppBarSize: MyAppBarSize.medium,
            ),
            Expanded(
                child: (con.isLoader.value)
                    ? Center(
                        child: UiUtils.appCircularProgressIndicator(),
                      )
                    : PullToRefreshIndicator(
                        onRefresh: () => WalletRepository.getWalletDetailsAPI(isWalletFlow: true, walletType: WalletType.wallet),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(defaultPadding),
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(0, 4), blurRadius: 14),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: Get.width / 3.7,
                                      ),
                                      AppButton(
                                        onPressed: () {
                                          Get.toNamed(
                                            AppRoutes.addCashScreen,
                                            arguments: {
                                              'money': "50",
                                            },
                                          )?.whenComplete(() {
                                            WalletRepository.getWalletDetailsAPI(isWalletFlow: true, walletType: WalletType.wallet);
                                          });
                                        },
                                        title: "Add Cash",
                                        padding: const EdgeInsets.only(bottom: defaultPadding / 2),
                                      ),
                                      Divider(
                                        thickness: 2,
                                        height: 16.h,
                                      ),

                                      /// amount
                                      Row(
                                        children: [
                                          Text(
                                            "Amount Unutilised",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: AppColors.black.withOpacity(0.7),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          // 4.horizontalSpace,
                                          // SvgPicture.asset(AppAssets.iIcon),
                                        ],
                                      ),
                                      4.verticalSpace,
                                      Text(
                                        AppStrings.rupeeSymbol + formatAmount(con.walletModel.value.unUtilized),
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontSize: 14.sp,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Divider(
                                        thickness: 2,
                                        height: 16.h,
                                      ),

                                      /// Winnings withdraw
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Winnings",
                                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                          fontSize: 12.sp,
                                                          color: AppColors.black.withOpacity(0.7),
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                  ),
                                                  4.horizontalSpace,
                                                  // GestureDetector(
                                                  //   onTap: () {},
                                                  //   child: SvgPicture.asset(AppAssets.iIcon),
                                                  // ),
                                                ],
                                              ),
                                              4.verticalSpace,
                                              Text(
                                                AppStrings.rupeeSymbol + formatAmount(con.walletModel.value.winnings),
                                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                      fontSize: 14.sp,
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          ((con.walletModel.value.bankVerified ?? false) && (con.walletModel.value.panCardVerify ?? false))
                                              ? GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(AppRoutes.withdrawScreen)?.whenComplete(() => WalletRepository.getWalletDetailsAPI(isWalletFlow: true, walletType: WalletType.wallet));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(width: 1, color: Theme.of(Get.context!).primaryColor.withOpacity(0.2)),
                                                      borderRadius: BorderRadius.circular(4.r),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 1.3, vertical: defaultPadding / 3),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Withdraw",
                                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                            letterSpacing: .2,
                                                            fontSize: 10.sp,
                                                            color: AppColors.primary,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(AppRoutes.kycDetailScreen, arguments: {'isWithdraw': true})?.whenComplete(() => WalletRepository.getWalletDetailsAPI(isWalletFlow: true, isLoader: con.isLoader, walletType: WalletType.wallet));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(width: 1, color: Theme.of(Get.context!).primaryColor.withOpacity(0.2)),
                                                      borderRadius: BorderRadius.circular(4.r),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 1.3, vertical: defaultPadding / 3),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Verify to Withdraw",
                                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                            letterSpacing: .2,
                                                            fontSize: 10.sp,
                                                            color: AppColors.primary,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),

                                      Divider(
                                        thickness: 2,
                                        height: 16.h,
                                      ),

                                      /// discount
                                      Row(
                                        children: [
                                          Text(
                                            "Discount Bonus",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: AppColors.black.withOpacity(0.7),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          4.horizontalSpace,
                                          // SvgPicture.asset(AppAssets.iIcon),
                                        ],
                                      ),
                                      4.verticalSpace,
                                      Text(
                                        AppStrings.rupeeSymbol + formatAmount(con.walletModel.value.discount),
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontSize: 14.sp,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white,
                                          Color(0xffF1F1FF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(6.r)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(defaultPadding),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Current Balance",
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontSize: 16.sp,
                                                color: AppColors.primary.withOpacity(.7),
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                        10.verticalSpace,
                                        Text(
                                          AppStrings.rupeeSymbol + formatAmount(con.walletModel.value.myBalance),
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontSize: 26.sp,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            16.verticalSpace,
                            TransactionTile(
                              title: "My Transactions",
                              icon: AppAssets.rightArrow,
                              onPressed: () {
                                Get.toNamed(AppRoutes.myTransactionsScreen);
                              },
                            ),
                          ],
                        ),
                      )),

            /// i button detail card
            // Container(
            //   // height: Get.height / 20,
            //   width: Get.width / 2.22,
            //   decoration: BoxDecoration(
            //     color: Colors.blue.shade600,
            //     borderRadius: BorderRadius.circular(4.r),
            //   ),
            //   padding: const EdgeInsets.all(defaultPadding / 3),
            //   child: Column(
            //     children: [
            //       Row(
            //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             "Unused Deposit",
            //             style: Theme.of(context).textTheme.titleLarge?.copyWith(
            //               fontSize: 11.sp,
            //               color: Colors.white,
            //               fontWeight: FontWeight.w400,
            //             ),
            //           ),51.horizontalSpace,
            //           Text(
            //             "${AppStrings.rupeeSymbol}7.71",
            //             style: Theme.of(context).textTheme.titleLarge?.copyWith(
            //               fontSize: 11.sp,
            //               color: Colors.white,
            //               fontWeight: FontWeight.w400,
            //             ),
            //           ),
            //         ],
            //       ),
            //       Row(
            //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             "Discount Points Worth",
            //             style: Theme.of(context).textTheme.titleLarge?.copyWith(
            //               fontSize: 11.sp,
            //               color: Colors.white,
            //               fontWeight: FontWeight.w400,
            //             ),
            //           ),
            //           20.horizontalSpace,
            //           Text(
            //             "${AppStrings.rupeeSymbol}2.19",
            //             style: Theme.of(context).textTheme.titleLarge?.copyWith(
            //               fontSize: 11.sp,
            //               color: Colors.white,
            //               fontWeight: FontWeight.w400,
            //             ),
            //           ),
            //         ],
            //       )
            //     ],
            //   ),
            // )
          ],
        );
      }),
    );
  }
}
