// profile.dart
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'bottom_navigation_bar.dart'; // Import the bottom navigation bar file

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  late String loggedInUser = '';
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _loadLoggedInUser();
  }

  Future<void> _loadLoggedInUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? user = prefs.getString('loggedInUser');
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });

      // Fetch user data from the server based on the logged-in user
      await fetchUserData(loggedInUser);
    }
  }

  Future<void> fetchUserData(String username) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/users/$username'));

    if (response.statusCode == 200) {
      // Parse and store the user data
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        userData = data;
      });
    } else {
      // Handle error
      print('Failed to fetch user data. Status code: ${response.statusCode}');
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
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    _buildHeaderText(loggedInUser),
                    if (userData.isNotEmpty) ...[
                      SizedBox(height: 5),
                      _buildText(
                        'Username: $loggedInUser',
                        fontSize: 16,
                      ),
                      SizedBox(height: 5),
                      _buildText('First Name: ${userData['firstName']}',
                          fontSize: 16),
                      SizedBox(height: 5),
                      _buildText('Last Name: ${userData['lastName']}',
                          fontSize: 16),
                      SizedBox(height: 5),
                      _buildText('Address: ${userData['address']}',
                          fontSize: 16),
                      SizedBox(height: 5),
                      _buildText('Birthdate: ${userData['birthday']}',
                          fontSize: 16),
                      // Add more fields as needed
                    ],
                  ],
                ),
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
        ));
  }

  Widget _buildHeaderText(String username) {
    return SizedBox(
      height: 60,
      child: Text(
        username,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF9067C6),
        ),
      ),
    );
  }

  Widget _buildText(String text, {double? fontSize, FontWeight? fontWeight}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: const Color(0xFFF7ECE1),
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
      home: ProfilePage(),
    );
  }
}
