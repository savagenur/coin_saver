import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/constants/currencies.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/usecases/hive/first_init_user_usecase.dart';
import 'package:coin_saver/features/presentation/pages/home/home_page.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:coin_saver/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                "Choose your default currency",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              sizeVer(10),
              TextField(
                onChanged: _searchCurrency,
                decoration: const InputDecoration(
                    hintText: "Search",
                    suffixIcon: Icon(FontAwesomeIcons.magnifyingGlass)),
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
                title: "Next",
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  await sl<FirstInitUserUsecase>().call(_currency);
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        PageConst.homePage,
                        arguments: const HomePage(),
                        (route) => false);
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
