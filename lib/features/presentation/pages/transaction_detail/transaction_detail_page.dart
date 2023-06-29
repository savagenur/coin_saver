import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, PageConst.addTransactionPage);
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizeVer(10),
            Text(
              "Amount",
              style: TextStyle(
                color: secondaryColor,
              ),
            ),
            sizeVer(5),
            Text(
              "c450",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
            sizeVer(20),
            Text(
              "Account",
              style: TextStyle(
                color: secondaryColor,
              ),
            ),
            sizeVer(5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 15,
                  child: Icon(Icons.attach_money_outlined),
                ),
                sizeHor(10),
                Text(
                  "Main",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
            sizeVer(20),
            Text(
              "Category",
              style: TextStyle(
                color: secondaryColor,
              ),
            ),
            sizeVer(5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 15,
                  child: Icon(Icons.attach_money_outlined),
                ),
                sizeHor(10),
                Text(
                  "Groceries",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
            sizeVer(20),
            Text(
              "Day",
              style: TextStyle(
                color: secondaryColor,
              ),
            ),
            sizeVer(5),
            Text(
              "June 30, 2023",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
            sizeVer(30),
            MyButtonWidget(
              title: "Delete",
              backgroundColor: Colors.red,
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
