import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../constants/constants.dart';
import '../../../../domain/entities/account/account_entity.dart';
import '../../../../domain/entities/transaction/transaction_entity.dart';
import '../../transaction_detail/transaction_detail_page.dart';

class ListDateTransactionsWidget extends StatelessWidget {
  final Map<DateTime, List<TransactionEntity>> _filteredTransactionsMap;
  final AccountEntity _account;
  final List<AccountEntity> _accounts;
  
  const ListDateTransactionsWidget({
    super.key,
    required Map<DateTime, List<TransactionEntity>> filteredTransactionsMap,
    required AccountEntity account,
    required List<AccountEntity> accounts,
  })  : _filteredTransactionsMap = filteredTransactionsMap,
        _account = account,
        _accounts = accounts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
          _filteredTransactionsMap.keys.length,
          (keyIndex) {
            DateTime dateTime =
                _filteredTransactionsMap.keys.elementAt(keyIndex);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMEd().format(dateTime),
                  style: const TextStyle(
                    color: secondaryColor,
                  ),
                ),
                ...List.generate(
                    _filteredTransactionsMap.values.elementAt(keyIndex).length,
                    (valueIndex) {
                  var transaction = _filteredTransactionsMap[
                      _filteredTransactionsMap.keys
                          .elementAt(keyIndex)]![valueIndex];
                  String accountName = _accounts
                      .firstWhere(
                        (element) => element.id == transaction.accountId,
                        orElse: () => accountError,
                      )
                      .name;

                  return ListTile(
                    onTap: () async {
                      Navigator.pushNamed(
                          context, PageConst.transactionDetailPage,
                          arguments: TransactionDetailPage(
                            transaction: transaction,
                            account: _accounts.firstWhere(
                                (element) =>
                                    element.id == transaction.accountId,
                                orElse: () => accountError),
                          ));
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: transaction.color,
                      child: Icon(
                        transaction.iconData,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(transaction.category.name),
                    subtitle: _account.id == "total" ? Text(accountName) : null,
                    trailing: Text(
                      NumberFormat.currency(symbol: _account.currency.symbol)
                          .format(transaction.amount),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }),
                sizeVer(10)
              ],
            );
          },
        ),
        sizeVer(70),
      ],
    );
  }
}
