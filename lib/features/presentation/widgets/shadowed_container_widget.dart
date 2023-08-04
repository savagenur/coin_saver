import 'package:flutter/material.dart';

class ShadowedContainerWidget extends StatelessWidget {
  final BorderRadius borderRadius;
  final Widget child;
  final double? height;
  const ShadowedContainerWidget(
      {super.key, required this.borderRadius, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4  ,
      shape: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none
      ),
      child: Container(
        height: height,
        decoration: BoxDecoration(
         borderRadius: borderRadius,
          color: Theme.of(context).listTileTheme.tileColor,
        ),
        child: child,
      ),
    );
  }
}
