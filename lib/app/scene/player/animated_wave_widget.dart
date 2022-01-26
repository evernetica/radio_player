import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedWave extends StatefulWidget {
  const AnimatedWave(this.context, this.direction, {Key? key})
      : super(key: key);

  final BuildContext context;
  final int direction;

  @override
  _AnimatedWaveState createState() => _AnimatedWaveState();
}

class _AnimatedWaveState extends State<AnimatedWave>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    double width = MediaQuery.of(widget.context).size.width;

    controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animation = Tween<double>(begin: -width, end: width).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedWave oldWidget) {
    controller.reset();
    controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: widget.direction == 1 ? -animation.value : animation.value,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.1,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: const [
                    Colors.black,
                    Colors.red,
                  ],
                      transform: widget.direction == 1
                          ? const GradientRotation(pi)
                          : null)),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
