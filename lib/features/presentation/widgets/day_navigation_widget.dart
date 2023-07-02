import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/main_transaction/main_transaction_entity.dart';
import '../bloc/main_transaction/main_transaction_bloc.dart';

class DayNavigationWidget extends StatelessWidget {
  final AccountEntity account;
  final DateTime dateTime;
  const DayNavigationWidget({
    super.key,
    required this.account, required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    

                    // await  Hive.box<MainTransactionModel>(BoxConst.mainTransactions).clear();
                  },
                  icon: Icon(
                    Icons.calendar_month_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          "Yesterday, June 24",
          style: TextStyle(decoration: TextDecoration.underline),
        ),
      ],
    );
  }
}
