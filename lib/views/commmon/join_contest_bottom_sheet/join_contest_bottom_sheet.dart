import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../data/models/contest/join_contest_pricing_model.dart';
import '../../../../exports.dart';
import '../../../../repositories/contest/contest_repository.dart';
import '../../../../res/widgets/webview.dart';

class JoinContestBottomSheet extends StatelessWidget {
  final String contestId;
  final String recurringId;
  final num entryFee;
  final JoinContestPricingModel joinContestPricingModel;
  final bool isNavFromDescScreen;

  JoinContestBottomSheet({
    super.key,
    required this.contestId,
    required this.recurringId,
    required this.entryFee,
    required this.joinContestPricingModel,
    required this.isNavFromDescScreen,
  });

  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultRadius),
          color: Colors.white,
        ),
        child: Column(
          children: [
            (defaultPadding / 1.5).verticalSpace,
            Text(
              "CONFIRMATION",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              "Amount Unutilised + Winnings = ${AppStrings.rupeeSymbol}${(joinContestPricingModel.wallet.winnings + joinContestPricingModel.wallet.unUtilized).toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.subTextColor(context),
                    fontWeight: FontWeight.w400,
                  ),
            ),
            (defaultPadding / 2).verticalSpace,
            const Divider(),
            (defaultPadding / 2).verticalSpace,
            priceTile(context, title: "Entry", price: "$entryFee"),
            // priceTile(context, title: "Winnings", price: "${joinContestPricingModel.winning}", prefixText: ""),
            // priceTile(context, title: "UnUtilized Amount", price: "${joinContestPricingModel.unUtilized}", prefixText: ""),
            priceTile(context, title: "Usable Discount Bonus", price: "${joinContestPricingModel.discount}", prefixText: "-"),
            // discountPriceTile(context, title: "Discounted Entry", subTitle: "Max discounted entry auto-applied", price: "50"),
            const Divider(),
            (defaultPadding / 2).verticalSpace,

            priceTile(context, title: "To Pay", price: "${joinContestPricingModel.winning + joinContestPricingModel.unUtilized /*+ joinContestPricingModel.discount*/}", isTitleBold: true, isPriceBold: true),
            (2).verticalSpace,
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "I agree with the standard ",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).textTheme.labelMedium?.color?.withOpacity(0.8),
                      ),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(
                            () => AppWebView(
                              webURL: LocalStorage.termsAndConditionURL.value,
                              title: AppStrings.termAndConditions,
                            ),
                          );
                        },
                      text: AppStrings.termAndConditionShortForm,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            // fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              return AppButton(
                title: "Join Contest",
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                  vertical: defaultPadding,
                ),
                loader: isLoading.value,
                onPressed: () async {
                  /// Join Contest API
                  ContestRepository.joinContestAPI(
                    loader: isLoading,
                    isNavFromDescScreen: isNavFromDescScreen,
                    contestId: contestId,
                    recurringId: recurringId,
                    unUtilized: joinContestPricingModel.unUtilized,
                    winning: joinContestPricingModel.winning,
                    discount: joinContestPricingModel.discount,
                  );
                },
              );
            })
          ],
        ),
      ),
    );
  }

  Widget priceTile(
    BuildContext context, {
    required String title,
    required String price,
    String prefixText = "",
    bool isPriceBold = false,
    bool isTitleBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, bottom: defaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: defaultPadding),
              child: Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).textTheme.titleMedium?.color,
                          fontSize: 14.sp,
                          fontWeight: isTitleBold ? FontWeight.bold : null,
                        ),
                  ),
                  // (defaultPadding / 4).horizontalSpace,
                  // CustomTooltip(
                  //   context,
                  //   message: "HET",
                  //   child: Icon(
                  //     Icons.info_outline_rounded,
                  //     size: 15.sp,
                  //     color: AppColors.subTextColor(context),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: defaultPadding),
              child: Text(
                "$prefixText${AppStrings.rupeeSymbol}$price",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isPriceBold ? FontWeight.bold : null,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget discountPriceTile(
    BuildContext context, {
    required String title,
    required String subTitle,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, bottom: defaultPadding / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: defaultPadding),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600
                              // color: AppColors.subTextColor(context),
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 4),
                          child: SvgPicture.asset(
                            AppAssets.discountSVG,
                            height: 15.sp,
                          ),
                        )
                      ],
                    ),
                    Text(
                      subTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.subTextColor(context),
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
                // (defaultPadding / 4).horizontalSpace,
                // CustomTooltip(
                //   context,
                //   message: "HET",
                //   child: Icon(
                //     Icons.info_outline_rounded,
                //     size: 15.sp,
                //     color: AppColors.subTextColor(context),
                //   ),
                // )
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: defaultPadding),
              child: Text(
                "-${AppStrings.rupeeSymbol}$price",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
