import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../../constants/constants.dart';
import '../../../../domain/entities/account/account_entity.dart';
import '../../../bloc/account/account_bloc.dart';

class AccountSwitchPullDownBtn extends StatelessWidget {
  final List<AccountEntity> accounts;
  final AccountEntity account;
  const AccountSwitchPullDownBtn({
    super.key,
    required this.accounts,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return PullDownButton(
      itemBuilder: (context) {
        return accounts
            .map((accountItem) => PullDownMenuItem.selectable(
                  onTap: () {
                    context
                        .read<AccountBloc>()
                        .add(SetPrimaryAccount(accountId: accountItem.id));
                  },
                  selected: accountItem.isPrimary,
                  title: accountItem.name,
                  subtitle:
                      NumberFormat.currency(symbol: accountItem.currency.symbol)
                          .format(accountItem.balance),
                  icon: accountItem.iconData,
                  iconColor: Theme.of(context).primaryColor,
                ))
            .toList();
      },
      buttonBuilder: (context, showMenu) {
        return GestureDetector(
          onTap: showMenu,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(account.iconData),
                    sizeHor(10),
                    Text(
                      account.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_sharp,
                    ),
                  ],
                ),
              ),
              Text(
                NumberFormat.currency(symbol: account.currency.symbol)
                    .format(account.balance),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: account.balance.round() > 0
                        ? Colors.white
                        : Colors.red.shade300),
              ),
            ],
          ),
        );
      },
    );
  }
}