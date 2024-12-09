import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/res/widgets/app_dialog.dart';

import '../../exports.dart';
import '../../utils/app_datetime_formator.dart';
import '../app_amount_formatter.dart';
import 'gradient_leanear_progress_bar.dart';

class QuadrilateralPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define points of the quadrilateral
    var paint = Paint();

    // Define the gradient
    paint.shader = const LinearGradient(
      colors: [Color(0xff0b0a29), Color(0xff191860), Color(0xff2f2db6)],
      // begin: Alignment.topLeft,
      // end: Alignment.bottomRight,
    ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    // Define the path of the quadrilateral
    Path path = Path();
    path.moveTo(10, 0); // Top-left point
    path.lineTo(size.width, 0); // Top-right point
    path.lineTo(size.width * 0.8, size.height); // Bottom-right point
    path.lineTo(10, size.height); // Bottom-left point
    path.close();

    // Draw the quadrilateral filled with the gradient
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class AppContestWidgets {
  static const double contestPadding = defaultPadding / 1.5;

  /// ***********************************************************************************
  ///                                         COMMON
  /// ***********************************************************************************

  static Widget pricePoolWidget(
    BuildContext context, {
    String? currencySvgPath,
    bool convertInReadableFormat = true,
    required num pricePool,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          currencySvgPath ?? AppAssets.inrGraphicSVG,
          height: 21.sp,
        ),
        Padding(
          padding: const EdgeInsets.only(left: defaultPadding / 2),
          child: Text(
            convertInReadableFormat
                ? AppAmountFormatter.defaultFormatter(pricePool)
                : pricePool.toString(),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700, fontSize: 18.sp),
          ),
        ),
      ],
    );
  }

  static Widget remainingSpotsText(
    BuildContext context, {
    required String? svgPath,
    required int remainingSpots,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isValEmpty(svgPath))
          SvgPicture.asset(
            svgPath!,
            color: Theme.of(context).colorScheme.tertiary,
            height: 12.sp,
          ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: defaultPadding / 4),
            child: Text(
              "$remainingSpots ${AppStrings.spotsLeft}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        )
      ],
    );
  }

  static Widget totalSpotsText(
    BuildContext context, {
    required String? svgPath,
    required int totalSpots,
    MainAxisAlignment? mainAxisAlignment,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.end,
      children: [
        if (!isValEmpty(svgPath))
          SvgPicture.asset(
            svgPath!,
            height: 12.sp,
          ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: defaultPadding / 4),
            child: Text(
              "$totalSpots ${AppStrings.spots}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.subTextColor(context),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        )
      ],
    );
  }

  /// ***********************************************************************************
  ///                                    FREE PRACTICE CONTEST
  /// ***********************************************************************************

  /// TODO
  static Widget freePracticeContest(
  BuildContext context, {
  String? buttonName = "PLAY",
  required Function() onButtonTap,
  required Function() onTapOfContest,
}) {
  return GestureDetector(
    onTap: onTapOfContest,
    child: Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: contestPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultRadius),
        color: Theme.of(context).cardColor,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultRadius),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.tertiary.withOpacity(0.9),
              Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.3, 0.7],
          ),
          image: DecorationImage(
            image: AssetImage(AppAssets.authBgPNG),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.srgbToLinearGamma(),
            opacity: 0.7,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Brain Image at the center
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Image.network(
                "https://gotilo-maze-king.s3.ap-south-1.amazonaws.com/brainfree.png",
                height: 140.0,
                width: 140.0,
                fit: BoxFit.cover,
              ),
            ),

            /// Practice Game text and Play button at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: contestPadding ,
                  vertical: contestPadding+1 ,  
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// Practice Game text
                    Text(
                      "PRACTICE GAME",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).cardColor.withOpacity(0.8),
                          ),
                    ),
                    const Spacer(),

                    /// Play Button
                    AppButton(
                      width: Get.width * 0.18,
                      height: Get.width * 0.075,
                      onPressed: onButtonTap,
                      title: buttonName,
                      titleStyle: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  /// ***********************************************************************************
  ///                                    UPCOMING CONTEST
  //                                 (Default and My Upcoming)
  /// ***********************************************************************************

  /// TODO
  ///

  static Widget upcomingContest(
    BuildContext context, {
    required String pricePoolName,
    required bool isMyMatchContest,
    required num pricePool,
    required num entryFee,
    required String remainingTime,
    required DateTime startTime,
    required int totalSpots,
    required int filledSpots,
    required int remainingSpots,
    String? buttonName = "JOIN",
    bool? isPinned,
    String? contestTitle,
    String? contestImage,
    String? brainImage,
    required Function() onButtonTap,
    required Function() onTapOfContest,
  }) {
    return Stack(
      children: [
        Column(
          children: [
            if (isPinned == true)
              const SizedBox(
                height: 40,
              ),
            GestureDetector(
              onTap: onTapOfContest,
              child: Container(
                margin: const EdgeInsets.only(bottom: contestPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultRadius),
                  color: Theme.of(context).cardColor,
                  image: DecorationImage(
                      image: AssetImage(AppAssets.authBgPNG),
                      fit: BoxFit.cover,
                      opacity: 0.6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width * 0.25,
                          padding: const EdgeInsets.only(
                              top: contestPadding, left: contestPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                pricePoolName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontSize: 13.sp,
                                      color: AppColors.subTextColor(context),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 130.w,
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.timerBgSVG,
                                    width: 130.w,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  Text(
                                    remainingTime,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            fontSize: 12.sp,
                                            color: Theme.of(context).cardColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        isMyMatchContest
                            ? Container(
                                width: Get.width * 0.25,
                                padding: const EdgeInsets.only(
                                    top: contestPadding / 2,
                                    right: contestPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${AppStrings.rupeeSymbol}$entryFee",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontSize: 13.sp,
                                            color:
                                                AppColors.subTextColor(context),
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(width: Get.width * 0.25),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: contestPadding,
                          right: contestPadding,
                          top: isMyMatchContest ? contestPadding / 1.5 : 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          pricePoolWidget(context, pricePool: pricePool),
                          const Spacer(),
                          AppButton(
                            width: Get.width * 0.18,
                            height: Get.width * 0.075,
                            onPressed: onButtonTap,
                            title: isMyMatchContest
                                ? AppStrings.go
                                : "${AppStrings.rupeeSymbol}${AppAmountFormatter.defaultFormatter(entryFee)}",
                            titleStyle: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: contestPadding, vertical: contestPadding),
                      child: GradientProgressIndicator(
                        value: (totalSpots - remainingSpots) / totalSpots,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: contestPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          remainingSpots != 0
                              ? ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth:
                                          (Get.width / 4) - defaultPadding,
                                      maxWidth:
                                          (Get.width / 2) - defaultPadding * 2),
                                  child: remainingSpotsText(context,
                                      remainingSpots: remainingSpots,
                                      svgPath: AppAssets.userFilledSVG),
                                )
                              : const SizedBox(),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: (Get.width / 4) - defaultPadding,
                                maxWidth: (Get.width / 2) - defaultPadding * 2),
                            child: totalSpotsText(context,
                                totalSpots: totalSpots,
                                svgPath: AppAssets.userFilledSVG),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: (contestPadding),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        if (brainImage != null)
          Positioned(
            top: isPinned == true
                ? 60.0
                : 20.0, // Adjusts vertical alignment based on `isPinned`
            left: 0,
            right: 0, // Center horizontally
            child: Align(
              alignment: Alignment.center,
              child: Image.network(
                brainImage,
                height: 75.0,
                width: 75.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        if (isPinned == true)
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              CustomPaint(
                painter: QuadrilateralPainter(),
                child: SizedBox(
                  height: 30,
                  width: Get.width * 0.5,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 60,
                      ),
                      Expanded(
                        child: Text(
                          contestTitle?.toUpperCase() ??
                              "Mega Contest Alert!".toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 8.sp,
                                    color: AppColors.authTitle,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff0b0a29),
                      Color(0xff191860),
                      Color(0xff2f2db6)
                    ],
                  ),
                ),
                child: contestImage != null
                    ? Padding(
                        padding: const EdgeInsets.all(
                            5.0), // Add padding around the image
                        child: ClipOval(
                          child: Image.network(
                            contestImage,
                            height: 30,
                            width:
                                30, // Ensure the width is the same as the height to maintain the circular shape
                            fit: BoxFit
                                .cover, // Cover ensures the image fits within the circular shape
                          ),
                        ),
                      )
                    : Image.asset(
                        AppAssets.demoPinContest,
                        height: 30,
                      ),
              ),
            ],
          ),
        // if (isPinned == true)
        //   Column(
        //     children: [
        //       const SizedBox(
        //         height: 25,
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Image.asset(
        //             AppAssets.pinPng,
        //             height: 30,
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
      ],
    );
  }

  /// ***********************************************************************************
  ///                                    MY LIVE CONTEST
  /// ***********************************************************************************

  /// TODO
  static Widget liveContest(
    BuildContext context, {
    required String pricePoolName,
    required num pricePool,
    required num entryFee,
    required String remainingTime,
    required DateTime startTime,
    // required int totalSpots,
    required int filledSpots,
    required int remainingSpots,
    bool isDisableButton = false,
    required Function() onButtonTap,
    required Function() onTapOfContest,
  }) {
    return GestureDetector(
      onTap: onTapOfContest,
      child: Container(
        margin: const EdgeInsets.only(bottom: contestPadding),
        child: Column(
          children: [
            /// main content
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultRadius),
                color: Theme.of(context).cardColor,
                image: DecorationImage(
                    image: AssetImage(AppAssets.authBgPNG),
                    fit: BoxFit.cover,
                    opacity: 0.6),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width * 0.25,
                        padding: const EdgeInsets.only(
                            top: contestPadding, left: contestPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              pricePoolName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontSize: 13.sp,
                                    color: AppColors.subTextColor(context),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 130.w,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.timerBgSVG,
                                  width: 130.w,
                                  fit: BoxFit.fitWidth,
                                ),
                                Text(
                                  remainingTime,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontSize: 12.sp,
                                          color: Theme.of(context).cardColor),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(width: Get.width * 0.25),
                    ],
                  ),
                  Container(
                    // color: Colors.red,
                    padding: const EdgeInsets.only(
                      left: contestPadding,
                      right: contestPadding,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        pricePoolWidget(context, pricePool: pricePool),
                        const Spacer(),

                        /// Play Button
                        AppButton(
                          width: Get.width * 0.18,
                          height: Get.width * 0.075,
                          disableButton: isDisableButton,
                          onPressed: onButtonTap,
                          title: AppStrings.play.toUpperCase(),
                          titleStyle: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: (contestPadding * 1.5),
                  ),
                ],
              ),
            ),

            /// TODO
            Container(
              margin: const EdgeInsets.symmetric(horizontal: contestPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(defaultRadius),
                  bottomRight: Radius.circular(defaultRadius),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: contestPadding, vertical: contestPadding / 1.5),
                decoration: BoxDecoration(
                  color: AppColors.secondarySubColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(defaultRadius),
                    bottomRight: Radius.circular(defaultRadius),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // color: Colors.red,
                      constraints: BoxConstraints(
                        minWidth: (Get.width / 4) - defaultPadding,
                        maxWidth: (Get.width / 2 -
                            (defaultPadding * 2) -
                            contestPadding * 4),
                      ),
                      child: totalSpotsText(context,
                          totalSpots: filledSpots,
                          svgPath: AppAssets.userFilledSVG,
                          mainAxisAlignment: MainAxisAlignment.start),
                    ),
                    Container(
                      padding: const EdgeInsets.only(),
                      child: Text(
                        "${AppStrings.rupeeSymbol}$entryFee",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 13.sp,
                              color: AppColors.subTextColor(context),
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ***********************************************************************************
  ///                                    MY COMPLETED CONTEST
  /// ***********************************************************************************

  /// TODO
  static Widget completedContest(
    BuildContext context, {
    required String pricePoolName,
    required num pricePool,
    required num entryFee,
    // required String remainingTime,
    required DateTime startTime,
    required int totalSpots,
    required double points,
    required int rank,
    required bool isRefunded,
    num? gameErrorRefund,
    required bool isWon,
    required bool isUnderReview,
    required bool isNotPlayed,
    required num winningAmount,
    // required int remainingSpots,
    required Function() onTapOfContest,
  }) {
    return GestureDetector(
      onTap: onTapOfContest,
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultRadius),
            color: Theme.of(context).cardColor,
          ),
          margin: const EdgeInsets.only(bottom: contestPadding),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultRadius),
              color: AppColors.secondarySubColor,
            ),
            child: Column(
              children: [
                /// Main Widget
                Container(
                  padding: const EdgeInsets.all(contestPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultRadius),
                    color: Theme.of(context).cardColor,
                    image: DecorationImage(
                        image: AssetImage(AppAssets.authBgPNG),
                        fit: BoxFit.cover,
                        opacity: 0.6),
                    // boxShadow: defaultShadow(context),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Container(
                            //   // color: AppColors.green,
                            //   child: pricePoolWidget(
                            //     context,
                            //     pricePool: pricePool,
                            //     convertInReadableFormat: false,
                            //   ),
                            // ),
                            /// contest status
                            if (isUnderReview || isRefunded)
                              Container(
                                decoration: BoxDecoration(
                                  color: (isUnderReview
                                          ? AppColors.secondary
                                          : AppColors.tertiary)
                                      .withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(
                                      defaultRadius / 1.5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding / 1,
                                    vertical: defaultPadding / 3),
                                child: Row(
                                  children: [
                                    tableValue(
                                      context,
                                      isUnderReview
                                          ? AppStrings.inReview
                                          : AppStrings.canceled,
                                      fontColor: AppColors.tertiary,
                                      paddingTop: 0,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: (isUnderReview
                                                ? AppColors.secondary
                                                : AppColors.tertiary),
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    if (isRefunded)
                                      GestureDetector(
                                        onTap: () {
                                          AppDialogs.dashboardCommonDialog(
                                            context,
                                            dialogTitle: "Canceled Contest",
                                            descriptionChild: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: defaultPadding,
                                              ).copyWith(
                                                      bottom: defaultPadding),
                                              child: Text(
                                                AppStrings
                                                    .canceledContestReason,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                            showButton: false.obs,
                                          );
                                        },
                                        child: Container(
                                          // color: Colors.red,
                                          padding: const EdgeInsets.only(
                                              left: defaultPadding / 4),
                                          child: Icon(
                                            Icons.info_outline,
                                            size: 15.w,
                                            color:
                                                AppColors.subTextColor(context)
                                                    .withOpacity(0.3),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            const Spacer(),
                            Text(
                              AppDateFormatter.formatToCustom(
                                  startTime.toIso8601String()),
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      color: AppColors.subTextColor(context)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: contestPadding,
                      ),
                      const Divider(),

                      /// contest details
                      Table(
                        // border: TableBorder.all(color: Colors.black),
                        columnWidths: const {
                          0: FlexColumnWidth(0.4),
                          1: FlexColumnWidth(0.35),
                          2: FlexColumnWidth(0.25),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.top,
                        children: [
                          TableRow(
                            children: [
                              tableTitle(
                                context,
                                pricePoolName,
                              ),
                              tableTitle(context, AppStrings.spots,
                                  textAlign: TextAlign.center),
                              tableTitle(
                                context,
                                AppStrings.entry,
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              tableValue(
                                context,
                                AppStrings.rupeeSymbol +
                                    AppAmountFormatter.defaultFormatter(
                                        pricePool),
                                isHighlighted: true,
                              ),
                              tableValue(context, "$totalSpots",
                                  textAlign: TextAlign.center),
                              tableValue(
                                context,
                                "${AppStrings.rupeeSymbol}$entryFee",
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Sub Widget
                if (!isUnderReview)
                  Container(
                    // margin: const EdgeInsets.symmetric(horizontal: contestPadding),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(defaultRadius),
                        bottomRight: Radius.circular(defaultRadius),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: contestPadding,
                          right: contestPadding,
                          bottom: contestPadding / 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.secondarySubColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(defaultRadius),
                          bottomRight: Radius.circular(defaultRadius),
                        ),
                      ),
                      child:

                          /// contest details
                          Table(
                        // border: TableBorder.all(color: Colors.black),
                        columnWidths: const {
                          0: FlexColumnWidth(0.4),
                          1: FlexColumnWidth(0.35),
                          2: FlexColumnWidth(0.25),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.top,
                        children: [
                          TableRow(
                            children: [
                              tableTitle(
                                context,
                                isWon
                                    ? "You won ${AppStrings.rupeeSymbol}${AppAmountFormatter.defaultFormatter(winningAmount)}"
                                    : isRefunded
                                        ? "Refunded ${AppStrings.rupeeSymbol}${AppAmountFormatter.defaultFormatter(entryFee)}"
                                        : gameErrorRefund != null
                                            ? "Refunded ${AppStrings.rupeeSymbol}${AppAmountFormatter.defaultFormatter(entryFee)}"
                                            : "",
                                fontColor: AppColors.green,
                              ),
                              tableTitle(
                                context,
                                isRefunded
                                    ? ""
                                    : isNotPlayed
                                        ? "Missed Play"
                                        : gameErrorRefund != null
                                            ? "Refunded due to game play issue"
                                            : "$points",
                                textAlign: TextAlign.center,
                                fontColor: isNotPlayed
                                    ? Theme.of(context).colorScheme.error
                                    : null,
                                fontWeight:
                                    isNotPlayed ? FontWeight.w500 : null,
                              ),
                              tableTitle(
                                context,
                                isValZero(rank) ? "" : "#$rank",
                                textAlign: TextAlign.end,
                                isHighlighted: true,
                                fontColor: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                                // paddingTop: defaultPadding / 3,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget tableTitle(
    BuildContext context,
    String title, {
    TextAlign textAlign = TextAlign.start,
    double paddingLeft = 0,
    double paddingRight = 0,
    double? paddingTop,
    Color? fontColor,
    FontWeight? fontWeight,
    bool isHighlighted = false,
  }) {
    return Container(
      // color: AppColors.green,
      padding: EdgeInsets.only(
          top: paddingTop ?? defaultPadding / 2,
          bottom: 0,
          left: paddingLeft,
          right: paddingRight),
      child: Text(
        title,
        textAlign: textAlign,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: fontColor ??
                  (isHighlighted ? null : AppColors.subTextColor(context)),
              fontWeight: fontWeight ??
                  (isHighlighted ? FontWeight.w700 : FontWeight.w400),
            ),
      ),
    );
  }

  static Widget tableValue(
    BuildContext context,
    String title, {
    TextAlign textAlign = TextAlign.start,
    double paddingTop = 0,
    double paddingLeft = 0,
    double paddingRight = 0,
    TextStyle? textStyle,
    Color? fontColor,
    bool isHighlighted = false,
  }) {
    return Container(
      // color: Colors.red,
      padding: EdgeInsets.only(
          top: paddingTop, bottom: 0, left: paddingLeft, right: paddingRight),
      child: Text(
        title,
        textAlign: textAlign,
        style: textStyle ??
            Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                  color: fontColor ??
                      (isHighlighted ? null : AppColors.subTextColor(context)),
                ),
      ),
    );
  }
}
