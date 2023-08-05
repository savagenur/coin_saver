import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/constants/currencies.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/usecases/hive/first_init_user_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/first_launch/first_launch_cubit.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:coin_saver/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseDefaultCurrencyPage extends StatefulWidget {
  const ChooseDefaultCurrencyPage({super.key});

  @override
  State<ChooseDefaultCurrencyPage> createState() =>
      _ChooseDefaultCurrencyPageState();
}

class _ChooseDefaultCurrencyPageState extends State<ChooseDefaultCurrencyPage> {
  String _searchQuery = "";
  CurrencyEntity _currency = currencies.first;
  List<CurrencyEntity> _filteredCurrencies = [];

  @override
  void initState() {
    super.initState();
    sl<AwesomeNotifications>().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        sl<AwesomeNotifications>().requestPermissionToSendNotifications();
      } else {
        sl<AwesomeNotifications>().createNotification(
            content: NotificationContent(
          id: -10,
          channelKey: "scheduled",
        ));
      }
    });
  }

  void _searchCurrency(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCurrencies = currencies.where((currency) {
        return currency.name.toLowerCase().contains(query.toLowerCase()) ||
            currency.code.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _filteredCurrencies = _searchQuery != "" ? _filteredCurrencies : currencies;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.chooseYourDefaultCurrency,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              sizeVer(10),
              TextField(
                textCapitalization: TextCapitalization.sentences,
                onChanged: _searchCurrency,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.search,
                    suffixIcon: const Icon(FontAwesomeIcons.magnifyingGlass)),
              ),
              sizeVer(20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      children: _filteredCurrencies
                          .map((currency) => ListTile(
                                selected: _currency == currency,
                                title: Text(currency.name),
                                onTap: () {
                                  setState(() {
                                    _currency = currency;
                                  });
                                },
                                selectedColor: Colors.blueAccent,
                                trailing: Text(currency.code),
                              ))
                          .toList()),
                ),
              ),
              sizeVer(20),
              MyButtonWidget(
                title: AppLocalizations.of(context)!.next,
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  await sl<FirstInitUserUsecase>().call(
                      _currency,
                      AppLocalizations.of(context)!.total,
                      AppLocalizations.of(context)!.main,
                      "Coin Saver",
                      AppLocalizations.of(context)!
                          .donTForgetToRecordURExpenses);
                  if (mounted) {
                    context.read<FirstLaunchCubit>().changeIsFirstLaunch(false);
                    showDialog(
                      context: context,
                      builder: (context) => Container(
                        color: Colors.black12,
                        width: double.infinity,
                        height: double.infinity,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                    await Future.delayed(const Duration(seconds: 1));

                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, PageConst.homePage, (route) => false);
                    }
                  }
                },
                width: MediaQuery.of(context).size.width * .5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
