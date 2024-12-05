import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/data/models/pan_card/pan_card_model.dart';
import 'package:maze_king/exports.dart';

import '../../../../repositories/pan_card/pan_card_repository.dart';
import '../../../../res/widgets/app_bar.dart';
import 'pan_card_detail_screen_controller.dart';

class PanCardDetailScreen extends StatelessWidget {
  PanCardDetailScreen({super.key});

  final PanCardDetailScreenController con = Get.put(PanCardDetailScreenController());

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
                title: "Pan Card Details",
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
                          /*AppTextField(
                            title: "State",
                            readOnly: true,
                            hintText: "Enter your state",
                            controller: con.stateCon,
                            showError: con.stateHasError.value,
                            errorMessage: con.stateError.value,
                            keyboardType: TextInputType.name,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            textInputAction: TextInputAction.next,
                            onChanged: (val) {
                              // if (con.accountHolderNameCon.value.text.trim().isNotEmpty && con.accountNumCon.value.text.trim().isNotEmpty && con.ifscCon.value.text.trim().isNotEmpty) {
                              //   con.validate();
                              // }
                            },
                            onTap: () {
                              if (con.isEdit.isFalse) {
                                Get.toNamed(
                                  AppRoutes.selectStateScreen,
                                  arguments: {
                                    "selectedState": con.selectedStateModel.value,
                                  },
                                )?.then(
                                  (value) {
                                    if (!isValEmpty(value)) {
                                      if (con.selectedStateModel.value != value) {
                                        /// RESET CITY DATA
                                        con.selectedStateModel.value = StateModel();
                                        con.stateCon.clear();

                                        /// SET STATE DATA
                                        con.selectedStateModel.value = value;
                                        con.stateCon.text = con.selectedStateModel.value.name ?? "";
                                      }
                                      // con.checkButtonDisableStatus();
                                    }
                                  },
                                );
                              }
                            },
                          ),*/
                          AppTextField(
                            title: "Pan Card Number",
                            hintText: "Enter Pan Card Number",
                            readOnly: con.isEdit.value,
                            controller: con.panCardNumCon,
                            showError: con.panCardNumHasError.value,
                            errorMessage: con.panCardNumError.value,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            fillColor: con.isEdit.value ? Colors.white.withOpacity(.5) : Colors.white,
                            padding: const EdgeInsets.only(top: defaultPadding),
                            onChanged: (val) {
                              // if (con.accountHolderNameCon.value.text.trim().isNotEmpty && con.accountNumCon.value.text.trim().isNotEmpty && con.ifscCon.value.text.trim().isNotEmpty) {
                              //   con.validate();
                              // }
                              // con.panCardNumCon.text = con.panCardNumCon.text.toUpperCase();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: con.panCardModel.value.valid ?? false,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: AppColors.green,
                                        ),
                                        (defaultPadding / 3).horizontalSpace,
                                        Text(
                                          "Verified".toUpperCase(),
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.green, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: con.panCardModel.value.registeredName != null,
                                  child: Text(
                                    "${con.panCardModel.value.registeredName}".toUpperCase(),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.green, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          )
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
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding),
                  color: AppColors.cyanBg,
                  child: AppButton(
                    // loader: con.isLoader.value,
                    disableButton: /*!con.isDisable.value ||*/ con.isLoader.value,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (con.validate()) {
                        if (await getConnectivityResult()) {
                          con.panCardModel.value = PanCardModel();
                        }
                        PanCardRepository().addPanCardDetailAPI(
                            isLoader: con.isLoader,
                            panNum: con.panCardNumCon.value.text.trim(),
                            // stateModel: con.selectedStateModel.value,
                            onSuccess: () {
                              con.isEdit.value = true;
                              // Get.offNamed(AppRoutes.withdrawScreen);
                            });
                        // printYellow("panNum: ${con.panCardNumCon.value.text.trim()}");
                      }
                    },
                    title: "Save Pan Card",
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
