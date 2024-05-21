import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String apiKey = 'fca_live_f4rBklsmze6OZNgjt0kXq2Xxfj7495dJDgidLV6B';

  Future<List<double>> fetchCurrencies(String baseCurrency, String targetCurrency, double amount) async {
    final String apiUrl = 'https://api.freecurrencyapi.com/v1/latest?apikey=$apiKey&currencies=$targetCurrency&base_currency=$baseCurrency';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      double rate = data[targetCurrency].toDouble();
      final double answer = rate * amount;
      return [rate, answer];
    } else {
      throw Exception('Failed to load currency data');
    }
  }


}