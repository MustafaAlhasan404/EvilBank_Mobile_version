// profile.dart
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print
import 'package:evilbank_mobile/login.dart';
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

  @override
  void initState() {
    super.initState();
    userData['name'] = '';
    userData['hiddenPassword'] = '';
    userData['birthday'] = '';
    userData['address'] = '';
    userData['username'] = '';
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
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        userData = data;
        userData["name"] = userData['firstName'] + " " + userData['lastName'];
        String stars = "*";

        String starsString =
            userData['password'].replaceAll(RegExp(r"."), stars).toString();
        userData["hiddenPassword"] = starsString;
      });
    } else {
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
                children: const [
                  Text(
                    'Your Profile',
                    style: TextStyle(
                      color: Color(0xFF9067C6),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(padding: EdgeInsets.all(35)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 36),
                  _buildDataField("Name", userData['name']),
                  SizedBox(height: 18),
                  _buildDataField('BirthDate', userData['birthday']),
                  SizedBox(height: 18),
                  _buildDataField('Address', userData['address']),
                  SizedBox(height: 52),
                  Text(
                    'Login Credentials',
                    style: TextStyle(
                      color: Color(0xFF9067C6),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18),
                  _buildDataField('Username', userData['username']),
                  SizedBox(height: 18),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Color(0xFF9067C6),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['hiddenPassword'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.visibility,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32.0,
                      ),
                      SizedBox(
                        height: 50.0,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            _logout();
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                side: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // _buildPasswordField('Password', userData['hiddenPassword']),
                  SizedBox(height: 18),
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

  Widget _buildDataField(String label, String data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF9067C6),
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          data,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser');

    // Navigate to the login page
    // ignore: use_build_context_synchronously
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
