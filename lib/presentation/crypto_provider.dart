import 'dart:developer';

import 'package:flutter/material.dart';

import '../data/crypto_repository.dart';
import '../domain/crypto_model.dart';

class CryptoProvider with ChangeNotifier {
  final CryptoRepository _repository = CryptoRepository();

  String _selectedCrypto = "BTCUSDT";
  String get selectedCrypto => _selectedCrypto;

  CryptoPrice? _cryptoPrice;
  CryptoPrice? get cryptoPrice => _cryptoPrice;

  List<CryptoPrice> _historicalData = [];
  List<CryptoPrice> get historicalData => _historicalData;

  List<CryptoPrice> _monthlyData = [];
  List<CryptoPrice> get montlyData => _monthlyData;

  Stream<CryptoPrice>? _priceStream;

  void setCrypto(String symbol) {
    _selectedCrypto = symbol;
    notifyListeners();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _priceStream = _repository.connectToWebSocket(_selectedCrypto);
    _priceStream!.listen((price) {
      _cryptoPrice = price;
      _historicalData.add(price);

      if (_historicalData.length > 50) {
        _historicalData.removeAt(0);
      }

      log("📈 WebSocket Price Update: ${price.symbol} - \$${price.price}");
      notifyListeners();
    });
  }

  Future<void> fetchHistoricalData(String interval) async {
    try {
      _historicalData = await _repository.fetchHistoricalData(
        _selectedCrypto,
        interval,
      );
      log("📊 Historical Data Loaded: ${_historicalData.length} entries");
      notifyListeners();
    } catch (e) {
      log("❌ Error fetching historical data: $e");
    }
  }

  // Future<List<CryptoPrice>> fetchMonthlyData(DateTime date) async {
  //   try {
  //     String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-01";
  //     _monthlyData = await _repository.fetchMonthlyData(_selectedCrypto, formattedDate);
      
  //     notifyListeners();
  //     return _monthlyData;
  //   } catch (e) {
  //     log("❌ Error fetching monthly data: $e");
  //     return [];
  //   }
  // }

  void disposeWebSocket() {
    _repository.closeWebSocket();
  }
}
