// profile.dart
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'bottom_navigation_bar.dart'; // Import the bottom navigation bar file

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  late String loggedInUser = '';
  Map<String, dynamic> userData = {};
  Set<String> selectedUserData =
      {}; // Use a Set to keep track of selected buttons

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
        textTheme: GoogleFonts.soraTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF171738),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildHeaderText(loggedInUser),
                  SizedBox(height: 24),
                  Padding(padding: EdgeInsets.all(35)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18),
                  Text(
                    'My Personal Info',
                    style: TextStyle(
                      color: Color(0xFF9067C6),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18),
                  _buildDataButton('First Name', userData['firstName']),
                  SizedBox(height: 18),
                  _buildDataButton('Last Name', userData['lastName']),
                  SizedBox(height: 18),
                  _buildDataButton('BirthDate', userData['birthday']),
                  SizedBox(height: 18),
                  _buildDataButton('Address', userData['address']),
                  SizedBox(height: 18),
                  Text(
                    'My Bank Info',
                    style: TextStyle(
                      color: Color(0xFF9067C6),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18),
                  _buildDataButton('Card Number', userData['creditCardNumber']),
                  SizedBox(height: 18),
                  _buildDataButton('Expire Date', userData['expiryDate']),
                  SizedBox(height: 18),
                  _buildDataButton('Cvv', userData['cvv']),
                ],
              ),
            ],
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

  Widget _buildHeaderText(String username) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$username ',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF9067C6),
            ),
          ),
          TextSpan(
            text: 'Profile !',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataButton(String label, String? data) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: selectedUserData.contains(label)
          ? GestureDetector(
              onTap: () {
                setState(() {
                  selectedUserData.remove(label);
                });
              },
              child: Container(
                key: ValueKey<String>('revealed_data_$label'),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF9067C6), // Change background color
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$label: $data',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedUserData.add(label);
                });
              },
              child: Text('My $label'),
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
        textTheme: GoogleFonts.soraTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: ProfilePage(),
    );
  }
}
