import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/main_transaction/main_transaction_bloc.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionDetailPage extends StatelessWidget {
  final TransactionEntity transaction;
  final AccountEntity account;
  const TransactionDetailPage(
      {super.key, required this.transaction, required this.account});

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
            const Text(
              "Amount",
              style: TextStyle(
                color: secondaryColor,
              ),
            ),
            sizeVer(5),
            Text(
              NumberFormat.currency(symbol: account.currency.symbol).format(transaction.amount),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            sizeVer(20),
            const Text(
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
                  backgroundColor: account.color,
                  child: Icon(
                    account.iconData,
                    color: Colors.white,
                  ),
                ),
                sizeHor(10),
                Text(
                  account.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            sizeVer(20),
            const Text(
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
                  backgroundColor: transaction.color,
                  child: Icon(
                    transaction.iconData,
                    color: Colors.white,
                  ),
                ),
                sizeHor(10),
                Text(
                  transaction.category.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            sizeVer(20),
            const Text(
              "Day",
              style: TextStyle(
                color: secondaryColor,
              ),
            ),
            sizeVer(5),
            Text(
              DateFormat.yMMMEd().format(transaction.date),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            sizeVer(30),
            MyButtonWidget(
              title: "Delete",
              backgroundColor: Colors.red,
              onTap: () {
                context
                    .read<MainTransactionBloc>()
                    .add(DeleteMainTransaction(transactionEntity: transaction));
                context.read<AccountBloc>().add(DeleteTransaction(
                    accountEntity: account, transactionEntity: transaction));
                
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
