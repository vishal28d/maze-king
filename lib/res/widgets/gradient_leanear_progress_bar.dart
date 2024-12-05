import 'package:flutter/material.dart';
import 'package:maze_king/exports.dart';

class GradientProgressIndicator extends StatefulWidget {
  final List<Color>? colors;
  final Color? bgColor;
  final double value;
  final double? height;

  const GradientProgressIndicator({
    super.key,
    this.colors,
    this.bgColor,
    required this.value,
    this.height,
  });

  @override
  _GradientProgressIndicatorState createState() => _GradientProgressIndicatorState();
}

class _GradientProgressIndicatorState extends State<GradientProgressIndicator> {
  double _value = 0.0;

  @override
  void didUpdateWidget(GradientProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final widthToApply = availableWidth * _value;

        return Container(
          height: widget.height ?? 3,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.bgColor ?? Theme.of(context).primaryColor.withOpacity(0.05),
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                // curve: Curves.easeInToLinear,
                duration: const Duration(milliseconds: 0),
                width: widthToApply,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  child: _GradientProgressInternal(
                    widget.colors ??
                        [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                    isValZero(_value) ? 0.01 : _value,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _GradientProgressInternal extends StatelessWidget {
  static const double _kLinearProgressIndicatorHeight = 10.0;
  final List<Color> colors;
  final double value;

  const _GradientProgressInternal(this.colors, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(
        width: double.infinity * value,
        height: _kLinearProgressIndicatorHeight,
      ),
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
    );
  }
}
