import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  final List<Color> colors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.teal,
    Colors.redAccent,
  ];

  late Color color1;
  late Color color2;

  @override
  void initState() {
    super.initState();
    _setRandomColors();
    Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _setRandomColors();
      });
    });
  }

  void _setRandomColors() {
    final random = Random();
    color1 = colors[random.nextInt(colors.length)];
    color2 = colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: widget.child,
    );
  }
}