import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'crypto_provider.dart';

class PriceChart extends StatefulWidget {
  final String symbol;
  final String timeInterval;

  const PriceChart({
    super.key,
    required this.symbol,
    required this.timeInterval,
  });

  @override
  _PriceChartState createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  double? lastPrice;
  Color priceChangeColor = Colors.white;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<CryptoProvider>(context, listen: false);
      provider.fetchHistoricalData(widget.timeInterval);
      provider.setCrypto(widget.symbol);
    });
  }

  void updatePriceBlink(double newPrice) {
    if (lastPrice == null) {
      lastPrice = newPrice;
      return;
    }

    if (newPrice > lastPrice!) {
      priceChangeColor = Colors.green;
    } else if (newPrice < lastPrice!) {
      priceChangeColor = Colors.red;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          lastPrice = newPrice;
        });

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              priceChangeColor = Colors.white;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CryptoProvider>(
      builder: (context, provider, child) {
        if (provider.historicalData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Update blinking effect safely
        double latestPrice = provider.historicalData.last.price;
        updatePriceBlink(latestPrice);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: provider.historicalData.length * 8,
            height: 300,
            padding: const EdgeInsets.all(5),

            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        String formattedValue;

                        if (value >= 1000) {
                          formattedValue =
                              '\$${(value / 1000).toStringAsFixed(0)}K';
                        } else {
                          formattedValue = '\$${value.toStringAsFixed(1)}';
                        }

                        return Text(
                          formattedValue,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  border: Border.all(color: Colors.grey),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots:
                        provider.historicalData
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value.price))
                            .toList(),
                    isCurved: true,
                    color: priceChangeColor,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => Colors.black,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '💰 ${spot.y.toStringAsFixed(2)} USD',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
                minX: 0,
                maxX: provider.historicalData.length.toDouble(),
                clipData: FlClipData.all(),
              ),
            ),
          ),
        );
      },
    );
  }
}
