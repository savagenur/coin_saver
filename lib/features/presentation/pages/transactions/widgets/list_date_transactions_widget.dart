import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../../../../constants/constants.dart';
import '../../../../domain/entities/account/account_entity.dart';
import '../../../../domain/entities/transaction/transaction_entity.dart';
import '../../main_transaction/main_transaction_page.dart';
import '../../transaction_detail/transaction_detail_page.dart';

class ListDateTransactionsWidget extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final List<AccountEntity> accounts;
  final AccountEntity account;
  final Filter selectedFilter;

  const ListDateTransactionsWidget({
    Key? key,
    required this.transactions,
    required this.accounts,
    required this.account,
    required this.selectedFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var itemLength = 0;
    return selectedFilter == Filter.byAmount
        ? ListView.builder(
            itemCount: transactions.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < transactions.length) {
                var transaction = transactions[index];
                var previousTransaction = transactions[index];
                if (index > 0) {
                  previousTransaction = transactions[index - 1];
                }
                var date = DateTime(transaction.date.year,transaction.date.month,transaction.date.day);
                var previousDate = DateTime(previousTransaction.date.year,previousTransaction.date.month,previousTransaction.date.day);
                final coreAccount = accounts.firstWhere(
                    (element) => element.id == transaction.accountId,
                    orElse: () => accountError);
                final coreTransaction =
                    coreAccount.transactionHistory.firstWhere(
                  (element) => transaction.id == element.id,
                  orElse: () => transactionError,
                );
                // print(index);
                // print(index-1);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    date == previousDate &&index!=0
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            child: Text(
                              DateFormat.yMMMEd().format(transaction.date),
                              style: const TextStyle(
                                color: secondaryColor,
                              ),
                            ),
                          ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                            context, PageConst.transactionDetailPage,
                            arguments: TransactionDetailPage(
                              transaction: coreTransaction,
                              account: coreAccount,
                            ));
                      },
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      minVerticalPadding: 0,
                      leading: CircleAvatar(
                        backgroundColor: transaction.color,
                        child: Icon(
                          transaction.iconData,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(transaction.category.name),
                      subtitle:
                          account.id == "total" ? Text(coreAccount.name) : null,
                      trailing: Text(
                        NumberFormat.currency(symbol: account.currency.symbol)
                            .format(transaction.amount),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox(height: 50.0); // Add space at the end
              }
            },
          )
        : GroupedListView(
            elements: transactions,
            itemComparator: (a, b) => a.date.compareTo(b.date),
            order: GroupedListOrder.DESC,
            groupBy: (element) => DateTime(
              element.date.year,
              element.date.month,
              element.date.day,
            ),
            groupSeparatorBuilder: (value) => Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                DateFormat.yMMMEd().format(value),
                style: const TextStyle(
                  color: secondaryColor,
                ),
              ),
            ),
            itemBuilder: (context, element) {
              var transaction = element;

              final coreAccount = accounts.firstWhere(
                  (element) => element.id == transaction.accountId,
                  orElse: () => accountError);
              final coreTransaction = coreAccount.transactionHistory.firstWhere(
                (element) => transaction.id == element.id,
                orElse: () => transactionError,
              );
              itemLength += 1;
              if (transactions.length == itemLength) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                            context, PageConst.transactionDetailPage,
                            arguments: TransactionDetailPage(
                              transaction: coreTransaction,
                              account: coreAccount,
                            ));
                      },
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      minVerticalPadding: 0,
                      leading: CircleAvatar(
                        backgroundColor: transaction.color,
                        child: Icon(
                          transaction.iconData,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(transaction.category.name),
                      subtitle:
                          account.id == "total" ? Text(coreAccount.name) : null,
                      trailing: Text(
                        NumberFormat.currency(symbol: account.currency.symbol)
                            .format(transaction.amount),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    sizeVer(100),
                  ],
                );
              }
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.transactionDetailPage,
                      arguments: TransactionDetailPage(
                        transaction: coreTransaction,
                        account: coreAccount,
                      ));
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                minVerticalPadding: 0,
                leading: CircleAvatar(
                  backgroundColor: transaction.color,
                  child: Icon(
                    transaction.iconData,
                    color: Colors.white,
                  ),
                ),
                title: Text(transaction.category.name),
                subtitle: account.id == "total" ? Text(coreAccount.name) : null,
                trailing: Text(
                  NumberFormat.currency(symbol: account.currency.symbol)
                      .format(transaction.amount),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            },
          );
    ;
  }
}
