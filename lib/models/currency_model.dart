class Currency {
  final String name;
  final double rate;

  Currency({required this.name, required this.rate});

  factory Currency.fromJson(String name, dynamic rate) {
    return Currency(
      name: name,
      rate: rate,
    );
  }
}
