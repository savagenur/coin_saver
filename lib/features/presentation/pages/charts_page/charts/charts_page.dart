// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../../../../data/models/exchange_rate/exchange_rate_model.dart';

// class ExchangeRatePage extends StatelessWidget {
//   final List<ExchangeRateModel> exchangeRates;
//   const ExchangeRatePage({super.key, required this.exchangeRates});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: exchangeRates
//               .map((e) => Column(
//                     children: [
//                       Text(e.base),
//                       ...e.rates
//                           .map((rate) => ListTile(
//                                 leading: Text(rate.rateName),
//                                 title: Text(rate.rate.toString()),
//                               ))
//                           .toList()
//                     ],
//                   ))
//               .toList(),
//         ),
//       ),
//     );
//   }
// }


