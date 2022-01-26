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
    // #docregion addListener
    animation = Tween<double>(begin: -width, end: width).animate(controller)
      ..addListener(() {
        // #enddocregion addListener
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
        // #docregion addListener
      });
    // #enddocregion addListener
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

//
// @override
// Widget build(BuildContext context) {
//   return Positioned(
//     left: animation.value,
//     height: MediaQuery.of(context).size.height * 2,
//     width: MediaQuery.of(context).size.width*2,
//     child: FractionallySizedBox(
//       widthFactor: 0.5,
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             transform: GradientRotation(0.25),
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//             colors: [
//               Colors.black,
//               Colors.white30,
//               Colors.white30,
//               Colors.white70,
//               Colors.white70,
//               Colors.white30,
//               Colors.white30,
//               Colors.red,
//               Colors.red,
//               Colors.black,
//             ],
//             stops: [0.2, 0.21, 0.45, 0.46, 0.55, 0.56, 0.69, 0.7, 0.71, 0.72],
//           ),
//         ),
//       ),
//     ),
//   );
// }
