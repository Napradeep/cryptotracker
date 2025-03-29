class CryptoData {
  final double open, high, low, close;

  CryptoData({required this.open, required this.high, required this.low, required this.close});

  factory CryptoData.fromJson(List<dynamic> json) {
    return CryptoData(
      open: double.parse(json[1].toString()),
      high: double.parse(json[2].toString()),
      low: double.parse(json[3].toString()),
      close: double.parse(json[4].toString()),
    );
  }
}
