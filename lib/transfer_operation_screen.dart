import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:evilbank_mobile/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_navigation_bar.dart';

class TransferOperationScreen extends StatefulWidget {
  @override
  _TransferOperationScreenState createState() =>
      _TransferOperationScreenState();
}

class _TransferOperationScreenState extends State<TransferOperationScreen> {
  int _selectedIndex = 1; // Index for the "Transfer" tab
  TextEditingController _cardNumberController = TextEditingController();
  String recipientName = '';
  String recipientAddress = '';
  String recipientCardNumber = '';
  String errorMessage = '';
  late String loggedInUser = '';

  Future<void> _getRecipientDetails() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:3000/cardholders/${_cardNumberController.text}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        recipientName = data['name'];
        recipientAddress = data['creditCardNumber'];
        recipientAddress = data['address'];
        errorMessage = '';
      });
    } else if (response.statusCode == 404) {
      final data = jsonDecode(response.body);
      setState(() {
        errorMessage = data["msg"];
      });
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171738),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 92, 16, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Transfer',
                    style: GoogleFonts.sora(
                      textStyle: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                            'Recipient Card Number', _cardNumberController),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _getRecipientDetails,
                        color: Colors.white,
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          if (!errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
              // padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipient Info
                  _buildDataField("Name", recipientName),
                  const SizedBox(height: 18),
                  _buildDataField("Address", recipientAddress),
                  const SizedBox(height: 18),
                  _buildDataField("Card Number", recipientCardNumber),
                  SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        // _logout();
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
            if (_selectedIndex == 0) {
              Navigator.pushReplacement(
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

  Widget _buildInputField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7ECE1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.sora(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.sora(
            textStyle: const TextStyle(
              color: Color(0xFF8D86C9),
              fontSize: 18,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFF7ECE1),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFF7ECE1),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          // suffixIcon: suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Color(0xFFF7ECE1),
          filled: true,
        ),
      ),
    );
  }
}
