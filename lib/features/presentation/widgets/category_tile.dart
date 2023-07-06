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
          backgroundColor: mainTransaction.color,
          child: Icon(mainTransaction.iconData,color: Colors.white,),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(mainTransaction.name)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "%${ totalExpense!=0?( 100 * mainTransaction.totalAmount/totalExpense ).round():0}"),
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
