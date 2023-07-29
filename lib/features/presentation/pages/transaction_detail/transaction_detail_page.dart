import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'package:coin_saver/features/presentation/pages/add_transaction/add_transaction_page.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../bloc/main_transaction/main_transaction_bloc.dart';

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
              Navigator.pushNamed(context, PageConst.addTransactionPage,
                  arguments: AddTransactionPage(
                    isIncome: transaction.isIncome,
                    account: account,
                    selectedDate: transaction.date,
                    transaction: transaction,
                    category: transaction.category,
                  ));
              context
                  .read<SelectedDateCubit>()
                  .changeStartDate(transaction.date);
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
              NumberFormat.currency(symbol: account.currency.symbol)
                  .format(transaction.amount),
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
              DateFormat.yMMMMEEEEd().format(transaction.date),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            sizeVer(30),
            TextButton.icon(
                onPressed: () {
                  _buildShowDialog(context);
                },
                icon: Icon(
                  FontAwesomeIcons.trashCan,
                  color: Colors.red.shade900,
                ),
                label: Text(
                  "Delete",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.red.shade900),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> _buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want to delete?"),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () async {
                        context.read<MainTransactionBloc>().add(
                              DeleteTransaction(
                                  transaction: transaction, account: account),
                            );

                        context
                            .read<AccountBloc>()
                            .add(SetPrimaryAccount(accountId: account.id));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Yes",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.red.shade900),
                      )),
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "No",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.grey),
                      )),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
