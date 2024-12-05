import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/utils/utils.dart';
import '../../exports.dart';
import 'auth_background_widget.dart';

enum MyAppBarSize {
  small,
  medium,
  large,
}

class MyAppBar extends StatelessWidget {
  final String? title;
  final bool isLargeTitle;
  final bool isOrangeBg;
  final String? subTitle;
  final bool centerTitle;
  final double? elevation;
  final double? toolbarHeight;
  final TextStyle? titleStyle;
  final VoidCallback? onTap;
  final VoidCallback? onTapOfBackButton;
  final List<Widget>? actions;
  final MyAppBarSize myAppBarSize;
  final Color? backgroundColor;
  final bool showBackIcon;
  final Widget? leading;
  final Widget? bottomWidget;
  final double? leadingWidth;
  final double? bottomWidgetWidth;
  final double? bottomWidgetHeight;

  MyAppBar({
    super.key,
    this.title,
    this.isLargeTitle = false,
    this.isOrangeBg = false,
    this.subTitle,
    this.titleStyle,
    this.elevation,
    this.toolbarHeight,
    this.onTap,
    this.onTapOfBackButton,
    this.actions,
    this.backgroundColor,
    this.child,
    this.showBackIcon = false,
    this.centerTitle = false,
    this.leading,
    this.bottomWidget,
    this.bottomWidgetWidth,
    this.bottomWidgetHeight,
    this.leadingWidth,
    this.myAppBarSize = MyAppBarSize.large,
  }) : assert(elevation == null || elevation >= 0.0);

  final Widget? child;

  double dPadding = defaultPadding.sp;

  bool _containsTimeLeft(String? subTitle) {
    return subTitle?.contains('Time Left') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).viewPadding.top +
              (myAppBarSize == MyAppBarSize.large
                  ? 90.h
                  : myAppBarSize == MyAppBarSize.medium
                  ? 70.h
                  : 20.h),
          child: AuthSmallBackgroundWidget(
            bgColor: backgroundColor ?? Colors.transparent,
            isOrangeBg: isOrangeBg,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      bottom: isValEmpty(leading) && !showBackIcon
                          ? (dPadding / 1)
                          : 0),
                  width: centerTitle ? Get.width : null,
                  child: Row(
                    children: [
                      if (showBackIcon)
                        GestureDetector(
                          onTap: onTapOfBackButton ?? () => Get.back(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: dPadding / 1.5),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                      if (!isValEmpty(leading))
                        Container(
                          alignment: Alignment.centerLeft,
                          width: leadingWidth ?? Get.width * 0.5,
                          child: leading!,
                        ),
                      if (centerTitle) const Spacer(),
                      if (!isValEmpty(title))
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            left: showBackIcon ? 0 : dPadding,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: Get.width * 0.5,
                              maxWidth: Get.width * 0.7,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: centerTitle
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title!,
                                  textAlign: centerTitle
                                      ? TextAlign.center
                                      : TextAlign.left,
                                  style: titleStyle ??
                                      Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                        color:
                                        Theme.of(context).cardColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: (isLargeTitle ? 25 : 20)
                                            .sp,
                                      ),
                                ),
                                if (!isValEmpty(subTitle))
                                  Row(
                                    mainAxisAlignment: centerTitle
                                        ? MainAxisAlignment.center
                                        : MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        subTitle!,
                                        textAlign: centerTitle
                                            ? TextAlign.center
                                            : TextAlign.left,
                                        style: titleStyle ??
                                            Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                              color: Theme.of(context)
                                                  .cardColor
                                                  .withOpacity(0.75),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11.sp,
                                            ),
                                      ),

                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      if (centerTitle) ...[
                        const Spacer(),
                        Container(
                          width: 50.w,
                        )
                      ]
                    ],
                  ),
                ),
                const Spacer(),
                if (!isValEmpty(actions)) ...actions!,
              ],
            ),
          ),
        ),
        if (!isValEmpty(bottomWidget))
          Container(
            alignment: Alignment.bottomCenter,
            width: bottomWidgetWidth,
            height: bottomWidgetHeight ??
                ((MediaQuery.of(context).viewPadding.top +
                    (myAppBarSize == MyAppBarSize.large
                        ? 90.h
                        : myAppBarSize == MyAppBarSize.medium
                        ? 70.h
                        : 20.h)) +
                    20.h),
            child: bottomWidget,
          ),
      ],
    );
  }
}
Widget appBarActionButton({
  required String svgIconPath,
  required Function() onTap,
  EdgeInsetsGeometry? padding,
  double? leftPadding,
  double? rightPadding,
}) {
  return Padding(
    padding: padding ?? EdgeInsets.only(bottom: defaultPadding / 2, left: leftPadding ?? defaultPadding, right: rightPadding ?? defaultPadding),
    child: GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: SvgPicture.asset(
        svgIconPath,
        height: 34.h,
        alignment: Alignment.topCenter,
      ),
    ),
  );
}