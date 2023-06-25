import 'package:flutter/material.dart';

class DayNavigationWidget extends StatelessWidget {
  const DayNavigationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.calendar_month_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          "Yesterday, June 24",
          style:
              TextStyle(decoration: TextDecoration.underline),
        ),
      ],
    );
  }
}