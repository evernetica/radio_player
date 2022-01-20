import 'package:flutter/material.dart';

class ScreenPlayer extends StatelessWidget {
  const ScreenPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: const Center(
        child: Text("Player"),
      ),
    );
  }
}
