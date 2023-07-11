import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';

class CategoryTile extends StatelessWidget {
  final MainTransactionEntity mainTransaction;
  final AccountEntity account;
  final double totalExpense;
  const CategoryTile({
    Key? key,
    required this.mainTransaction,
    required this.account,
    required this.totalExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(blurRadius: 1, spreadRadius: .001),
        ],
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.black,
        leading: CircleAvatar(
          backgroundColor: mainTransaction.color,
          child: Icon(
            mainTransaction.iconData,
            color: Colors.white,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 3, child: Text(mainTransaction.name)),
            Flexible(
              flex: 1,
              child: Text(
                NumberFormat.percentPattern()
                    .format(mainTransaction.totalAmount / totalExpense),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${account.currency.symbol}${NumberFormat.compact().format(mainTransaction.totalAmount)}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
      ),
    );
  }
}
