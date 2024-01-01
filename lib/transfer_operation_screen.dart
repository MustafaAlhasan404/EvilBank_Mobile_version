// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, depend_on_referenced_packages, prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';
import 'home.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransferOperationScreen extends StatefulWidget {
  @override
  _TransferOperationScreenState createState() =>
      _TransferOperationScreenState();
}

class _TransferOperationScreenState extends State<TransferOperationScreen> {
  int _selectedIndex = 1; // Index for the "Transfer" tab

  // Controller for the recipient credit card number input
  final recipientCardNumberController = TextEditingController();

  // Controller for the amount to be transferred input
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171738),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show the transfer form when the button is clicked
            showTransferForm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF7ECE1), // Button color
            textStyle: TextStyle(
              fontFamily: 'Google-Sora', // Font style
              fontWeight: FontWeight.bold, // Make the font a little bolder
              color: Color(0xFF8D86C9), // Text color
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Set the border radius
            ),
          ),
          child: Text('Transfer'),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
            if (_selectedIndex == 0) {
              // If "Home" is pressed, go back to HomeScreen using builder context
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    username: loggedInUser,
                  ),
                ),
              );
            }
          });
        },
      ),
    );
  }

  // Function to show the transfer form as a dropdown
  void showTransferForm() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Color(0xFFF7ECE1), // Set the background color of the AlertDialog
          title: Text(
            'Transfer Form',
            style: TextStyle(
              fontFamily: 'Google-Sora', // Font style
              fontWeight: FontWeight.bold, // Make the font a little bolder
              color: Color(0xFF8D86C9), // Text color
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Set the width of the dialog content
            height: MediaQuery.of(context).size.height *
                0.4, // Set the height of the dialog content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  controller: recipientCardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Recipient Credit Card Number',
                    labelStyle: TextStyle(
                      fontFamily: 'Google-Sora', // Font style
                      fontWeight:
                          FontWeight.bold, // Make the font a little bolder
                      color: Color(0xFF8D86C9), // Text color
                    ),
                  ),
                ),
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount to be Transferred',
                    labelStyle: TextStyle(
                      fontFamily: 'Google-Sora', // Font style
                      fontWeight:
                          FontWeight.bold, // Make the font a little bolder
                      color: Color(0xFF8D86C9), // Text color
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Call the server to handle the money transfer
                await transferMoney();
                // Close the dialog
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF7ECE1), // Button color
                textStyle: TextStyle(
                  fontFamily: 'Google-Sora', // Font style
                  fontWeight: FontWeight.bold, // Make the font a little bolder
                  color: Color(0xFF8D86C9), // Text color
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Set the border radius
                ),
              ),
              child: Text('Transfer'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog without performing the transfer
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Google-Sora', // Font style
                  fontWeight: FontWeight.bold, // Make the font a little bolder
                  color: Color(0xFF8D86C9), // Text color
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to handle the money transfer
  Future<void> transferMoney() async {
    try {
      // Extract values from controllers
      String recipientCardNumber = recipientCardNumberController.text;
      String amount = amountController.text;

      // Send a transfer request to the server
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:3000/transferMoney'), // Update with your server URL
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'senderUsername': loggedInUser,
          'recipientCardNumber':
              recipientCardNumber, // Update key to match server expectations
          'amount': amount,
        }),
      );

      // Handle the response from the server
      if (response.statusCode == 200) {
        // Transfer successful
        print('Money transfer successful');
      } else {
        // Transfer failed, handle the error
        print('Money transfer failed: ${response.body}');
        // Add a Flutter toast or dialog to inform the user about the failure
      }
    } catch (error) {
      // Handle exceptions or errors during the transfer process
      print('Error during money transfer: $error');
      // Add a Flutter toast or dialog to inform the user about the error
    }
  }
}
