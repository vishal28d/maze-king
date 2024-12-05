import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../exports.dart';

class ContestTimeOutBottomSheet extends StatefulWidget {
  final bool isJoined;
  final Function() onTapOfButton;

  const ContestTimeOutBottomSheet({
    super.key,
    required this.isJoined,
    required this.onTapOfButton,
  });

  @override
  State<ContestTimeOutBottomSheet> createState() => _ContestTimeOutBottomSheetState();
}

class _ContestTimeOutBottomSheetState extends State<ContestTimeOutBottomSheet> {
  RxBool isPop = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopScope(
        canPop: isPop.value,
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultRadius),
              color: Colors.white,
            ),
            child: Column(
              children: [
                (defaultPadding * 1).verticalSpace,
                Text(
                  widget.isJoined ? "Times To Play" : "Deadline Passed!",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                (defaultPadding * 1).verticalSpace,
                const Divider(),
                (defaultPadding / 2).verticalSpace,
                Icon(
                  widget.isJoined ? Icons.play_circle_outline_rounded : Icons.warning_amber_rounded,
                  size: Get.width / 8,
                  color: widget.isJoined ? AppColors.green : AppColors.red,
                ),
                (defaultPadding / 2).verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
                  child: Text(
                    widget.isJoined ? "Its time to play the game, Let's Play" : "You can't join contest for this contest anymore. Select another contest to play.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.subTextColor(context),
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                (defaultPadding * 2).verticalSpace,
                AppButton(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  onPressed: widget.onTapOfButton,
                  title: widget.isJoined ? "PLAY" : "VIEW UPCOMING CONTESTS",
                ),
                (defaultPadding * 2).verticalSpace,
              ],
            ),
          ),
        ),
      );
    });
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
