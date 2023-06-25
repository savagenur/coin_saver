import 'package:flutter/material.dart';

class MyButtonWidget extends StatelessWidget {
  final String title;
  final double? width;
  final double? paddingVertical;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  const MyButtonWidget({
    super.key,
    required this.title,
    this.width,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.paddingVertical, this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.zero,
          ),
          backgroundColor: backgroundColor,
        ),
        onPressed: onTap,
        child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: paddingVertical ?? 10,
            ),
            child: Text(
              title,
              style:textStyle?? Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            )),
      ),
    );
  }
}
