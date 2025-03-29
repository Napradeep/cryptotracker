class CryptoPrice {
  final String symbol;
  final double price;

  CryptoPrice({required this.symbol, required this.price});

  factory CryptoPrice.fromJson(Map<String, dynamic> json) {
    return CryptoPrice(
      symbol: json['s'],
      price: double.tryParse(json['p'].toString()) ?? 0.0,
    );
  }
}
