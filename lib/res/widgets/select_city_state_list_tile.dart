import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../exports.dart';
import '../../utils/enums/common_enums.dart';
import '../custom_radio_button.dart';

class SelectStateOrCityListTile extends StatelessWidget {
  final String title;

  final VoidCallback? onTap;
  final bool? isSelected;
  final bool? deleteButton;
  final VoidCallback? onDelete;
  final EdgeInsetsGeometry? padding;

  const SelectStateOrCityListTile({
    super.key,
    required this.title,
    this.onTap,
    this.isSelected,
    this.deleteButton = false,
    this.onDelete,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: (defaultPadding / 1.5)).copyWith(right: defaultPadding * 1.5),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: defaultPadding / 3, right: defaultPadding / 1.2),
                child: Text(
                  title,
                  style: TextStyle(
                    // color: AppColors.midnightGreen,
                    fontWeight: isSelected == true ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            deleteButton == false
                ? AppRadioButton(
                    isSelected: RxBool(isSelected ?? false),
                    radioButtonType: RadioButtonType.outline,
                  )
                : AppIconButton(
                    onPressed: onDelete ?? () {},
                    icon: SvgPicture.asset(
                      AppAssets.closeIcon,
                      height: 13,
                      width: 13,
                      color: const Color(0xffCECDCD), // ignore: deprecated_member_use
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
