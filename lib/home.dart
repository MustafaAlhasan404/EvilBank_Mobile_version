// ignore_for_file: unused_field, library_private_types_in_public_api, avoid_print, prefer_const_constructors, use_key_in_widget_constructors

import 'package:google_fonts/google_fonts.dart';

import 'url.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'bottom_navigation_bar.dart';
import 'Widgets/transaction_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String? username;

  const HomeScreen({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userBalance = '';
  int _selectedIndex = 0;
  String cardNumber = '';
  String cardHolderName = loggedInUser!;
  String expiryDate = '';
  String cvv = '';
  List<Transaction> transactions = [];

  late FocusNode _cvvFocusNode;
  bool _showBackSide = false;

  @override
  void initState() {
    super.initState();
    _cvvFocusNode = FocusNode();

    fetchCreditCardInfo();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final String finalUrl = '${url}/transactions/latest/${loggedInUser}';

    try {
      final response = await http.get(Uri.parse(finalUrl));

      if (response.statusCode == 200) {
        final List<dynamic> transactionData = jsonDecode(response.body);

        setState(() {
          transactions = transactionData
              .map((data) => Transaction.fromJson(data))
              .toList();
        });
      } else {
        print(
            'Failed to fetch transactions. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching transactions: $error');
    }
  }

  Future<void> fetchCreditCardInfo() async {
    final String finalUrl = '${url}/getCreditCardInfo/${widget.username}';

    try {
      final response = await http.get(Uri.parse(finalUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> creditCardInfo = jsonDecode(response.body);
        setState(() {
          cardNumber = creditCardInfo['cardNumber'];
          cvv = creditCardInfo['cvv'];
          expiryDate = creditCardInfo['expiryDate'];
          cardHolderName = creditCardInfo['name'];
          userBalance = creditCardInfo['balance'];
        });
      } else {
        print(
            'Failed to fetch credit card information. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching credit card information: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'GoogleSans',
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF171738),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showBackSide = !_showBackSide;
                    });
                  },
                  child: CreditCard(
                    cardNumber: cardNumber,
                    cardExpiry: expiryDate,
                    cardHolderName: cardHolderName,
                    cvv: cvv,
                    bankName: 'Evil Bank',
                    showBackSide: _showBackSide,
                    frontBackground: CardBackgrounds.black,
                    backBackground: Container(
                      color: const Color(0xFF8D86C9),
                    ),
                    showShadow: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 0,
                    color: Color.fromARGB(0, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Balance:',
                            style: GoogleFonts.sora(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'GoogleSans',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            userBalance,
                            style: GoogleFonts.aboreto(
                              textStyle: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'GoogleSans',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  // Add a solid line separator
                  thickness: 1.0,
                  color: Colors.white,
                  indent: 128.0,
                  endIndent: 128.0,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Latest Transactions',
                      style: GoogleFonts.sora(
                        textStyle: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  padding: const EdgeInsets.only(top: 8.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];

                    return CustomCard(
                      title: transaction.title,
                      name: transaction.name,
                      amount: transaction.amount,
                      date: transaction.date,
                    );
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
              // More code here
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class Transaction {
  final String title;
  final String name;
  final String date;
  final String amount;

  Transaction({
    required this.title,
    required this.name,
    required this.date,
    required this.amount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['title'],
      name: json['name'],
      date: json['date'],
      amount: json['amount'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(
        username: loggedInUser,
      ),
    );
  }
}
