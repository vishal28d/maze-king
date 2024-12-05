import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/widgets/withdrawals_screen/withdrawals_screen_controller.dart';

import '../../../../../../exports.dart';
import '../../../../../../res/empty_element.dart';
import '../../components/transaction_shimmer.dart';

class WithdrawalsScreen extends StatelessWidget {
  WithdrawalsScreen({super.key});

  final WithdrawalsScreenController con = Get.put(WithdrawalsScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyanBg,
      body: Obx(
        () {
          return (con.isLoader.isFalse)
              ? (con.withdrawTransactionList.isEmpty)
                  ? const Center(
                      child: EmptyElement(title: "No Records Yet"),
                    )
                  : ListView.builder(
                      controller: con.scrollController,
                      physics: const RangeMaintainingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding).copyWith(bottom: defaultPadding),
                      itemCount: con.withdrawTransactionList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            withDrawTransactionTile(
                              context,
                              topRadius: index == 0 ? true : false,
                              bottomRadius: index == con.withdrawTransactionList.length - 1 ? true : false,
                              status: "Completed" /*con.withdrawTransactionList[index].status == WithdrawalsTransactionType.processed.name
                                  ? "Completed"
                                  : (con.withdrawTransactionList[index].status == WithdrawalsTransactionType.processing.name)
                                      ? "Pending"
                                      : "Failed"*/
                              ,
                              dateTime: con.withdrawTransactionList[index].createdAt?.toLocal(),
                              amount: con.withdrawTransactionList[index].withdraw ?? 0,
                              receivableAmount: con.withdrawTransactionList[index].amount ?? 0,
                              tdsAmount: con.withdrawTransactionList[index].tdsAmount ?? 0,
                              tdsPercentage: con.withdrawTransactionList[index].tdsPercentage ?? 0,
                              withdrawalsTransactionType: WithdrawalsTransactionType
                                  .processed /*con.withdrawTransactionList[index].status == WithdrawalsTransactionType.processed.name
                                  ? WithdrawalsTransactionType.processed
                                  : (con.withdrawTransactionList[index].status == WithdrawalsTransactionType.processing.name)
                                      ? WithdrawalsTransactionType.processing
                                      : WithdrawalsTransactionType.reversed*/
                              ,
                            ),
                            if (con.paginationLoading.isTrue && con.withdrawTransactionList.length == index + 1) UiUtils.appCircularProgressIndicator(),
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
    required String status,
    required num amount,
    required num receivableAmount,
    required num tdsAmount,
    required num tdsPercentage,
    DateTime? dateTime,
    WithdrawalsTransactionType withdrawalsTransactionType = WithdrawalsTransactionType.processed,
  }) {
    Color color = ((withdrawalsTransactionType == WithdrawalsTransactionType.processed)
        ? AppColors.green
        : withdrawalsTransactionType == WithdrawalsTransactionType.processing
            ? Colors.orange
            : AppColors.error);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: color.withOpacity(0.08),
                ),
                margin: const EdgeInsets.all(defaultPadding / 2).copyWith(right: defaultPadding),
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 1.5, vertical: defaultPadding / 4),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 12.sp,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
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
          Table(
            // border: TableBorder.all(color: Colors.black),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              tableRow(key: "Withdrawal Amount:", value: (amount).toStringAsFixed(2)),
              // tableRow(key: "TDS ($tdsPercentage%):", value: tdsAmount.toStringAsFixed(2)),
              tableRow(key: "Receivable Amount:", value: receivableAmount.toStringAsFixed(2), isHighlighted: true),
            ],
          ),
          const SizedBox(height: defaultPadding)
        ],
      ),
    );
  }
}
