import 'package:flutter/material.dart';

class AnimatedSplash extends StatefulWidget {
  const AnimatedSplash(this.context, this.isTurningOn, {Key? key})
      : super(key: key);

  final BuildContext context;
  final bool isTurningOn;

  @override
  _AnimatedSplashState createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplash>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late Animation<Color?> animationColor;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    double width = MediaQuery.of(widget.context).size.width;

    controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);

    animation =
        Tween<double>(begin: width * 0.85 - 3, end: width).animate(controller)
          ..addListener(() {
            setState(() {});
          });
    animationColor = ColorTween(
            begin: widget.isTurningOn ? Colors.white : Colors.red,
            end: Colors.transparent)
        .animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedSplash oldWidget) {
    animationColor = ColorTween(
            begin: widget.isTurningOn ? Colors.white : Colors.red,
            end: Colors.transparent)
        .animate(controller);
    controller.reset();
    controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: animation.value,
      height: animation.value,
      decoration: BoxDecoration(
        border: Border.all(
          color: MaterialStateColor.resolveWith(
              (states) => animationColor.value ?? Colors.transparent),
          width: 3,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
