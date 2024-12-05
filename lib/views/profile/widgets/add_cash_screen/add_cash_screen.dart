import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/res/widgets/app_bar.dart';
import 'package:maze_king/res/widgets/webview.dart';
import 'package:maze_king/views/profile/widgets/add_cash_screen/add_cash_screen_controller.dart';
import '../../../../exports.dart';
import '../../../../repositories/add_cash/add_cash_repository.dart';
import '../../../../repositories/wallet/wallet_repository.dart';

class AddCashScreen extends StatelessWidget {
  AddCashScreen({super.key});

  final AddCashScreenController con = Get.put(AddCashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        return Column(
          children: [
            MyAppBar(
              title: "Add Cash",
              showBackIcon: true,
              myAppBarSize: MyAppBarSize.medium,
            ),
            Expanded(
              child: con.isLoader.value
                  ? shimmerView()
                  : ListView(
                      physics: const RangeMaintainingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        AnimatedContainer(
                          padding: const EdgeInsets.all(defaultPadding),
                          duration: const Duration(milliseconds: 200),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  con.allCurrentBalDetails();
                                },
                                child: Container(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Current Balance",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 14.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          8.horizontalSpace,
                                          SvgPicture.asset(
                                            con.isCurrentBalDetails.value ? AppAssets.upArrow : AppAssets.dropArrowSVG,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        AppStrings.rupeeSymbol + formatAmount(con.walletModel.value.myBalance),
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontSize: 14.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (con.isCurrentBalDetails.value)
                                Column(
                                  children: [
                                    10.verticalSpace,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Amount Unutilised",
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontSize: 12.sp,
                                                color: Colors.black.withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                        Text(
                                          AppStrings.rupeeSymbol + formatAmount(con.walletModel.value.unUtilized),
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontSize: 12.sp,
                                                color: Colors.black.withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ],
                                    ),
                                    8.verticalSpace,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Winnings",
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontSize: 12.sp,
                                                color: Colors.black.withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                        Text(
                                          AppStrings.rupeeSymbol + formatAmount(con.walletModel.value.winnings),
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontSize: 12.sp,
                                                color: Colors.black.withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ],
                                    ),
                                    8.verticalSpace,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Discount Bonus",
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontSize: 12.sp,
                                                color: Colors.black.withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                        Text(
                                          AppStrings.rupeeSymbol + formatAmount(con.walletModel.value.discount),
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontSize: 12.sp,
                                                color: Colors.black.withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: defaultPadding,
                          endIndent: defaultPadding,
                        ),
                        10.verticalSpace,
                        AppTextField(
                          title: "Amount to Add",
                          titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                          hintText: "Enter Amount",
                          showError: con.cashHasError.value,
                          errorMessage: con.cashError.value,
                          controller: con.cashCon.value,
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          padding: const EdgeInsets.all(defaultPadding).copyWith(top: 0),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter((con.maxCashDepositAmount.value.toString().length * 1.5).toInt()),
                          ],
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2).copyWith(top: defaultPadding / 1.5, right: 0),
                            child: Text(
                              AppStrings.rupeeSymbol,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          onChanged: (val) {
                            if (con.cashCon.value.text.isNotEmpty) {
                              con.cashAmount.value = val;
                              printOkStatus(con.cashAmount.value);
                            }
                            con.validate();
                          },
                          suffixIcon: GestureDetector(
                            onTap: () {
                              con.cashCon.value.clear();
                              con.validate();
                              con.cashAmount.value = "0";
                            },
                            child: Container(
                              margin: const EdgeInsets.all(defaultPadding),
                              padding: const EdgeInsets.all(2),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                          child: Row(
                            children: List.generate(
                              3,
                              (index) => GestureDetector(
                                onTap: () {
                                  con.cashCon.value.text = con.amounts[index].toString();
                                  con.cashAmount.value = con.amounts[index].toString();

                                  con.validate();
                                },
                                child: Ink(
                                  child: Container(
                                    height: Get.width / 10,
                                    width: Get.width / 3.55,
                                    margin: index == 0
                                        ? const EdgeInsets.symmetric(horizontal: defaultPadding / 1.5).copyWith(left: 0)
                                        : index == 2
                                            ? const EdgeInsets.symmetric(horizontal: defaultPadding / 1.5).copyWith(left: 0, right: 0)
                                            : const EdgeInsets.symmetric(horizontal: defaultPadding / 1.5).copyWith(left: 0),
                                    decoration: BoxDecoration(
                                      // color: Theme.of(context).cardColor,
                                      border: Border.all(width: 1, color: Theme.of(Get.context!).primaryColor.withOpacity(0.14)),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${AppStrings.rupeeSymbol}${con.amounts[index]}",
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontSize: 12.sp,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Container(
                            padding: const EdgeInsets.all(defaultPadding).copyWith(top: defaultPadding / 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(width: 1, color: Theme.of(Get.context!).primaryColor.withOpacity(0.14)),
                            ),
                            child: Column(
                              children: [
                                2.verticalSpace,
                                GestureDetector(
                                  onTap: () {
                                    con.allAddBalDetails();
                                  },
                                  child: Container(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Add to Current Balance",
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontSize: 14.sp,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${AppStrings.rupeeSymbol}${formatAmount(con.cashAmount.value)}",
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontSize: 14.sp,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        4.horizontalSpace,
                                        Container(
                                          height: 20.w,
                                          width: 20.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(.04),
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            (con.isAddBalDetails.value) ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                            color: AppColors.primary,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                if (con.isAddBalDetails.value)
                                  Column(
                                    children: [
                                      Divider(
                                        thickness: 2,
                                        height: 16.h,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Deposit Amount (excl. Govt. Tax)",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          4.horizontalSpace,
                                          Container(
                                            height: 16.w,
                                            width: 18.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(.04),
                                              // borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "A",
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                    fontSize: 10.sp,
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${AppStrings.rupeeSymbol}${formatAmount(num.parse(con.cashAmount.value) - (num.parse(con.cashAmount.value) - (num.parse(con.cashAmount.value) * (100 / (100 + 28)))))}",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: AppColors.green,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ],
                                      ),
                                      8.verticalSpace,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Govt.Tax (28% GST)",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          Text(
                                            "${AppStrings.rupeeSymbol}${formatAmount(num.parse(con.cashAmount.value) - (num.parse(con.cashAmount.value) * (100 / (100 + 28))))} ",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 2,
                                        height: 16.h,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          Text(
                                            "${AppStrings.rupeeSymbol}${formatAmount(num.parse(con.cashAmount.value))}",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ],
                                      ),
                                      8.verticalSpace,
                                      Row(
                                        children: [
                                          SvgPicture.asset(AppAssets.discountPercentGraphicIcon),
                                          4.horizontalSpace,
                                          Text(
                                            "Discount Points Worth",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          4.horizontalSpace,
                                          Container(
                                            height: 16.w,
                                            width: 18.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(.04),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "B",
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                    fontSize: 10.sp,
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${AppStrings.rupeeSymbol}${formatAmount(num.parse(con.cashAmount.value) - (num.parse(con.cashAmount.value) * (100 / (100 + 28))))}",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: AppColors.green,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 2,
                                        height: 16.h,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Add to Current Balance",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 13.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          4.horizontalSpace,
                                          Container(
                                            height: 16.w,
                                            width: 18.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(.04),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "A",
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                    fontSize: 10.sp,
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                          4.horizontalSpace,
                                          Text(
                                            "+",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          4.horizontalSpace,
                                          Container(
                                            height: 16.w,
                                            width: 18.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(.04),
                                              // borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "B",
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                    fontSize: 10.sp,
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${AppStrings.rupeeSymbol}${formatAmount(num.parse(con.cashAmount.value))}",
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontSize: 13.sp,
                                                  color: AppColors.green,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ),
                        100.verticalSpace,
                      ],
                    ),
            ),
          ],
        );
      }),
      bottomSheet: Obx(
        () {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(defaultPadding),
            child: AppButton(
              loader: con.isLoader.value,
              disableButton: con.cashHasError.value,
              padding: const EdgeInsets.symmetric(
                vertical: defaultPadding,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();

                /// CREATE PAYMENT INTENT BY API
                await AddCashRepository().createPaymentIntentOfBusttoPgAPI(isLoader: con.isLoader, amount: double.parse(con.cashAmount.value)).then(
                  (response) {
                    if (response != null) {
                      /// DO PAYMENT BY BUSTTO PG
                      printOkStatus("${response.paymentUrl}");
                      Get.to(() => AppWebView(
                            title: "Add Cash",
                            webURL: response.paymentUrl ?? "",
                            closeWebViewText: response.closeUrl ?? "",
                          ))?.whenComplete(() async {
                        await WalletRepository.getWalletDetailsAPI(isLoader: con.isLoader, walletType: WalletType.addCash);
                        Get.back();
                      });
                      // con.addCashPaymentBusttoPG(loader: con.isLoader,  : response, amount: response?['amount'], mobileNumber: LocalStorage.userMobile.value);
                    } else {
                      UiUtils.toast("Please try again!");
                    }
                  },
                );

                /*/// PHASE 1
                await AddCashRepository().createOrderAPI(isLoader: con.isLoader, amount: double.parse(con.cashAmount.value)).then(
                  (response) {
                    con.addCashPayment(loader: con.isLoader, orderId: response?['orderId'], amount: response?['amount'], mobileNumber: LocalStorage.userMobile.value);
                  },
                );*/
              },
              title: "Add ${AppStrings.rupeeSymbol + formatAmount(num.parse(con.cashAmount.value))}",
            ),
          );
        },
      ),
    );
  }

  Widget shimmerView() {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Row(
            children: [
              ShimmerUtils.shimmer(
                child: ShimmerUtils.shimmerContainer(height: 14.h, width: Get.width / 3.4, borderRadius: 2.r),
              ),
              4.horizontalSpace,
              ShimmerUtils.shimmer(
                child: ShimmerUtils.shimmerContainer(height: 14.h, width: 14.h, borderRadius: 2.r),
              ),
              const Spacer(),
              ShimmerUtils.shimmer(
                child: ShimmerUtils.shimmerContainer(height: 14.h, width: Get.width / 5.4, borderRadius: 2.r),
              ),
            ],
          ),
          defaultPadding.verticalSpace,
          ShimmerUtils.shimmer(
            child: ShimmerUtils.shimmerContainer(height: Get.width / 7, borderRadius: 4.r),
          ),
          defaultPadding.verticalSpace,
          Row(
            children: [
              Expanded(
                child: ShimmerUtils.shimmer(
                  child: ShimmerUtils.shimmerContainer(height: Get.width / 12, borderRadius: 4.r),
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: ShimmerUtils.shimmer(
                  child: ShimmerUtils.shimmerContainer(height: Get.width / 12, borderRadius: 4.r),
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: ShimmerUtils.shimmer(
                  child: ShimmerUtils.shimmerContainer(height: Get.width / 12, borderRadius: 4.r),
                ),
              ),
            ],
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
