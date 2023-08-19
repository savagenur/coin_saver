import 'package:coin_saver/features/domain/usecases/exchange_rates/update_single_exchange_rate_from_api_usecase.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:coin_saver/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:coin_saver/constants/currencies.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';

import '../../../constants/constants.dart';

class SelectCurrencyWidget extends StatefulWidget {
  final CurrencyEntity currency;
  final void Function(CurrencyEntity?) setCurrency;
  const SelectCurrencyWidget({
    Key? key,
    required this.currency,
    required this.setCurrency,
  }) : super(key: key);

  @override
  State<SelectCurrencyWidget> createState() => SelectCurrencyWidgetState();
}

class SelectCurrencyWidgetState extends State<SelectCurrencyWidget> {
  late final List<CurrencyEntity> _currencies;
  CurrencyEntity? _currency;
  String _searchQuery = "";
  List<CurrencyEntity> _filteredCurrencies = [];
  void _searchCurrency(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCurrencies = _currencies.where((currency) {
        return currency.name.toLowerCase().contains(query.toLowerCase()) ||
            currency.code.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();

    _currencies =
        currencies.where((element) => element != widget.currency).toList();
  }

  @override
  Widget build(BuildContext context) {
    _filteredCurrencies =
        _searchQuery != "" ? _filteredCurrencies : _currencies;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(FontAwesomeIcons.arrowLeft)),
        title: Text(AppLocalizations.of(context)!.currency),
      ),
      body: Column(
        children: [
          sizeVer(5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
              elevation: 3,
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                onChanged: _searchCurrency,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    hintText: AppLocalizations.of(context)!.search,
                    suffixIcon: const Icon(FontAwesomeIcons.magnifyingGlass)),
              ),
            ),
          ),
          sizeVer(10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(_filteredCurrencies.length, (index) {
                    final currency = _filteredCurrencies[index];

                    return ListTile(
                      selected: _currency == currency,
                      onTap: () {
                        setState(() {
                          _currency = currency;
                        });
                      },
                      title: Text(
                        currency.name,
                        style: TextStyle(
                            fontWeight: _currency == currency
                                ? FontWeight.w600
                                : FontWeight.normal),
                      ),
                      trailing: Text(currency.code,
                          style: TextStyle(
                              fontWeight: _currency == currency
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                    );
                  }),
                  sizeVer(70),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MyButtonWidget(
        title: AppLocalizations.of(context)!.select,
        onTap: _currency == null
            ? null
            : () async {
                widget.setCurrency(_currency);
                await sl<UpdateSingleExchangeRateFromApiUsecase>()
                    .call(_currency!.code);
                if (mounted) {
                  Navigator.pop(context);
                }
              },
        width: MediaQuery.of(context).size.width * .4,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
