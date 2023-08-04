import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/presentation/pages/accounts_chapter/create_transfer/create_transfer_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          _amountToString = _accountFrom!.currency.code ==
                  _accountTo!.currency.code
              ? ""
              : "(${NumberFormat.currency(symbol: _accountTo!.currency.symbol).format(widget.transfer.amountTo)})";
          return Scaffold(
            appBar: AppBar(
              title:   Text(AppLocalizations.of(context)!.transferDetail),
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
                    Text(
                    AppLocalizations.of(context)!.transferFromAccount,
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
                    Text(
                    AppLocalizations.of(context)!.transferToAccount,
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
                    Text(
                    AppLocalizations.of(context)!.transferAmount,
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
                    Text(
                    AppLocalizations.of(context)!.day,
                    style:  const TextStyle(
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
                        color: Theme.of(context).colorScheme.error,
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.delete,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Theme.of(context).colorScheme.error),
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
          title:   Text(AppLocalizations.of(context)!.areYouSureYouWantToDelete),
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
                        AppLocalizations.of(context)!.yes,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Theme.of(context).colorScheme.error),
                      )),
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context)!.no,
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
