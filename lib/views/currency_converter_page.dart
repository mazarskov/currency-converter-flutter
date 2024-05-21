import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import 'package:intl/intl.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final CurrencyService _currencyService = CurrencyService();
  final List<String> _supportedCurrencies = [
    "EUR", "USD", "JPY", "BGN", "CZK", "DKK", "GBP", "HUF", "PLN", "RON", "SEK",
    "CHF", "ISK", "NOK", "HRK", "RUB", "TRY", "AUD", "BRL", "CAD", "CNY", "HKD",
    "IDR", "ILS", "INR", "KRW", "MXN", "MYR", "NZD", "PHP", "SGD", "THB", "ZAR"
  ];

  String _baseCurrency = 'EUR';
  String _targetCurrency = 'EUR';
  double _rate = 0.0;
  double _inputAmount = 0.0;
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  late String _currentDate = '';

  @override
  void initState() {
    super.initState();
    _getCurrentDate();
  }

  void _getCurrentDate() {
    setState(() {
      _currentDate = DateFormat('d/M/y').format(DateTime.now());
    });
  }

  void _setInputAmount(String value) {
    setState(() {
      _inputAmount = double.tryParse(value) ?? 0.0;
    });
  }

  void _setBaseCurrency(String? currency) {
    setState(() {
      _baseCurrency = currency!;
    });
  }

  void _setTargetCurrency(String? currency) {
    setState(() {
      _targetCurrency = currency!;
    });
  }

  Future<void> _convertCurrency() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<double> results = await _currencyService.fetchCurrencies(
        _baseCurrency,
        _targetCurrency,
        _inputAmount,
      );
      setState(() {
        _convertedAmount = results[1];
        _rate = results[0];
      });
    } catch (e) {
      setState(() {
        _convertedAmount = 0.0;
        _rate = 0.0;
      });

    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onChanged: _setInputAmount,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DropdownButton<String>(
                  value: _baseCurrency,
                  onChanged: _setBaseCurrency,
                  items: _supportedCurrencies.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: _targetCurrency,
                  onChanged: _setTargetCurrency,
                  items: _supportedCurrencies.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Convert'),
            ),
            const SizedBox(height: 20),
            Text(
              'Converted Amount: ${_convertedAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Rate: ${_rate.toStringAsFixed(6)}',
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 20),
            Text(
              'Date: $_currentDate', // Display today's date
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
