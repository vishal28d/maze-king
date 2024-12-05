import 'package:flutter/cupertino.dart';

/// An icon definition used as child by [FluidNavBar]
///
/// See also:
///
///  * [FluidNavBar]

class FluidNavBarIcon {
  /// The path of the SVG asset
  @deprecated
  final String? iconPath;

  final String? title;

  /// The SVG path
  final String? svgSelectedPath;
  final String? svgUnSelectedPath;

  /// The icon data
  final IconData? icon;

  /// The color used to paint the SVG when the item is active
  final Color? selectedForegroundColor;

  /// The color used to paint the SVG when the item is inactive
  final Color? unselectedForegroundColor;

  /// The background color of the item
  final Color? backgroundColor;

  /// Extra information which can be used in [FluidNavBarItemBuilder]
  final Map<String, dynamic>? extras;

  FluidNavBarIcon({
    this.title,
    this.iconPath,
    this.svgSelectedPath,
    this.svgUnSelectedPath,
    this.icon,
    this.selectedForegroundColor,
    this.unselectedForegroundColor,
    this.backgroundColor,
    this.extras,
  })  : assert(iconPath == null || svgSelectedPath == null || svgUnSelectedPath == null || icon == null, 'Cannot provide both an svgPath and an icon.'),
        assert(iconPath != null || svgSelectedPath != null || svgUnSelectedPath != null || icon != null, 'An svgPath or an icon must be provided.');
}
