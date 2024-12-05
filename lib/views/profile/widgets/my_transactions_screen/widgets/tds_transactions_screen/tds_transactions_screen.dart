import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../exports.dart';
import '../../../../../../res/empty_element.dart';
import '../../components/transaction_shimmer.dart';
import 'tds_transactions_screen_controller.dart';

class TdsTransactionsScreen extends StatelessWidget {
  TdsTransactionsScreen({super.key});

  final TdsTransactionsScreenController con = Get.put(TdsTransactionsScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyanBg,
      body: Obx(
        () {
          return (con.isLoader.isFalse)
              ? (con.transactionList.isEmpty)
                  ? const Center(
                      child: EmptyElement(title: "No Records Yet"),
                    )
                  : ListView.builder(
                      controller: con.scrollController,
                      physics: const RangeMaintainingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding).copyWith(bottom: defaultPadding),
                      itemCount: con.transactionList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            withDrawTransactionTile(
                              context,
                              topRadius: index == 0 ? true : false,
                              bottomRadius: index == con.transactionList.length - 1 ? true : false,
                              dateTime: con.transactionList[index].createdAt?.toLocal(),
                              withdrawAmount: con.transactionList[index].tdsDeduct ?? 0,
                              tdsAmount: con.transactionList[index].tdsAmount ?? 0,
                              tdsPercentage: con.transactionList[index].tdsPercentage ?? 0,
                            ),
                            if (con.paginationLoading.isTrue && con.transactionList.length == index + 1) UiUtils.appCircularProgressIndicator(),
                          ],
                        );
                      },
                    )
              : ListView.builder(
                  physics: const RangeMaintainingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding).copyWith(bottom: defaultPadding, top: 0),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const TransactionShimmer();
                  },
                );
        },
      ),
    );
  }

  Widget withDrawTransactionTile(
    BuildContext context, {
    bool topRadius = false,
    bool bottomRadius = false,
    required num withdrawAmount,
    required num tdsAmount,
    required num tdsPercentage,
    DateTime? dateTime,
  }) {

    Widget textTile(String str, {bool isHighlighted = false, TextAlign textAlign = TextAlign.left}) {
      return Padding(
        padding: const EdgeInsets.all(defaultPadding).copyWith(bottom: 0, top: defaultPadding / 4),
        child: Text(
          str,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                // color: color,
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: AppColors.authSubTitle.withOpacity(0.4),
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
          (defaultPadding / 2).verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(6.r),
              //     color: color.withOpacity(0.08),
              //   ),
              //   margin: const EdgeInsets.all(defaultPadding / 2).copyWith(right: defaultPadding),
              //   padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 1.5, vertical: defaultPadding / 4),
              //   child: Text(
              //     status,
              //     style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //           fontSize: 12.sp,
              //           color: color,
              //           fontWeight: FontWeight.w500,
              //         ),
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 1.5),
                child: Text(
                  "${timeFormat(time: dateTime!)} | ${fullDateFormat(day: dateTime.day, month: dateTime.month, year: dateTime.year)}  ",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.black.withOpacity(0.4),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
          (defaultPadding / 4).verticalSpace,
          Table(
            // border: TableBorder.all(color: Colors.black),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              tableRow(key: "TDS ($tdsPercentage%):", value: tdsAmount.toStringAsFixed(2), isHighlighted: true),
              tableRow(key: "Withdrawal Amount:", value: (withdrawAmount).toStringAsFixed(2)),
            ],
          ),
          const SizedBox(height: defaultPadding)
        ],
      ),
    );
  }
}
