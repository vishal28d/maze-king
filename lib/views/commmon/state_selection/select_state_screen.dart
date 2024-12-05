import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maze_king/views/commmon/state_selection/select_state_controller.dart';

import '../../../exports.dart';
import '../../../res/widgets/app_bar.dart';
import '../../../res/widgets/select_city_state_list_tile.dart';

class SelectStateScreen extends StatelessWidget {
  SelectStateScreen({super.key});

  final SelectStateController con = Get.put(SelectStateController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Column(
          children: [
            MyAppBar(
              showBackIcon: true,
              title: "Select State",
              myAppBarSize: MyAppBarSize.medium,
              backgroundColor: Colors.transparent,
            ),
            AppTextField(
              hintText: "Search State",
              controller: con.selectStateCon.value,
              textInputAction: TextInputAction.search,
              showError: false,
              // textFieldType: TextFieldType.search,
              padding: const EdgeInsets.all(defaultPadding).copyWith(),
              suffixIcon: con.showCloseButton.isTrue
                  ? Padding(
                    padding:  const EdgeInsets.all(defaultPadding),
                    child: SvgPicture.asset(
                      AppAssets.closeIcon,
                      color: Theme.of(context).primaryColor, // ignore: deprecated_member_use
                    ),
                  )
                  : null,
              suffixOnTap: con.showCloseButton.isTrue
                  ? () {
                      FocusScope.of(context).unfocus();
                      con.searchKeyword.value = "";
                      con.showCloseButton.value = false;
                      con.selectStateCon.value.clear();
                    }
                  : null,
              onChanged: (value) {
                con.searchKeyword.value = value;

                if (con.selectStateCon.value.text.isNotEmpty) {
                  con.showCloseButton.value = true;
                } else {
                  con.showCloseButton.value = false;
                }
              },
            ),
            Expanded(
              child: con.isLoading.isFalse
                  ? ListView.separated(
                      itemCount: con.stateList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 1),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => Obx(
                        () {
                          if (con.stateList[index].name.toString().toLowerCase().contains(con.searchKeyword.value.trim().toLowerCase())) {
                            return SelectStateOrCityListTile(
                              title: con.stateList[index].name ?? "",
                              isSelected: con.selectedStateModel.value.id == con.stateList[index].id,
                              onTap: () {
                                FocusScope.of(context).unfocus();

                                con.selectedStateModel.value = con.stateList[index];
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    )
                  : ListView.builder(
                      key: ValueKey<bool>(con.isLoading.value),
                      itemCount: 50,
                      itemBuilder: (context, index) {
                        return loadingShimmerWidget();
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: AppButton(
          title: "Select",
          disableButton: con.selectedStateModel.value.id == null,
          padding: const EdgeInsets.all(defaultPadding).copyWith(bottom: MediaQuery.of(context).padding.bottom + defaultPadding),
          onPressed: () {
            Get.back(result: con.selectedStateModel.value);
          },
        ),
      ),
    );
  }

  Widget loadingShimmerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2, horizontal: defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerUtils.shimmer(
                child: ShimmerUtils.shimmerContainer(
                  height: 10.h,
                  width: Get.width * 0.8,
                  borderRadius: defaultRadius - (8 / 2),
                ),
              ),
              (defaultPadding / 2.5).verticalSpace,
              ShimmerUtils.shimmer(
                child: ShimmerUtils.shimmerContainer(
                  height: 10.h,
                  width: Get.width * 0.5,
                  borderRadius: defaultRadius - (8 / 2),
                ),
              ),
            ],
          ),
          const Spacer(),
          ShimmerUtils.shimmer(
            child: ShimmerUtils.shimmerContainer(
              height: (defaultPadding * 1.3).h,
              width: (defaultPadding * 1.3).h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(Get.context!).primaryColor.withOpacity(0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
