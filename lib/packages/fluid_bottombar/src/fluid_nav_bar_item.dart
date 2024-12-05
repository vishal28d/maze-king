import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../exports.dart';
import 'curves.dart';

typedef FluidNavBarButtonTappedCallback = void Function();

/// An interactive button within [FluidNavBar]
///
/// This class is not used in isolation. It is created by
/// fluid navigation bar widget according to [FluidNavBarIcon] definition.
///
/// See also:
///
///  * [FluidNavBar]
///  * [FluidNavBarIcon]

class FluidNavBarItem extends StatefulWidget {
  static const nominalExtent = Size(64, 64);

  /// The SVG path
  final String? svgSelectedPath;
  final String? svgUnSelectedPath;

  // The icon data
  final IconData? icon;

  /// Flag to know if this item is active or not
  final bool selected;

  /// The color used to paint the SVG when the item is active
  final Color selectedForegroundColor;

  /// The color used to paint the SVG when the item is inactive
  final Color unselectedForegroundColor;

  /// The background color of the item
  final Color backgroundColor;

  /// The temporary SVG scale used when the item pop
  final double scaleFactor;

  /// The callback used when the item is tapped
  final FluidNavBarButtonTappedCallback onTap;

  /// The delay factor of the animations ( < 1 is faster, > 1 is slower)
  final double animationFactor;

  final int totalItems;
  final String? title;

  const FluidNavBarItem(this.title, this.svgSelectedPath, this.svgUnSelectedPath, this.icon, this.selected, this.onTap, this.totalItems, this.selectedForegroundColor, this.unselectedForegroundColor, this.backgroundColor, this.scaleFactor, this.animationFactor, {super.key})
      : assert(scaleFactor >= 1.0),
        assert(svgSelectedPath == null || svgUnSelectedPath == null || icon == null, 'Cannot provide both an iconPath and an icon.'),
        assert(!(svgSelectedPath == null && svgUnSelectedPath == null && icon == null), 'An iconPath or an icon must be provided.');

  @override
  State createState() {
    return _FluidNavBarItemState(selected);
  }
}

class _FluidNavBarItemState extends State<FluidNavBarItem> with SingleTickerProviderStateMixin {
  static const double _activeOffset = 16;
  static const double _defaultOffset = 0;
  static const double _iconSize = 25;

  bool _selected;

  late AnimationController _animationController;
  late Animation<double> _activeColorClipAnimation;
  late Animation<double> _yOffsetAnimation;
  late Animation<double> _activatingAnimation;
  late Animation<double> _inactivatingAnimation;

  _FluidNavBarItemState(this._selected);

  @override
  void initState() {
    super.initState();

    double waveRatio = 0.99;
    _animationController = AnimationController(
      duration: Duration(milliseconds: (200 * widget.animationFactor).toInt()),
      reverseDuration: Duration(milliseconds: (1000 * widget.animationFactor).toInt()),
      vsync: this,
    )..addListener(() => setState(() {}));

    _activeColorClipAnimation = Tween<double>(begin: 0.0, end: _iconSize).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.25, 0.38, curve: Curves.easeOut),
      reverseCurve: const Interval(0.7, 1.0, curve: Curves.easeInCirc),
    ));

    var animation = CurvedAnimation(parent: _animationController, curve: LinearPointCurve(waveRatio, 0.0));

    _yOffsetAnimation = Tween<double>(begin: _defaultOffset, end: _activeOffset).animate(CurvedAnimation(
      parent: animation,
      curve: const ElasticOutCurve(0.38),
      reverseCurve: Curves.easeInCirc,
    ));

    var activatingHalfTween = Tween<double>(begin: 1, end: widget.scaleFactor);
    _activatingAnimation = TweenSequence([
      TweenSequenceItem(tween: activatingHalfTween, weight: 50.0),
      TweenSequenceItem(tween: ReverseTween<double>(activatingHalfTween), weight: 50.0),
    ]).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.3),
    ));
    _inactivatingAnimation = ConstantTween<double>(1.0).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.3, 1.0),
    ));

    _startAnimation();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (oldWidget.selected != _selected) {
      setState(() {
        _selected = widget.selected;
      });
      _startAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    const ne = FluidNavBarItem.nominalExtent;

    final scaleAnimation = _selected ? _activatingAnimation : _inactivatingAnimation;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints.tight(ne),
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(ne.width / 2 - _iconSize),
              constraints: BoxConstraints.tight(const Size.square(_iconSize * 2)),
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: const CircleBorder(),
              ),
              transform: Matrix4.translationValues(0, -_yOffsetAnimation.value, 0),
              child: Stack(
                children: <Widget>[
                  Container(
                    // color: Colors.yellow,
                    alignment: Alignment.center,
                    child: widget.icon == null
                        ? SvgPicture.asset(
                            widget.selected ? widget.svgSelectedPath! : widget.svgUnSelectedPath!,
                            // color: widget.unselectedForegroundColor,
                            // width: _iconSize,
                            // height: _iconSize * scaleAnimation.value,
                            colorBlendMode: BlendMode.srcIn,
                          )
                        : Icon(
                            widget.icon,
                            color: widget.unselectedForegroundColor,
                            size: _iconSize * scaleAnimation.value,
                          ),
                  ),
                  Container(
                    // color: Colors.red,
                    alignment: Alignment.center,
                    child: ClipRect(
                      clipper: _SvgPictureClipper(_activeColorClipAnimation.value * scaleAnimation.value),
                      child: widget.icon == null
                          ? SvgPicture.asset(
                              widget.selected ? widget.svgSelectedPath! : widget.svgUnSelectedPath!,
                              // color: widget.selectedForegroundColor,
                              // width: _iconSize,
                              // height: _iconSize * scaleAnimation.value,
                              colorBlendMode: BlendMode.srcIn,
                            )
                          : Icon(
                              widget.icon,
                              color: widget.selectedForegroundColor,
                              size: _iconSize * scaleAnimation.value,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// title
          Container(
            // constraints: BoxConstraints.tight(ne),
            width: Get.width / widget.totalItems,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            transform: Matrix4.translationValues(0, -_yOffsetAnimation.value * 0.8, 0),

            // color: Colors.red,
            child: widget.selected
                ? Text(
                    widget.title ?? "",
                    // "${widget.svgSelectedPath?.split("/").last}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: /* widget.selectedForegroundColor ??*/ AppColors.green,
                          fontSize: 10.sp,
                        ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  void _startAnimation() {
    if (_selected) {
      _animationController.forward();
    } else {
      // Required otherwise the CurvedAnimation uses the standard curve instead of the reverseCurve
      // if the animation is not completed: so set it as completed before calling reverse.
      _animationController.value = 1.0;
      _animationController.reverse();
    }
  }
}

class _SvgPictureClipper extends CustomClipper<Rect> {
  final double height;

  _SvgPictureClipper(this.height);

  @override
  Rect getClip(Size size) {
    return Rect.fromPoints(size.topLeft(Offset.zero), size.topRight(Offset.zero) + Offset(0, height));
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
