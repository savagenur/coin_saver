import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CalculatorPage extends StatefulWidget {
  final double currentValue;
  final void Function(double)? setAmount;
  const CalculatorPage({
    Key? key,
    this.currentValue = 0,
    required this.setAmount,
  }) : super(key: key);

  @override
  State<CalculatorPage> createState() => CalculatorPageState();
}

class CalculatorPageState extends State<CalculatorPage> {
  late double _currentValue;
  bool _isDone = false;
  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text(AppLocalizations.of(context)!.calculator),
      ),
      body: SimpleCalculator(
        maximumDigits: 12,
        value: _currentValue,
        onChanged: (key, value, expression) {
          if (key == "=") {
            _currentValue = value!;
            setState(() {
              _isDone = true;
            });
          } else {
            setState(() {
              _isDone = false;
            });
          }
        },
        theme: const CalculatorThemeData(),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 50,
        child: ElevatedButton.icon(
            onPressed: _isDone
                ? () {
                    widget.setAmount!(_currentValue);
                    Navigator.pop(context);
                  }
                : null,
            icon: const Icon(FontAwesomeIcons.check),
            label: Text(
              AppLocalizations.of(context)!.done,
              style: const TextStyle(fontSize: 25),
            )),
      ),
    );
  }
}
