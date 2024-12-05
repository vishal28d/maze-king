import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class EmptyElement extends StatelessWidget {
  final String? svgPath;
  final String? title;
  final double? height;
  final double? imageWidth;
  final double? imageHeight;
  final double? spacing;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment? mainAxis;

  const EmptyElement({
    super.key,
    this.svgPath,
    this.title,
    this.height,
    this.imageWidth,
    this.imageHeight,
    this.spacing,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.mainAxis,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        // height: height ?? Get.height * .4,
        padding: padding ?? const EdgeInsets.only(bottom: defaultPadding),
        child: Column(
          mainAxisAlignment: mainAxis ?? MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgPath?.isNotEmpty ?? false) ...[
              SvgPicture.asset(
                svgPath ?? "AppAssets.emptyDataSvg",
                width: imageWidth ?? Get.width / 1.5,
              ),
              if (spacing != 0.0) SizedBox(height: spacing),
            ],
            if (!isValEmpty(title))
              Text(
                title!,
                textAlign: TextAlign.center,
                style: titleStyle ?? TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
              ),
            const SizedBox(height: defaultPadding / 2),
            if (!isValEmpty(subtitle))
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: subtitleStyle ?? TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
              ),
          ],
        ),
      ),
    );
  }
}
