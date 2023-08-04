import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:coin_saver/features/domain/entities/account/account_entity.dart';

import '../../../constants/constants.dart';
import '../../domain/entities/transaction/transaction_entity.dart';
import '../pages/main_transaction/main_transaction_page.dart';

class CategoryTile extends StatelessWidget {
  final TransactionEntity mainTransaction;
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
    return Card(
      elevation: 2,
      shape: OutlineInputBorder(borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),

      ),
      child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
           shape: OutlineInputBorder(borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),

      ),
          onTap: () {
             Navigator.pushNamed(context,
                                                  PageConst.mainTransactionPage,
                                                  arguments:
                                                      MainTransactionPage(
                                                    mainTransaction:
                                                        mainTransaction,
                                                  ));
          },
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
              Expanded(flex: 7, child: Text(mainTransaction.category.name)),
              Flexible(
                flex: 3,
                child: Text(
                  NumberFormat.percentPattern()
                      .format(mainTransaction.amount / totalExpense),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  NumberFormat.compactCurrency(symbol: account.currency.symbol,decimalDigits: 0,)
                        .format(mainTransaction.amount)
                  ,
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
