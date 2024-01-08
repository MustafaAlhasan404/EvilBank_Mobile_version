// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'bottom_navigation_bar.dart'; // Import your CustomBottomNavBar
// // import 'package:stock_market_data/stock_market_data.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       home: StockScreen(),
//     );
//   }
// }

// class StockScreen extends StatefulWidget {
//   const StockScreen({Key? key}) : super(key: key);

//   @override
//   State<StockScreen> createState() => _StockScreenState();
// }

// class _StockScreenState extends State<StockScreen> {
//   int _selectedIndex = 2; // Set the index for the "Stocks" tab

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.all(20.0),
//         color: const Color(0xFF171738),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               height:
//                   MediaQuery.of(context).size.height * 0.6, // Adjusted height
//               width: double.infinity,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: BuyAndHoldResult(
//                   exampleTicker: 'AAPL',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavBar(
//         selectedIndex: _selectedIndex,
//         onTabChange: (index) {
//           // Handle tab changes here if needed
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//       ),
//       extendBody:
//           true, // Set extendBody to true to avoid white space behind the bottom navbar
//     );
//   }
// }

// class BuyAndHoldResult extends StatefulWidget {
//   final String exampleTicker;

//   const BuyAndHoldResult({
//     required this.exampleTicker,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<BuyAndHoldResult> createState() => _BuyAndHoldResultState();
// }

// class _BuyAndHoldResultState extends State<BuyAndHoldResult> {
//   final List<String> indicatorOptions = [
//     'AAPL',
//     'SMA',
//     'EMA',
//     'RSI',
//     'BB',
//     'BOP',
//     'MFI',
//     'P',
//     'STDDEV',
//     'VWMA',
//     '%R',
//   ];

//   String selectedOption = 'AAPL'; // Default selected option
//   BuyAndHoldStrategyResult backTest = BuyAndHoldStrategyResult();
//   bool loading = true;
//   String error = '';

//   @override
//   void initState() {
//     super.initState();
//     load();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text(
//           '',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         DropdownButton<String>(
//           value: selectedOption,
//           icon: const Icon(Icons.list, color: Colors.white),
//           iconSize: 24,
//           elevation: 16,
//           style: _inputTextStyle(),
//           underline: Container(), // Remove underlining
//           dropdownColor:
//               const Color(0xFF171738), // Set dropdown background color
//           itemHeight: 60, // Set a fixed height for the dropdown items
//           onChanged: (String? newValue) {
//             if (newValue != null) {
//               setState(() {
//                 selectedOption = newValue;
//               });
//             }
//           },
//           items: indicatorOptions.map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     vertical: 10.0, horizontal: 15.0),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF171738),
//                   borderRadius: BorderRadius.circular(10.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black
//                           .withOpacity(0.2), // Set shadow color and opacity
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   value,
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//         MaterialButton(
//           onPressed: load,
//           color: const Color(0xFF9067C6),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           minWidth: MediaQuery.of(context).size.width * 0.5,
//           child: const Text(
//             'Load',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//             ),
//           ),
//         ),
//         error != ''
//             ? Text(
//                 'Error: $error',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontSize: 18,
//                 ),
//               )
//             : loading
//                 ? const Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : Column(
//                     children: [
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       _BackTestResult(backTest),
//                     ],
//                   ),
//       ],
//     );
//   }

//   void load() async {
//     try {
//       error = '';
//       loading = true;
//       setState(() {});

//       backTest = await StockMarketDataService()
//           .getBackTestResultForSymbol(selectedOption);
//       loading = false;
//       setState(() {});
//     } catch (e) {
//       error = 'Error getting the symbol $selectedOption:\n $e';
//       setState(() {});
//     }
//   }

//   TextStyle _inputTextStyle() {
//     return GoogleFonts.sora(
//       textStyle: const TextStyle(
//         color: Colors.black,
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String labelText) {
//     return InputDecoration(
//       labelText: labelText,
//       labelStyle: const TextStyle(
//         color: Color(0xFF8D86C9),
//         fontSize: 18,
//       ),
//       focusedBorder: const OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Color(0xFFF7ECE1),
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//       ),
//       enabledBorder: const OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Color(0xFFF7ECE1),
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//       ),
//       floatingLabelBehavior: FloatingLabelBehavior.never,
//       fillColor: const Color(0xFFF7ECE1),
//       filled: true,
//     );
//   }
// }

// class _BackTestResult extends StatelessWidget {
//   final BuyAndHoldStrategyResult backTest;

//   const _BackTestResult(this.backTest);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             const Expanded(
//               child: Text(
//                 'CAGR',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 backTest.cagr.toStringAsFixed(2),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Expanded(
//               child: Text(
//                 'Max Drawdown',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 backTest.maxDrawdown.toStringAsFixed(2),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Expanded(
//               child: Text(
//                 'MAR',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 backTest.mar.toStringAsFixed(2),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Expanded(
//               child: Text(
//                 'Trading years',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 backTest.tradingYears.toStringAsFixed(2),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Expanded(
//               child: Text(
//                 'Start date',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 backTest.startDate.toString(),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Expanded(
//               child: Text(
//                 'End date',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 backTest.endDate.toString(),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Expanded(
//               child: Text(
//                 'Current drawdown',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 backTest.currentDrawdown.toStringAsFixed(2),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Expanded(
//               child: Text(
//                 'End price',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 backTest.endPrice.toStringAsFixed(2),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
