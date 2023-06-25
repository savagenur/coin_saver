import 'package:flutter/material.dart';

class ShadowedContainerWidget extends StatelessWidget {
  final BorderRadius borderRadius;
  final Widget child;
  const ShadowedContainerWidget(
      {super.key, required this.borderRadius, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(blurRadius: 1, spreadRadius: .001),
        ],
        borderRadius: borderRadius,
        color: Colors.white,
      ),
      child: child,
    );
  }
}
