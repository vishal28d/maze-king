import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/res/empty_element.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/components/transaction_detail_tile.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/components/transaction_shimmer.dart';
import 'package:maze_king/views/profile/widgets/my_transactions_screen/widgets/contests_screen_controller/contests_screen_controller.dart';

class ContestsScreen extends StatelessWidget {
  ContestsScreen({super.key});

  final ContestsScreenController con = Get.put(ContestsScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyanBg,
      body: Obx(() {
        return (con.isLoader.isFalse)
            ? (con.contestTransactionList.isEmpty)
                ? const Center(
                    child: EmptyElement(
                    title: "No Records Yet",
                  ))
                : ListView.builder(
                    controller: con.scrollController,
                    physics: const RangeMaintainingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding).copyWith(bottom: defaultPadding),
                    itemCount: con.contestTransactionList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ContestsTransactionDetailTile(
                            index: index,
                            topRadius: index == 0 ? true : false,
                            bottomRadius: index == con.contestTransactionList.length - 1 ? true : false,
                            amount: AppStrings.rupeeSymbol + (con.contestTransactionList[index].refundAmount ?? (con.contestTransactionList[index].winningAmount ?? (con.contestTransactionList[index].offerAmount ?? con.contestTransactionList[index].gameError ?? con.contestTransactionList[index].joiningAmount))).toString(),
                            joinDetails: con.contestTransactionList[index].refundAmount != null || con.contestTransactionList[index].gameError != null ? con.contestTransactionList[index].joinDetails : null,
                            dateTime: con.contestTransactionList[index].createdAt?.toLocal(),
                            contestTransactionType: con.contestTransactionList[index].refundAmount != null
                                ? ContestTransactionType.refund
                                : con.contestTransactionList[index].winningAmount != null
                                    ? ContestTransactionType.winning
                                    : con.contestTransactionList[index].joiningAmount != null
                                        ? ContestTransactionType.entryPaid
                                        : con.contestTransactionList[index].gameError != null
                                            ? ContestTransactionType.gameError
                                            : ContestTransactionType.offerApplied,
                          ),
                          if (con.paginationLoading.isTrue && con.contestTransactionList.length == index + 1) UiUtils.appCircularProgressIndicator(),
                        ],
                      );
                    },
                  )
            : ListView.builder(
                physics: const RangeMaintainingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding).copyWith(bottom: defaultPadding),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return const TransactionShimmer();
                },
              );
      }),
    );
  }
}
