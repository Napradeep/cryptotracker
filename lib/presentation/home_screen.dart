import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'crypto_provider.dart';
import 'price_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CryptoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crypto Tracker"),
        backgroundColor: Colors.black87,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => CryptoChartScreen()),
              // );
            },
            icon: Icon(Icons.calendar_month, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  value: provider.selectedCrypto,
                  items:
                      ["BTCUSDT", "ETHUSDT", "BNBUSDT"].map((String symbol) {
                        return DropdownMenuItem<String>(
                          value: symbol,
                          child: Text(
                            symbol,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      provider.setCrypto(value);
                    }
                  },
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            provider.cryptoPrice != null
                ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "💰 Current Price",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
                : SizedBox(),

            Card(
              elevation: 4,
              color: Colors.blueGrey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child:
                      provider.cryptoPrice != null
                          ? Column(
                            children: [
                              Text(
                                "\$ ${provider.cryptoPrice!.price.toStringAsFixed(2)} USD",

                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                          : const CircularProgressIndicator(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Price Chart Header
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "📈 Price Chart",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Crypto Price Chart
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(8),
                child: const PriceChart(timeInterval: "1d", symbol: "BTCUSDT"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
