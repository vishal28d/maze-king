import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';
import 'package:maze_king/repositories/bank/bank_repository.dart';
import 'package:maze_king/views/profile/widgets/bank_detail_screen/bank_detail_screen_controller.dart';

import '../../../../res/widgets/app_bar.dart';

class BankDetailScreen extends StatelessWidget {
  BankDetailScreen({super.key});

  final BankDetailScreenController con = Get.put(BankDetailScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyanBg,
      body: Obx(
        () {
          return Column(
            children: [
              MyAppBar(
                showBackIcon: true,
                title: "Bank Details",
                myAppBarSize: MyAppBarSize.medium,
                backgroundColor: Colors.transparent,
                actions: [
                  if (con.isEdit.value)
                    appBarActionButton(
                      svgIconPath: AppAssets.editGraphicIconSVG,
                      padding: const EdgeInsets.only(right: defaultPadding / 2, bottom: defaultPadding / 5),
                      onTap: () {
                        // BankRepository.getBankDetailsAPI(isLoader: con.isLoader, type: "unlink").then((value) =>);
                        con.isEdit.value = false;
                      },
                    ),
                ],
              ),
              Expanded(
                child: con.isLoader.value
                    ? Center(
                        child: UiUtils.appCircularProgressIndicator(),
                      )
                    : ListView(
                        shrinkWrap: true,
                        physics: const RangeMaintainingScrollPhysics(),
                        padding: const EdgeInsets.all(defaultPadding).copyWith(bottom: (defaultPadding * 4 + 46.w)),
                        children: [
                          AppTextField(
                            title: "Account Holder Name",
                            readOnly: con.isEdit.value,
                            hintText: "Enter Name",
                            controller: con.accountHolderNameCon,
                            showError: con.accountHolderNameHasError.value,
                            errorMessage: con.accountHolderNameError.value,
                            keyboardType: TextInputType.name,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            textInputAction: TextInputAction.next,
                            onChanged: (val) {
                              // if (con.accountHolderNameCon.value.text.trim().isNotEmpty && con.accountNumCon.value.text.trim().isNotEmpty && con.ifscCon.value.text.trim().isNotEmpty) {
                              //   con.validate();
                              // }
                              // con.accountHolderNameCon.text = con.accountHolderNameCon.text.toUpperCase();
                            },
                          ),

                          AppTextField(
                            title: "Account Number",
                            hintText: "Enter Account Number",
                            readOnly: con.isEdit.value,
                            controller: con.accountNumCon,
                            showError: con.accountNumHasError.value,
                            errorMessage: con.accountNumError.value,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            padding: const EdgeInsets.only(top: defaultPadding),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(con.accountNumberMax.value),
                            ],
                            onChanged: (val) {
                              // if (con.accountHolderNameCon.value.text.trim().isNotEmpty && con.accountNumCon.value.text.trim().isNotEmpty && con.ifscCon.value.text.trim().isNotEmpty) {
                              //   con.validate();
                              // }
                            },
                          ),

                          AppTextField(
                            title: "Confirm Account Number",
                            hintText: "Enter Confirm Account Number",
                            readOnly: con.isEdit.value,
                            controller: con.confirmAccountNumCon,
                            showError: con.confirmAccountNumHasError.value,
                            errorMessage: con.confirmAccountNumError.value,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            padding: const EdgeInsets.only(top: defaultPadding),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(con.accountNumberMax.value),
                            ],
                            onChanged: (val) {
                              // if (con.accountHolderNameCon.value.text.trim().isNotEmpty && con.accountNumCon.value.text.trim().isNotEmpty && con.ifscCon.value.text.trim().isNotEmpty) {
                              //   con.validate();
                              // }
                            },
                          ),

                          AppTextField(
                            title: "IFSC Code",
                            hintText: "Enter IFSC Code",
                            readOnly: con.isEdit.value,
                            controller: con.ifscCon,
                            showError: con.ifscHasError.value,
                            errorMessage: con.ifscError.value,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            padding: const EdgeInsets.only(top: defaultPadding),
                            onChanged: (val) {
                              // if (con.accountHolderNameCon.value.text.trim().isNotEmpty && con.accountNumCon.value.text.trim().isNotEmpty && con.ifscCon.value.text.trim().isNotEmpty) {
                              //   con.validate();
                              // }
                              // con.ifscCon.text = con.ifscCon.text.toUpperCase();
                            },
                          ),

                          /// BANK INFO
                          /// NEW FLOW

                          AppTextField(
                            title: "Bank Name",
                            hintText: "Enter Bank Name",
                            readOnly: con.isEdit.value,
                            controller: con.bankNameCon,
                            showError: con.bankNameHasError.value,
                            errorMessage: con.bankNameError.value,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            padding: const EdgeInsets.only(top: defaultPadding),
                            onChanged: (val) {
                              // if (con.accountHolderNameCon.value.text.trim().isNotEmpty && con.accountNumCon.value.text.trim().isNotEmpty && con.ifscCon.value.text.trim().isNotEmpty) {
                              //   con.validate();
                              // }
                            },
                          ),

                          AppTextField(
                            title: "Branch Name",
                            hintText: "Enter Branch Name",
                            readOnly: con.isEdit.value,
                            controller: con.branchNameCon,
                            showError: con.branchNameHasError.value,
                            errorMessage: con.branchNameError.value,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            padding: const EdgeInsets.only(top: defaultPadding),
                            onChanged: (val) {
                              // if (con.accountHolderNameCon.value.text.trim().isNotEmpty && con.accountNumCon.value.text.trim().isNotEmpty && con.ifscCon.value.text.trim().isNotEmpty) {
                              //   con.validate();
                              // }
                            },
                          ),

                          AppTextField(
                            title: "Bank Address",
                            hintText: "Enter Bank Address",
                            readOnly: con.isEdit.value,
                            controller: con.bankAddressCon,
                            showError: con.bankAddressHasError.value,
                            errorMessage: con.bankAddressError.value,
                            keyboardType: TextInputType.streetAddress,
                            textInputAction: TextInputAction.done,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            padding: const EdgeInsets.only(top: defaultPadding),
                            onChanged: (val) {
                              // if (con.accountHolderNameCon.value.text.trim().isNotEmpty && con.accountNumCon.value.text.trim().isNotEmpty && con.ifscCon.value.text.trim().isNotEmpty) {
                              //   con.validate();
                              // }
                            },
                          ),
                        ],
                      ),
              )
            ],
          );
        },
      ),
      bottomSheet: Obx(
        () {
          return (!con.isEdit.value)
              ? Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  color: AppColors.cyanBg,
                  child: AppButton(
                    // loader: con.isLoader.value,
                    disableButton: /*!con.isDisable.value ||*/ con.isLoader.value,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      con.validate();
                      if (con.validate()) {
                        if (con.bankModel.value.name != con.accountHolderNameCon.value.text.trim() || con.bankModel.value.accountNumber != con.accountNumCon.value.text.trim() || con.bankModel.value.ifsc != con.ifscCon.value.text.trim() || con.bankModel.value.bankName != con.bankNameCon.value.text.trim() || con.bankModel.value.branchName != con.branchNameCon.value.text.trim() || con.bankModel.value.bankAddress != con.bankAddressCon.value.text.trim()) {
                          /*    printYellow("name: ${con.accountHolderNameCon.value.text.trim()}");
                         printYellow("accountNum: ${con.accountNumCon.value.text.trim()}");
                         printYellow("ifsc: ${con.ifscCon.value.text.trim()}");
                         printYellow("bankName: ${con.bankNameCon.value.text.trim()}");
                         printYellow("branchName: ${con.branchNameCon.value.text.trim()}");
                         printYellow("bankAddress: ${con.bankAddressCon.value.text.trim()}");*/
                          BankRepository().addBankDetailAPI(
                            isLoader: con.isLoader,
                            name: con.accountHolderNameCon.value.text.trim(),
                            accountNum: con.accountNumCon.value.text.trim(),
                            ifsc: con.ifscCon.value.text.trim(),
                            bankName: con.bankNameCon.value.text.trim(),
                            branchName: con.branchNameCon.value.text.trim(),
                            bankAddress: con.bankAddressCon.value.text.trim(),
                            onSuccess: () => con.isEdit.value = true,
                          );
                        } else {
                          // con.accountNumCon = TextEditingController(text: "${"X" * (con.accountNumCon.value.text.trim().length - 4)}${con.accountNumCon.value.text.trim().substring(con.accountNumCon.value.text.trim().length - 4)}");

                          con.isEdit.value = true;
                        }
                        /*    if (con.isWithdraw.isTrue) {
                          BankRepository().addBankDetailAPI(
                              isLoader: con.isLoader,
                              name: con.accountHolderNameCon.value.text.trim(),
                              accountNum: con.accountNumCon.value.text.trim(),
                              ifsc: con.ifscCon.value.text.trim(),
                              bankName: con.bankNameCon.value.text.trim(),
                              branchName: con.branchNameCon.value.text.trim(),
                              bankAddress: con.bankAddressCon.value.text.trim(),
                              onSuccess: () {
                                con.isEdit.value = true;
                                // Get.offNamed(AppRoutes.withdrawScreen);
                              });
                        } else {

                        }*/
                      }
                    },
                    title: "Update Bank Details",
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
