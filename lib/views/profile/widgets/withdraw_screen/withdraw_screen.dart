import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/repositories/wallet/wallet_repository.dart';
import 'package:maze_king/repositories/withdraw/withdraw_repository.dart';
import 'package:maze_king/res/widgets/app_bar.dart';
import 'package:maze_king/views/profile/widgets/withdraw_screen/withdraw_screen_controller.dart';

class WithdrawScreen extends StatelessWidget {
  WithdrawScreen({super.key});

  final WithdrawScreenController con = Get.put(WithdrawScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyanBg,
      body: Obx(
            () {
          return Column(
            children: [
              MyAppBar(
                title: "Withdraw",
                showBackIcon: true,
                myAppBarSize: MyAppBarSize.medium,
              ),
              Expanded(
                child: con.isLoader.value
                    ? shimmerView()
                    : Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    padding: EdgeInsets.only(bottom: 100.h),
                    children: [
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(0, 4), blurRadius: 14),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding / 1.3).copyWith(top: defaultPadding / 1.8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Your Winnings",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                      fontSize: 14.sp,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    " ${AppStrings.rupeeSymbol + con.walletModel.value.winnings.toString()}",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                      fontSize: 14.sp,
                                      color: AppColors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              10.verticalSpace,
                              FieldTitleWidget(
                                context,
                                title: "Withdraw Amount",
                                titleStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.black, fontWeight: FontWeight.w400),
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                ),
                              ),
                              Obx(() {
                                return AppTextField(
                                  // title: "",
                                  titleStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintText: "Amount",
                                  showError: false,
                                  controller: con.amountCon.value,
                                  fillColor: Colors.white,

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(500),
                                    borderSide: BorderSide(
                                      color: Theme
                                          .of(Get.context!)
                                          .primaryColor
                                          .withOpacity(0.09),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 4.4).copyWith(bottom: defaultPadding / 2),
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2).copyWith(top: defaultPadding / 1.5, right: 0),
                                    child: Text(
                                      AppStrings.rupeeSymbol,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    con.validate();
                                    if (con.debounceTimer?.isActive ?? false) con.debounceTimer?.cancel();
                                    con.debounceTimer = Timer(
                                      const Duration(milliseconds: 500),
                                          () async {
                                        /// API
                                        await WalletRepository.getTdsCalculationDetailsAPI(
                                            isLoader: con.isLoading,
                                            amount: num.tryParse(
                                              con.amountCon.value.text.trim(),
                                            ) ??
                                                0);
                                      },
                                    );
                                  },
                                  suffixIcon: GestureDetector(
                                    onTap: () async {
                                      con.amountCon.value.clear();
                                      con.validate();
                                      await WalletRepository.getTdsCalculationDetailsAPI(
                                          isLoader: con.isLoading,
                                          amount: num.tryParse(
                                            con.amountCon.value.text.trim(),
                                          ) ??
                                              0);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      margin: const EdgeInsets.all(defaultPadding),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 1,
                                          color: AppColors.black.withOpacity(0.8),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: AppColors.black.withOpacity(0.8),
                                        size: 15.sp,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              if (con.amountHasError.value)
                                Text(
                                  con.amountError.value,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.1.sp,
                                    fontWeight: FontWeight.w400,
                                    color: isValEmpty(con.amountCon.value.text)
                                        ? AppColors.black
                                        : ((num.tryParse(con.amountCon.value.text) ?? 0) > con.amount.value)
                                        ? Theme
                                        .of(context)
                                        .colorScheme
                                        .error
                                        : AppColors.black,
                                  ),
                                ),
                              (defaultPadding / 2).verticalSpace,
                              const Divider(),
                              (defaultPadding / 2).verticalSpace,
                              Table(
                                // border: TableBorder.all(color: Colors.black),
                                columnWidths: const {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                },
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                children: [
                                  tableRow(context, key: "Withdrawal Amount:", value: con.tdsDetailsModel.value.withdraw?.toStringAsFixed(2), isHighlighted: true),
                                  tableRow(context, key: "TDS (${con.tdsDetailsModel.value.tdsPercentage ?? 0}%):", value: con.tdsDetailsModel.value.tdsAmount?.toStringAsFixed(2)),
                                  tableRow(context, key: "Round off:", value: ((con.tdsDetailsModel.value.payoutAmount ?? 0) - (con.tdsDetailsModel.value.payoutAmountPoint ?? 0)).toStringAsFixed(2)),
                                  tableRow(context, key: "Receivable Amount:", value: con.tdsDetailsModel.value.payoutAmountPoint?.toStringAsFixed(2), isHighlighted: true),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                       10.verticalSpace,

                      // withdrawal process notification
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 0),
                          child: Text(
                            "The withdrawal process will start in a few days." ,
                            style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                          
                          ),
                        ),
                      ) , 

                      10.verticalSpace,

                      Text(
                        "Send Winnings to",
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      18.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: AppColors.authSubTitle.withOpacity(0.4),
                          ),
                        ),
                        padding: const EdgeInsets.all(defaultPadding / 2),
                        child: Row(
                          children: [
                            Container(
                              height: 46.h,
                              width: 46.h,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: AppColors.whiteSmoke),
                              padding: const EdgeInsets.all(defaultPadding / 1.3),
                              child: SvgPicture.asset(AppAssets.bankOutlineSVG),
                            ),
                            10.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  con.walletModel.value.accountDetails?.bankName ?? "",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                6.verticalSpace,
                                Text(
                                  con.walletModel.value.accountDetails?.accountNumber ?? "",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.black.withOpacity(0.6),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
             
                              ],
                            )
                          ],
                        ),
                      ) ,

                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
      bottomSheet: Obx(() {
        return Container(
          color: AppColors.cyanBg,
          padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2, horizontal: defaultPadding),
          child: con.isLoader.value
              ? ShimmerUtils.shimmer(
            child: ShimmerUtils.shimmerContainer(height: Get.width / 8, borderRadius: defaultRadius * 2),
          )
              : AppButton(
            loader: con.isLoading.value,
            disableButton: con.amountHasError.value,
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            onPressed: () {
              FocusScope.of(context).unfocus();

              WithdrawRepository.withdrawAmountAPI(
                isLoader: con.isLoading,
                amount: num.tryParse(
                  con.amountCon.value.text.trim(),
                ) ??
                    0,
                tdsDetailsModel: con.tdsDetailsModel.value,
              );
            },
            // title: "Withdraw",
            title: "Withdrawal process will start in a few days",
          ),
        );
      }),
    );
  }

  Widget textTile(BuildContext context, String str, {bool isHighlighted = false, TextAlign textAlign = TextAlign.left}) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        str,
        textAlign: textAlign,
        style: Theme
            .of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(
          fontSize: 12.sp,
          // color: color,
          fontWeight: isHighlighted ? FontWeight.w600 : null,
        ),
      ),
    );
  }

  TableRow tableRow(BuildContext context, {required String key, required dynamic value, bool isHighlighted = false}) {
    return TableRow(
      children: [
        textTile(context, key, isHighlighted: isHighlighted),
        textTile(context, AppStrings.rupeeSymbol + (isValEmpty(value) ? "0.00" : value.toString()), isHighlighted: isHighlighted, textAlign: TextAlign.end),
      ],
    );
  }

  Widget shimmerView() {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          defaultPadding.verticalSpace,
          ShimmerUtils.shimmer(
            child: ShimmerUtils.shimmerContainer(height: Get.width / 3, borderRadius: 4.r),
          ),
          defaultPadding.verticalSpace,
          ShimmerUtils.shimmer(
            child: ShimmerUtils.shimmerContainer(height: Get.width / 13, width: Get.width / 2, borderRadius: 4.r),
          ),
          defaultPadding.verticalSpace,
          ShimmerUtils.shimmer(
            child: ShimmerUtils.shimmerContainer(height: Get.width / 8, borderRadius: 4.r),
          ),
        ],
      ),
    );
  }
}
