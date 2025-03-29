import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/constants.dart';
import '../domain/crypto_model.dart';

class CryptoRepository {
  WebSocketChannel? _channel;

  /// Connects to Binance WebSocket for real-time crypto prices.
  Stream<CryptoPrice> connectToWebSocket(String symbol) {
    // ✅ Close the previous connection before opening a new one
    closeWebSocket();

    final url =
        '${ApiConstants.binanceWebSocketUrl}${symbol.toLowerCase()}@trade';
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      print("✅ WebSocket connected: $symbol");

      return _channel!.stream
          .map((event) {
            final data = jsonDecode(event);
            return CryptoPrice.fromJson(data);
          })
          .handleError((error) {
            print("❌ WebSocket Error: $error");
          });
    } catch (e) {
      print("❌ WebSocket Connection Failed: $e");
      return const Stream.empty();
    }
  }

  /// Fetches historical data for the given crypto symbol.
  Future<List<CryptoPrice>> fetchHistoricalData(
    String symbol,
    String interval,
  ) async {
    final url = Uri.parse(
      "${ApiConstants.binanceHistoricalUrl}?symbol=$symbol&interval=$interval&limit=100",
    );

    print("📊 Fetching data from: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("✅ Fetched Data: ${data.length} entries");

        return data.map((e) {
          return CryptoPrice(
            symbol: symbol,
            price: double.tryParse(e[4].toString()) ?? 0.0,
          );
        }).toList();
      } else {
        throw Exception(
          "❌ Failed to load historical data (Status: ${response.statusCode})",
        );
      }
    } catch (e) {
      print("❌ Error fetching historical data: $e");
      return [];
    }
  }

  // Future<List<CryptoPrice>> fetchMonthlyData(
  //   String symbol,
  //   String interval, {
  //   int limit = 30, 
  // }) async {
  //   // Construct base URL
  //   String url =
  //       "https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1d&limit=30";

  //   print("📊 Fetching data from: $url");

  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       print("✅ Fetched Data: ${data.length} entries");

  //       return data.map((e) {
  //         return CryptoPrice(
  //           symbol: symbol,
  //           price: double.tryParse(e[4].toString()) ?? 0.0,
  //         );
  //       }).toList();
  //     } else {
  //       throw Exception(
  //         "❌ Failed to load historical data (Status: ${response.statusCode})",
  //       );
  //     }
  //   } catch (e) {
  //     print("❌ Error fetching historical data: $e");
  //     return [];
  //   }
  // }

  /// Closes the WebSocket connection.
  void closeWebSocket() {
    if (_channel != null) {
      print("🛑 Closing WebSocket connection...");

      try {
        _channel!.sink.close(
          ws_status.normalClosure,
        ); 
      } catch (e) {
        print("❌ Error closing WebSocket: $e");
      }

      _channel = null;
    }
  }
}
