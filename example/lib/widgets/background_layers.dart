import 'package:flutter/material.dart';

class BackgroundLayers extends StatelessWidget {
  const BackgroundLayers({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF6F1EA), Color(0xFFEFE6D8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFFFD6A5), Color(0x00FFD6A5)],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left: -20,
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFBDE0FE), Color(0x00BDE0FE)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
