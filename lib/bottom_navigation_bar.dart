// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:evilbank_mobile/home.dart';
import 'package:evilbank_mobile/transactions.dart';

import 'transfer_operation_screen.dart';
// import 'stocks.dart';
import 'profile.dart'; // Import your ProfilePage
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late String loggedInUser; // Change this to late

  @override
  void initState() {
    super.initState();
    _fetchLoggedInUser();
  }

  Future<void> _fetchLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUser = prefs.getString('loggedInUser') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: const Color(0xFF9067C6),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
          child: GNav(
            rippleColor: Color(0xFF151538),
            hoverColor: Color(0xFF151538),
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Color(0xFF9067C6),
            color: Colors.black,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        username: loggedInUser,
                      ),
                    ),
                  );
                },
              ),
              GButton(
                icon: Icons.arrow_circle_right,
                text: 'Transfer',
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransferOperationScreen(),
                    ),
                  );
                },
              ),
              GButton(
                icon: Icons.history,
                text: 'Transactions',
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionsScreen(),
                    ),
                  );
                },
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
              ),
            ],
            selectedIndex: widget.selectedIndex,
            onTabChange: widget.onTabChange,
          ),
        ),
      ),
    );
  }
}
