import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';

import '../../../../../data/models/transaction_history/contest_transaction/contest_transaction_model.dart';
import '../widgets/contests_screen_controller/contests_screen_controller.dart';

class ContestsTransactionDetailTile extends StatelessWidget {
  final int index;
  final bool topRadius;
  final bool bottomRadius;
  final String amount;
  final DateTime? dateTime;
  final ContestTransactionType contestTransactionType;
  final JoinDetails? joinDetails;

  ContestsTransactionDetailTile({
    super.key,
    required this.index,
    this.joinDetails,
    this.bottomRadius = false,
    this.topRadius = false,
    this.amount = '',
    this.dateTime,
    this.contestTransactionType = ContestTransactionType.entryPaid,
  });

  BorderSide borderSide({double? width}) => BorderSide(
        width: width ?? 1,
        color: AppColors.authSubTitle.withOpacity(0.4),
      );
  final ContestsScreenController con = Get.find<ContestsScreenController>();

  int get lastIndex => con.contestTransactionList.length - 1;

  bool get showBottomSeparateLine => (con.contestTransactionList[index + 1].id != con.contestTransactionList[index].id);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: (index == 0) ? borderSide() : BorderSide.none,
          bottom: index == lastIndex
              ? borderSide(width: 1)
              : showBottomSeparateLine
                  ? borderSide(width: 2)
                  : borderSide(width: 0.4),
          left: borderSide(),
          right: borderSide(),
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 45.h,
                width: 45.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: (contestTransactionType == ContestTransactionType.winning)
                      ? Colors.tealAccent.withOpacity(0.17)
                      : contestTransactionType == ContestTransactionType.entryPaid
                          ? Colors.pinkAccent.withOpacity(0.1)
                          : contestTransactionType == ContestTransactionType.refund || contestTransactionType == ContestTransactionType.gameError
                              ? Colors.greenAccent.withOpacity(0.1)
                              : Colors.deepPurpleAccent.withOpacity(0.1),
                ),
                margin: const EdgeInsets.all(defaultPadding / 2).copyWith(right: defaultPadding),
                padding: const EdgeInsets.all(defaultPadding / 1.5).copyWith(top: contestTransactionType == ContestTransactionType.entryPaid ? 0 : defaultPadding / 1.5),
                child: SvgPicture.asset(
                  (contestTransactionType == ContestTransactionType.winning)
                      ? AppAssets.winningRankSVG
                      : contestTransactionType == ContestTransactionType.entryPaid
                          ? AppAssets.rankOneSVG
                          : contestTransactionType == ContestTransactionType.refund || contestTransactionType == ContestTransactionType.gameError
                              ? AppAssets.successfulDepositSVG
                              : AppAssets.giftOfferSVG,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (contestTransactionType == ContestTransactionType.winning)
                        ? "Winnings"
                        : contestTransactionType == ContestTransactionType.entryPaid
                            ? "Entry Paid"
                            : contestTransactionType == ContestTransactionType.refund
                                ? "Refunded"
                                : contestTransactionType == ContestTransactionType.gameError
                                    ? "Refunded"
                                    : "Offer Applied",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  4.verticalSpace,
                  Text(
                    "${timeFormat(time: dateTime!)} | ${fullDateFormat(day: dateTime?.day, month: dateTime?.month, year: dateTime?.year)}  ",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  amount,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 14.sp,
                        color: (contestTransactionType == ContestTransactionType.winning || contestTransactionType == ContestTransactionType.refund) ? AppColors.green : AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),

          /// refund details
          if (joinDetails != null) ...[
            const Divider(),
            Table(
              // border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                tableRow(key: "Winnings:", value: joinDetails?.winnings ?? 0),
                tableRow(key: "UnUtilized", value: joinDetails?.unUtilized ?? 0),
                tableRow(key: "Discount", value: joinDetails?.discount ?? 0),
              ],
            ),
            (defaultPadding / 2).verticalSpace,
          ]
        ],
      ),
    );
  }

  Widget textTile(String str, {bool isHighlighted = false, TextAlign textAlign = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding).copyWith(bottom: 0, top: defaultPadding / 4),
      child: Text(
        str,
        textAlign: textAlign,
        style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              color: AppColors.subTextColor(Get.context!),
              fontWeight: isHighlighted ? FontWeight.w600 : null,
            ),
      ),
    );
  }

  TableRow tableRow({required String key, required dynamic value, bool isHighlighted = false}) {
    return TableRow(
      children: [
        textTile(key, isHighlighted: isHighlighted),
        textTile(AppStrings.rupeeSymbol + value.toString(), isHighlighted: isHighlighted, textAlign: TextAlign.end),
      ],
    );
  }
}
