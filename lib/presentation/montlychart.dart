// import 'package:crypto_tracker/domain/crypto_model.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import 'crypto_provider.dart';

// class CryptoChartScreen extends StatefulWidget {
//   const CryptoChartScreen({super.key});

//   @override
//   State<CryptoChartScreen> createState() => _CryptoChartScreenState();
// }

// class _CryptoChartScreenState extends State<CryptoChartScreen> {
//   DateTime selectedDate = DateTime.now();

//   void _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2020, 1),
//       lastDate: DateTime.now(),
//       helpText: "Select a Month",
//       fieldLabelText: "Month & Year",
//       selectableDayPredicate: (day) {
//         return day.day == 1;
//       },
//     );

//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CryptoProvider>(context);
//     final historicalData = provider.fetchMonthlyData(selectedDate);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Crypto Analysis"),
//         backgroundColor: Colors.black87,
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: const EdgeInsets.all(14.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[900],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       dropdownColor: Colors.grey[900],
//                       value: provider.selectedCrypto,
//                       items:
//                           ["BTCUSDT", "ETHUSDT", "BNBUSDT"].map((
//                             String symbol,
//                           ) {
//                             return DropdownMenuItem<String>(
//                               value: symbol,
//                               child: Text(
//                                 symbol,
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             );
//                           }).toList(),
//                       onChanged: (value) {
//                         if (value != null) {
//                           provider.setCrypto(value);
//                         }
//                       },
//                       icon: const Icon(
//                         Icons.arrow_drop_down,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 TextButton.icon(
//                   onPressed: () => _selectDate(context),
//                   icon: const Icon(Icons.calendar_today, color: Colors.white),
//                   label: Text(
//                     DateFormat.yMMMM().format(selectedDate),
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[900],
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 padding: const EdgeInsets.all(16),
//                 child: FutureBuilder<List<CryptoPrice>>(
//                   future: provider.fetchMonthlyData(selectedDate),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (snapshot.hasError) {
//                       return Center(child: Text("Error: ${snapshot.error}"));
//                     }
//                     if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const Center(child: Text("No data available"));
//                     }

//                     final historicalData = snapshot.data!;

//                     return PieChart(
//                       PieChartData(
//                         sections:
//                             historicalData.map((data) {
//                               return PieChartSectionData(
//                                 value: data.price,
//                                 title: "\$${data.price.toStringAsFixed(2)}",
//                                 color:
//                                     Colors.primaries[historicalData.indexOf(
//                                           data,
//                                         ) %
//                                         Colors.primaries.length],
//                                 radius: 50,
//                                 titleStyle: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                 ),
//                               );
//                             }).toList(),
//                         borderData: FlBorderData(show: false),
//                         sectionsSpace: 2,
//                         centerSpaceRadius: 40,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
