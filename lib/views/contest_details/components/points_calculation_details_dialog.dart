import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../exports.dart';

class PointsCalculationDetailsDialog extends StatefulWidget {
  final bool isNotPlayed;
  final bool isLoser;
  final num? takenTime;
  final num? totalPoints, gamePoints, timePoints;
  const PointsCalculationDetailsDialog({super.key, this.isNotPlayed = false, this.isLoser = false, this.takenTime, this.totalPoints, this.gamePoints, this.timePoints});

  @override
  State<PointsCalculationDetailsDialog> createState() => _PointsCalculationDetailsDialogState();
}

class _PointsCalculationDetailsDialogState extends State<PointsCalculationDetailsDialog> {
  num get takenTimeInSec => isValEmpty(widget.takenTime) ? 0 : (60 - (widget.takenTime! / 1000000)).round();
  num get myGamePoints => (widget.gamePoints ?? 0) * 0.85;
  num get myTimePoints => (widget.timePoints ?? 0) * 0.15;

  num defaultFloorVal(num? val) => val == null ? 0 : ((val * 100).floor() / 100);

  String defaultStringSpacingForCalc = "                         ";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
          clipBehavior: Clip.antiAlias,
          insetPadding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2, vertical: defaultPadding),
          elevation: 0,
          child: IntrinsicHeight(
              child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Points Calculation",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16.sp),
                    ),
                    AppButton(
                      width: 25.w,
                      height: 25.w,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      // padding: const EdgeInsets.only(bottom: defaultPadding / 2),
                      onPressed: () => Get.back(),
                      child: Center(
                        child: Icon(
                          Icons.clear,
                          size: 18.sp,
                          color: Theme.of(context).cardColor.withOpacity(.8),
                        ),
                      ),
                    ),
                  ],
                ),
                5.verticalSpace,
                const Divider(height: 2),
                5.verticalSpace,

                /// BODY
                if (widget.isNotPlayed || widget.isLoser) highlightMessageView(message: widget.isNotPlayed ? "User has not played the game" : "User has played the game, but not completed it."),
                if (!(widget.isNotPlayed || widget.isLoser)) ...[
                  keyValuePairView(key: "Time Taken", value: "${defaultFloorVal(takenTimeInSec)} sec"),
                  // keyValuePairView(key: "Total Points", value: "${widget.totalPoints ?? 0}"),
                  keyValuePairView(key: "Game Points", value: "${defaultFloorVal(widget.gamePoints ?? 0)}"),
                  keyValuePairView(key: "Time Points", value: "${defaultFloorVal(widget.timePoints ?? 0)}"),
                  15.verticalSpace,
                  keyValuePairView(key: "Total Points", separator: " = ", isValueHighlighted: false, value: "Game Points (85%) + Time Points (15%)"),
                  keyValuePairView(key: defaultStringSpacingForCalc, separator: " = ", isValueHighlighted: false, value: "${defaultFloorVal(widget.gamePoints)} (85%) + ${defaultFloorVal(widget.timePoints)} (15%)"),
                  keyValuePairView(key: defaultStringSpacingForCalc, separator: " = ", isValueHighlighted: false, value: "${defaultFloorVal(myGamePoints)} + ${defaultFloorVal(myTimePoints)}"),
                  keyValuePairView(key: defaultStringSpacingForCalc, separator: " = ", value: defaultFloorVal(defaultFloorVal(myGamePoints) + defaultFloorVal(myTimePoints)).toString()),
                  5.verticalSpace,
                ]
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget keyValuePairView({required String key, required String value, String separator = ":", bool isValueHighlighted = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        keyText("$key$separator "),
        valueText(value, isHighlighted: isValueHighlighted),
      ],
    );
  }

  Widget keyText(text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
    );
  }

  Widget valueText(text, {int? flex, bool isHighlighted = true}) {
    return Flexible(
      flex: flex ?? 1,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isHighlighted ? null : Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Widget highlightMessageView({required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
