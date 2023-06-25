import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 1, spreadRadius: .001)],
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.black,
        leading: const CircleAvatar(
          child: Icon(Icons.people),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Education"),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("64%"),
              ],
            )
          ],
        ),
        leadingAndTrailingTextStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
        trailing: Text("\$20,005"),
      ),
    );
  }
}