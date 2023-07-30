import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/presentation/pages/accounts_page/create_transfer/create_transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../constants/constants.dart';
import '../../../bloc/account/account_bloc.dart';
import '../../../bloc/main_transaction/main_transaction_bloc.dart';

class TransferDetailPage extends StatefulWidget {
  final TransactionEntity transfer;
  const TransferDetailPage({super.key, required this.transfer});

  @override
  State<TransferDetailPage> createState() => _TransferDetailPageState();
}

class _TransferDetailPageState extends State<TransferDetailPage> {
  AccountEntity? _accountFrom;
  AccountEntity? _accountTo;
  String _amountFromString = "";
  String _amountToString = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        if (accountState is AccountLoaded) {
          _accountFrom = accountState.accounts.firstWhere(
              (element) => element.id == widget.transfer.accountFromId);
          _accountTo = accountState.accounts.firstWhere(
              (element) => element.id == widget.transfer.accountToId);
          _amountFromString =
              NumberFormat.currency(symbol: _accountFrom!.currency.symbol)
                  .format(widget.transfer.amountFrom);
          _amountToString = _accountFrom!.currency.symbol ==
                  _accountTo!.currency.symbol
              ? ""
              : "(${NumberFormat.currency(symbol: _accountTo!.currency.symbol).format(widget.transfer.amountTo)})";
          return Scaffold(
            appBar: AppBar(
              title: const Text("Transfer Details"),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PageConst.createTransferPage,
                        arguments: CreateTransferPage(
                          selectedDate: widget.transfer.date,
                          accountFrom: _accountFrom,
                          accountTo: _accountTo,
                          amountFrom: widget.transfer.amountFrom!,
                          amountTo: widget.transfer.amountTo!,
                          isUpdate: true,
                          transfer: widget.transfer,
                        ));
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
                    "Transfer from account",
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                  sizeVer(5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: _accountFrom!.color,
                        child: Icon(
                          _accountFrom!.iconData,
                          color: Colors.white,
                        ),
                      ),
                      sizeHor(10),
                      Text(
                        _accountFrom!.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  sizeVer(20),
                  const Text(
                    "Transfer to account",
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                  sizeVer(5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: _accountTo!.color,
                        child: Icon(
                          _accountTo!.iconData,
                          color: Colors.white,
                        ),
                      ),
                      sizeHor(10),
                      Text(
                        _accountTo!.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  sizeVer(20),
                  const Text(
                    "Transfer amount",
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                  sizeVer(5),
                  Text(
                    "$_amountFromString $_amountToString",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w500),
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
                    DateFormat.yMMMMEEEEd().format(widget.transfer.date),
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
        return const Scaffold();
      },
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
                        // context.read<MainTransactionBloc>().add(
                        //       DeleteTransaction(
                        //           transaction: widget.transfer, account: account),
                        //     );

                        context.read<AccountBloc>().add(DeleteTransfer(
                            accountFrom: _accountFrom!,
                            accountTo: _accountTo!,
                            transactionEntity: widget.transfer));
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
