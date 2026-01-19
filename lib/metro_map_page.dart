import 'package:flutter/material.dart';

class MetroMapPage extends StatelessWidget {
  const MetroMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4,
      child: Center(
        child: Image.asset(
          'assets/images/cairo-subway-map.jpg.webp',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
