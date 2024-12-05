import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maze_king/exports.dart';

class CustomTooltip extends StatefulWidget {
  final BuildContext context;
  final String message;
  final Widget child;
  final double? topSpacing;

  const CustomTooltip(this.context, {super.key, required this.child, this.topSpacing, required this.message});

  @override
  _CustomTooltipState createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> with TickerProviderStateMixin {
  final color = Theme.of(Get.context!).primaryColor;
  late GlobalKey key;
  late Offset _offset;
  late Size _size;
  late OverlayEntry overlayEntry;

  late AnimationController _controller;

  @override
  void initState() {
    key = LabeledGlobalKey(widget.message);
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  void getWidgetDetails() {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    _size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _offset = offset;
    printOkStatus(_offset.dx);
  }

  OverlayEntry _makeOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: widget.topSpacing ?? _offset.dy + 20,
        left: _offset.dx - 25,
        width: _size.width + 50,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 0.9).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut)),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: ClipPath(
                  clipper: ArrowClip(),
                  child: Container(
                    height: 10,
                    width: 15,
                    decoration: BoxDecoration(
                      color: color,
                    ),
                  ),
                ),
              ),
              Material(
                color: Theme.of(context).primaryColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(defaultRadius),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    widget.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: key,
      child: widget.child,
      onTap: () {
        printOkStatus("Visible:$visible");
        if (!visible) {
          getWidgetDetails();
          overlayEntry = _makeOverlay();
          Overlay.of(widget.context).insert(overlayEntry);
          _controller.forward();
          visible = !visible;
        } else {
          _controller.reverse();
          overlayEntry.remove();
          visible = !visible;
        }
      },
      // onHover: onMyHover,
    );
  }
}

class ArrowClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
