import 'package:flutter/material.dart';

class DefTapAnimation extends StatefulWidget {
  final Widget child;
  final double end;
  final Function? onTap;
  const DefTapAnimation(
      {Key? key, required this.child, required this.end, this.onTap})
      : super(key: key);

  @override
  _DefTapAnimationState createState() => _DefTapAnimationState();
}

class _DefTapAnimationState extends State<DefTapAnimation>
    with TickerProviderStateMixin {
  late AnimationController animController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 100));
  late Animation<double> tapAnimation = Tween<double>(begin: 1, end: widget.end)
      .animate(CurvedAnimation(parent: animController, curve: Curves.easeIn));

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        animController.forward();
      },
      onTapUp: (_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        animController.reverse();

        if (widget.onTap != null) widget.onTap!();
      },
      onTapCancel: () {
        animController.reverse();
      },
      child: ScaleTransition(scale: tapAnimation, child: widget.child),
    );
  }
}
