import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/country_list.dart';
import '../utils/utils.dart';
import 'app_theme.dart';
import 'widgets/country_picker_dialog.dart';

class AppTextField extends StatefulWidget {
  /// Global property
  final EdgeInsetsGeometry? padding;

  /// Title widget
  final String? title;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? titlePadding;

  /// Filed widget
  final TextStyle? style;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? initialValue;

  final Function(String value)? onChanged;
  final String? Function(String?)? validate;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onFieldSubmitted;

  final Widget? prefixIcon;
  final VoidCallback? prefixOnTap;
  final Widget? suffixIcon;
  final VoidCallback? suffixOnTap;

  final int? maxLines;
  final bool? enabled;
  final bool? readOnly;
  final bool? obscureText;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? maxLength;
  final EdgeInsetsGeometry? contentPadding;
  final bool isCountrySelectable;
  final Rx<Country>? selectedCountry;

  final Color? fillColor;
  final Color? cursorColor;
  final bool? autofocus;
  final double? radius;
  final double? cursorHeight;

  final InputBorder? enabledBorder;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? disabledBorder;
  final InputBorder? errorBorder;

  final bool? defaultMaxLengthView;

  /// Error widget
  final String? errorMessage;
  final bool? showError;
  final TextStyle? errorStyle;
  final double? errorSpacing;
  final double? errorHeight;

  const AppTextField({
    super.key,

    /// Global property
    this.padding,

    /// Title widget
    this.title,
    this.titleStyle,
    this.titlePadding,

    /// Filed widget
    this.style,
    this.controller,
    this.hintText,
    this.hintStyle,
    this.initialValue,
    this.onChanged,
    this.validate,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.prefixOnTap,
    this.suffixIcon,
    this.isCountrySelectable = false,
    this.suffixOnTap,
    this.maxLines,
    this.enabled,
    this.readOnly,
    this.obscureText,
    this.onTap,
    this.selectedCountry,
    this.focusNode,
    this.textInputAction,
    this.keyboardType,
    this.maxLength,
    this.contentPadding,
    this.fillColor,
    this.cursorColor,
    this.autofocus,
    this.radius,
    this.cursorHeight,
    this.enabledBorder,
    this.border,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.errorBorder,
    this.defaultMaxLengthView,

    /// Error widget
    this.errorMessage,
    this.showError,
    this.errorStyle,
    this.errorSpacing,
    this.errorHeight,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focus = FocusNode();
  bool isFieldActive = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      widget.focusNode?.addListener(_onFocusChange);
    } else {
      _focus.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    setState(() {
      if (widget.focusNode != null) {
        isFieldActive = widget.focusNode?.hasFocus ?? false;
      } else {
        isFieldActive = _focus.hasFocus;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) {
      if (widget.focusNode != null) {
        widget.focusNode?.removeListener(_onFocusChange);
      } else {
        _focus.removeListener(_onFocusChange);
        _focus.dispose();
      }
    }
  }

  Color defaultBorderColor = Theme.of(Get.context!).primaryColor.withOpacity(0.14);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null && widget.title!.isNotEmpty) ...[
            FieldTitleWidget(
              context,
              title: widget.title ?? "",
              isFieldActive: isFieldActive,
              titleStyle: widget.titleStyle ?? Theme.of(context).textTheme.bodyMedium,
              padding: widget.titlePadding ?? const EdgeInsets.only(bottom: 8, left: defaultPadding * 1.1),
            ),
          ],
          Container(
              // decoration: BoxDecoration(
              //   boxShadow: defaultShadow(context),
              //   borderRadius: BorderRadius.circular(defaultRadius),
              // ),
              child: textFieldWidget(context)),
          if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty)
            FieldErrorWidget(
              context,
              errorHeight: widget.errorHeight,
              errorSpacing: widget.errorSpacing,
              showError: widget.showError,
              errorStyle: widget.errorStyle,
              errorMessage: widget.errorMessage,
            ),
        ],
      ),
    );
  }

  TextFormField textFieldWidget(BuildContext context) {
    return TextFormField(
      scrollPadding: EdgeInsets.only(bottom: 100.h),
      onTap: widget.onTap,
      focusNode: (widget.focusNode ?? _focus),
      autofocus: widget.autofocus ?? false,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: widget.cursorColor ?? Theme.of(context).primaryColor,
      initialValue: widget.initialValue,
      controller: widget.controller,
      enabled: widget.enabled,
      cursorHeight: widget.cursorHeight,
      maxLength: widget.showError == false ? (widget.defaultMaxLengthView == true ? (widget.maxLength != 0 ? widget.maxLength : null) : null) : null,
      obscureText: widget.obscureText ?? false,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      onChanged: (String value) {
        widget.onChanged != null ? widget.onChanged!(value) : null;
      },
      maxLines: widget.maxLines ?? 1,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: textFormFieldStyle,
      inputFormatters: widget.inputFormatters ??
          [
            if (widget.maxLength != null) LengthLimitingTextInputFormatter(widget.maxLength),
          ],
      readOnly: widget.readOnly ?? false,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor ?? Theme.of(context).cardColor,
        isCollapsed: true,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ?? (TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey)),
        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: defaultPadding * 1.5, vertical: 17),
        prefixIcon: widget.isCountrySelectable
            ? GestureDetector(
                onTap: () {
                  Get.dialog(
                    CountryPickerDialog(
                      countryList: countries,
                      onCountryChanged: (v) {
                        widget.selectedCountry?.value = v;
                      },
                      selectedCountry: widget.selectedCountry?.value ??
                          const Country(
                            name: "India",
                            flag: "🇮🇳",
                            code: "IN",
                            dialCode: "91",
                            minLength: 10,
                            maxLength: 10,
                          ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 14).copyWith(right: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "+${widget.selectedCountry?.value.dialCode ?? ""}",
                        style: textFormFieldStyle,
                      ),
                      const Icon(Icons.arrow_drop_down_outlined),
                    ],
                  ),
                ),
              )
            : widget.prefixIcon != null
                ? InkWell(
                    overlayColor: WidgetStateProperty.all(Theme.of(context).brightness == Brightness.dark ? null : Colors.white),
                    onTap: widget.prefixOnTap,
                    child: DefaultTextStyle(style: textFormFieldStyle, child: widget.prefixIcon!),
                  )
                : null,
        suffixIcon: widget.suffixIcon != null
            ? InkWell(
                overlayColor: WidgetStateProperty.all(Theme.of(context).brightness == Brightness.dark ? null : Colors.white),
                onTap: widget.suffixOnTap,
                child: widget.suffixIcon,
              )
            : null,
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: filedBorderRadius,
              borderSide: BorderSide(color: widget.showError == false ? defaultBorderColor : Theme.of(context).colorScheme.error),
              // borderSide: BorderSide.none,
            ),
        border: widget.border ??
            OutlineInputBorder(
              borderRadius: filedBorderRadius,
              borderSide: BorderSide(color: defaultBorderColor),
              // borderSide: BorderSide.none,
            ),
        focusedBorder: widget.focusedBorder ??
            OutlineInputBorder(
              borderRadius: filedBorderRadius,
              borderSide: BorderSide(color: defaultBorderColor),
              // borderSide: BorderSide.none,
            ),
        focusedErrorBorder: widget.focusedErrorBorder ??
            OutlineInputBorder(
              borderRadius: filedBorderRadius,
              borderSide: BorderSide(color: defaultBorderColor),
              // borderSide: BorderSide.none,
            ),
        disabledBorder: widget.disabledBorder ??
            OutlineInputBorder(
              borderRadius: filedBorderRadius,
              borderSide: BorderSide(color: defaultBorderColor),
            ),
        errorBorder: widget.errorBorder ??
            OutlineInputBorder(
              borderRadius: filedBorderRadius,
              borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
      ),
    );
  }

  BorderRadius get filedBorderRadius {
    return const BorderRadius.all(Radius.circular(500));
  }

  TextStyle get textFormFieldStyle {
    return widget.style ?? Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 16.sp);
  }
}

