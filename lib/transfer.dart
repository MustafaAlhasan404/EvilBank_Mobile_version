import 'package:evilbank_mobile/amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:evilbank_mobile/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_navigation_bar.dart';

class TransferOperationScreen extends StatefulWidget {
  const TransferOperationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransferOperationScreenState createState() =>
      _TransferOperationScreenState();
}

class _TransferOperationScreenState extends State<TransferOperationScreen> {
  int _selectedIndex = 1;
  final TextEditingController _cardNumberController = TextEditingController();
  String recipientAddress = '';
  String recipientName = '';
  String recipientCardNumber = '';
  String recipientUsername = '';
  String errorMessage = '';
  late String loggedInUser = '';

  Future<void> _getRecipientDetails() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:3000/cardholders/${_cardNumberController.text}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        recipientName = data['name'];
        recipientAddress = data['address'];
        recipientCardNumber = data['creditCardNumber'];
        recipientUsername = data['username'];
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
            child: FocusScope(
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
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                              'Recipient Card Number', _cardNumberController),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _getRecipientDetails();
                          },
                          color: Colors.white,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(20.0)),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 128.0,
                      ),
                      // Icon goes here
                      const Icon(
                        Icons.person_off_rounded,
                        color: Colors.white,
                        size: 150.0,
                      ),
                      Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (recipientName.isNotEmpty)
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
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AmountScreen(
                              recipientName: recipientName,
                              recipientCardNumber: recipientCardNumber,
                              recipientUsername: recipientUsername,
                            ),
                          ),
                        );
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
                      child: const Text(
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
          style: const TextStyle(
            color: Color(0xFF9067C6),
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          data,
          style: const TextStyle(
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
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
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
