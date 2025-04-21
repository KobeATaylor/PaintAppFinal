import 'dart:async';
import 'dart:math';
import 'Gradient.dart';
import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paint Canvas")),
      body: AnimatedBackground(
        child: const Center(
          child: Text(
            'This is a new page (Paint Canvas coming soon!)',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}