/// [FieldTitleWidget] You can also use the widget globally in a way where you have created your own custom TextField
class FieldTitleWidget extends StatelessWidget {
  final BuildContext mainContext;
  final String title;
  final TextStyle? titleStyle;
  final bool? isFieldActive;
  final EdgeInsetsGeometry? padding;

  const FieldTitleWidget(
    this.mainContext, {
    super.key,
    required this.title,
    this.titleStyle,
    this.isFieldActive = false,
    this.padding,
  });

  @override
  Widget build(context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 150),
        style: titleStyle ??
            Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 13.5.sp,
                  fontFamily: AppTheme.fontFamilyName,
                  color: isFieldActive == true ? Theme.of(mainContext).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
                ),
        child: Text(title),
      ),
    );
  }
}

/// [FieldErrorWidget] You can also use the widget globally in a way where you have created your own custom TextField
class FieldErrorWidget extends StatelessWidget {
  final double? errorHeight;
  final double? errorSpacing;
  final bool? showError;
  final String? errorMessage;
  final TextStyle? errorStyle;
  final BuildContext? mainContext;

  const FieldErrorWidget(
    this.mainContext, {
    super.key,
    this.errorHeight,
    this.errorSpacing,
    this.showError = false,
    required this.errorMessage,
    this.errorStyle,
  });

  @override
  Widget build(context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      tween: showError == true ? Tween(begin: 0.0, end: (errorHeight ?? 17) + (errorSpacing ?? 5)) : Tween(begin: 0.0, end: 0.0),
      builder: (context, value, child) {
        return Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(top: errorSpacing ?? 5, left: defaultPadding),
          height: value * 1,
          child: Text(
            errorMessage ?? "",
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: errorStyle ??
                TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        );
      },
    );
  }
}
