import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildInputField(String label, TextEditingController controller) {
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
