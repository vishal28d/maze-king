import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/res/empty_element.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/components/transaction_shimmer.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/widgets/deposits_screen/deposit_screen_controller.dart';

import '../../../../../../exports.dart';

class DepositsScreen extends StatelessWidget {
  DepositsScreen({super.key});

  final DepositScreenController con = Get.put(DepositScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyanBg,
      body: Obx(() {
        return (con.isLoader.isFalse)
            ? (con.depositTransactionList.isEmpty)
                ? const Center(
                    child: EmptyElement(
                      title: "No Records Yet",
                    ),
                  )
                : ListView.builder(
                    physics: const RangeMaintainingScrollPhysics(),
                    controller: con.scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding).copyWith(bottom: defaultPadding, top: 0),
                    itemCount: con.depositTransactionList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          depositTransactionTile(
                            context, topRadius: index == 0 ? true : false,
                            bottomRadius: con.depositTransactionList.length - 1 == index ? true : false,
                            amount: (con.depositTransactionList[index].info?.amount ?? 0).toString(),
                            dateTime: con.depositTransactionList[index].createdAt?.toLocal(),
                            status: con.depositTransactionList[index].info?.paymentStatus ?? "",
                            // depositsTransactionType: con.depositTransactionList[index].status == "captured"
                            //     ? DepositsTransactionType.successful
                            //     : con.depositTransactionList[index].type == DepositsTransactionType.discount.name
                            //         ? DepositsTransactionType.discount
                            //         : DepositsTransactionType.failed,
                            // depositStatus: con.depositTransactionList[index].status,
                          ),
                          if (con.paginationLoading.isTrue && con.depositTransactionList.length == index + 1) UiUtils.appCircularProgressIndicator(),
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
      }),
    );
  }

  Widget depositTransactionTile(
    BuildContext context, {
    bool topRadius = false,
    bool bottomRadius = false,
    String title = '',
    String amount = '',
    required String status,
    DateTime? dateTime,
    String? depositStatus,
    // DepositsTransactionType depositsTransactionType = DepositsTransactionType.successful,
  }) {
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
      child: Row(
        children: [
          // Container(
          //   height: 45.h,
          //   width: 45.h,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(6.r),
          //     color: (depositsTransactionType == DepositsTransactionType.successful || depositsTransactionType == DepositsTransactionType.discount) ? Colors.green.withOpacity(0.14) : Colors.orange.withOpacity(0.13),
          //   ),
          //   margin: const EdgeInsets.all(defaultPadding / 2).copyWith(right: defaultPadding),
          //   padding: const EdgeInsets.all(defaultPadding / 1.5),
          //   child: SvgPicture.asset(
          //     (depositsTransactionType == DepositsTransactionType.successful || depositsTransactionType == DepositsTransactionType.discount) ? AppAssets.successfulDepositSVG : AppAssets.failedDepositSVG,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                4.verticalSpace,
                Text(
                  "${timeFormat(time: dateTime!)} | ${fullDateFormat(day: dateTime.day, month: dateTime.month, year: dateTime.year)}  ",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              AppStrings.rupeeSymbol + amount,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 14.sp,
                    // color: (depositsTransactionType == DepositsTransactionType.successful || depositsTransactionType == DepositsTransactionType.discount) ? AppColors.green : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
