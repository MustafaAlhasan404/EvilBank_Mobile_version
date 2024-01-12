import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'bottom_navigation_bar.dart';
import 'Widgets/transaction_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _selectedIndex = 2;
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final String url = 'http://10.0.2.2:3000/transactions/${loggedInUser}';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? user = prefs.getString('loggedInUser');
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });

      try {
        final response = await http.get(Uri.parse(url));

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
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'All Transactions',
                      style: GoogleFonts.sora(
                        textStyle: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
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
