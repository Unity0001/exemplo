import 'package:flutter/material.dart';

class GreenGradientBackground extends StatelessWidget {
  final Widget child;

  const GreenGradientBackground({Key? key, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA8E6CF), Color(0xFFDCEDC2), Color(0xFFE0F7FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
