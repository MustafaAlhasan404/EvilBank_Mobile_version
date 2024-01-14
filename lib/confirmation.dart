// ignore_for_file: prefer_const_constructors, unused_element, unused_import

import 'dart:ffi';

import 'package:evilbank_mobile/amount.dart';
import 'package:evilbank_mobile/failure.dart';
import 'package:evilbank_mobile/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:evilbank_mobile/success.dart';

class ConfirmationScreen extends StatelessWidget {
  final String recipientName;
  final String recipientCardNumber;
  final String amount;
  final String recipientUsername;

  const ConfirmationScreen({
    Key? key,
    required this.recipientName,
    required this.recipientCardNumber,
    required this.amount,
    required this.recipientUsername,
  }) : super(key: key);

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
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Confirmation',
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
                ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipient Info
                _buildDataField("Recipient Name", recipientName),
                const SizedBox(height: 18),
                _buildDataField("Recipient Card Number", recipientCardNumber),
                const SizedBox(height: 18),
                _buildDataField("Transfer Amount", amount),
                const SizedBox(height: 50),
                SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      var url = Uri.parse('http://10.0.2.2:3000/transfer');
                      var headers = {'Content-Type': 'application/json'};
                      var body = jsonEncode({
                        'senderUsername': loggedInUser,
                        'receiverUsername': recipientUsername,
                        'amount': int.parse(amount),
                      });

                      var response =
                          await http.post(url, headers: headers, body: body);

                      if (response.statusCode == 200) {
                        // Transfer successful
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SuccessScreen()),
                        );
                      } else {
                        // Transfer failed
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FailureScreen()),
                        );
                        // Handle the failure based on the status code or response body
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    child: const Text(
                      'Transfer',
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
