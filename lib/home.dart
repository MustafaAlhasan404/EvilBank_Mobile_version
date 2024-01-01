// ignore_for_file: unused_field, library_private_types_in_public_api, avoid_print, prefer_const_constructors, use_key_in_widget_constructors

import 'login.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'bottom_navigation_bar.dart';
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
  double userBalance = 0.0;
  int _selectedIndex = 0;
  String cardNumber = '';
  String cardHolderName = loggedInUser!;
  String expiryDate = '';
  String cvv = '';

  late FocusNode _cvvFocusNode;
  bool _showBackSide = false;

  @override
  void initState() {
    super.initState();
    _cvvFocusNode = FocusNode();

    fetchCreditCardInfo();
    fetchUserBalance();
  }

  Future<void> fetchUserBalance() async {
    final String url = 'http://10.0.2.2:3000/getUserBalance/${widget.username}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        print('Fetched user balance: $userData');
        setState(() {
          userBalance = (userData['balance'] as num).toDouble();
        });
        print('Updated user balance in state: $userBalance');
      } else {
        print(
            'Failed to fetch user balance. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user balance: $error');
    }
  }

  Future<void> fetchCreditCardInfo() async {
    final String url =
        'http://10.0.2.2:3000/getCreditCardInfo/${widget.username}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> creditCardInfo = jsonDecode(response.body);
        setState(() {
          cardNumber = creditCardInfo['cardNumber'];
          cvv = creditCardInfo['cvv'];
          expiryDate = creditCardInfo['expiryDate'];
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Color(0xFF171738),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Balance: ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GoogleSans',
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '$userBalance',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
