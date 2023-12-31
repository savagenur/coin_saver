import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/currency/currency_bloc.dart';
import 'package:coin_saver/features/presentation/pages/accounts_chapter/create_transfer/create_transfer_page.dart';
import 'package:coin_saver/features/presentation/pages/accounts_chapter/crud_account/crud_account_page.dart';
import 'package:coin_saver/features/presentation/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';


class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    late CurrencyEntity _mainCurrency;

    return WillPopScope(
      onWillPop: () async {
       
        Navigator.popUntil(context, (route) => route.settings.name==PageConst.homePage);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const MyDrawer(),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(FontAwesomeIcons.bars)),
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.accounts),
        ),
        body: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, currencyState) {
            if (currencyState is CurrencyLoaded) {
              _mainCurrency = currencyState.currency;
              return BlocBuilder<AccountBloc, AccountState>(
                builder: (context, accountState) {
                  if (accountState is AccountLoaded) {
                    final totalAccount = accountState.accounts.firstWhere(
                      (element) => element.id == "total",
                      orElse: () => accountError,
                    );
                    final accounts = accountState.accounts
                        .where((element) => element.id != "total")
                        .toList();
                    return Column(
                      children: [
                        sizeVer(30),
                        Text(
                          "${AppLocalizations.of(context)!.total}:",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          NumberFormat.currency(
                                  symbol: totalAccount.currency.symbol)
                              .format(totalAccount.balance),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 26),
                        ),
                        sizeVer(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTransferButton(
                              context: context,
                              title: AppLocalizations.of(context)!
                                  .transferHistory,
                              iconData: FontAwesomeIcons.clockRotateLeft,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageConst.transferHistoryPage);
                              },
                            ),
                            _buildTransferButton(
                              context: context,
                              title:
                                  AppLocalizations.of(context)!.newTransfer,
                              iconData: FontAwesomeIcons.rightLeft,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageConst.createTransferPage,
                                    arguments: const CreateTransferPage());
                              },
                            ),
                          ],
                        ),
                        sizeVer(10),
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                        sizeVer(10),
                              ...accounts
                                .map(
                                  (account) => Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 10, bottom: 10),
                                    child: Card(
                                      elevation: 3,
                                      shape: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              PageConst.cRUDAccountPage,
                                              arguments: CRUDAccountPage(
                                                mainCurrency: _mainCurrency,
                                                isUpdatePage: true,
                                                account: account,
                                              ));
                                        },
                                        shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: account.color,
                                          child: Icon(
                                            account.iconData,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(account.name),
                                        trailing: Text(
                                          NumberFormat.compactCurrency(
                                            symbol: account.currency.symbol,
                                            decimalDigits: 2,
                                          ).format(account.balance),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        sizeVer(100)
                                ],
                          ),
                        )),
                      ],
                    );
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, PageConst.cRUDAccountPage,
                arguments: CRUDAccountPage(mainCurrency: _mainCurrency));
          },
          child: const Icon(FontAwesomeIcons.plus),
        ),
      ),
    );
  }

  Expanded _buildTransferButton({
    required BuildContext context,
    required String title,
    required IconData iconData,
    required Function()? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(
                  iconData,
                  color: Colors.white,
                ),
              ),
              sizeVer(5),
              Text(title)
            ],
          ),
        ),
      ),
    );
  }
}
