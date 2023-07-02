import 'package:flutter/material.dart';

import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';

class CategoryTile extends StatelessWidget {
  final MainTransactionEntity mainTransaction;
  final double totalExpense;
  const CategoryTile({
    Key? key,
    required this.mainTransaction,
    required this.totalExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 1, spreadRadius: .001),
        ],
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.black,
        leading:  CircleAvatar(
          child: Icon(mainTransaction.iconData),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(mainTransaction.name)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "%${( 100 * mainTransaction.totalAmount/totalExpense ).round()}"),
              ],
            )
          ],
        ),
        leadingAndTrailingTextStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
        trailing: Text("\$${mainTransaction.totalAmount}",
            overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
