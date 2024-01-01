// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_declarations, use_build_context_synchronously, sort_child_properties_last, avoid_print, depend_on_referenced_packages, deprecated_member_use
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String? loggedInUser;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _savePassword = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleSavePassword(bool? value) {
    setState(() {
      _savePassword = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171738),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                _buildHeaderText('Login'),
                const SizedBox(height: 24),
                _buildInputField('Username', _usernameController),
                const SizedBox(height: 24),
                _buildPasswordInput(),
                const SizedBox(height: 24),
                _buildRememberMeCheckbox(),
                const SizedBox(height: 24),
                _buildLoginButton(context),
                const SizedBox(height: 24),
                _buildSignupButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: GoogleFonts.sora(
        textStyle: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9067C6),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return _buildContainer(
      child: TextFormField(
        controller: controller,
        style: _inputTextStyle(),
        decoration: _inputDecoration(label, backgroundColor: Color(0xFFF7ECE1)),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return _buildContainer(
      child: TextFormField(
        obscureText: _obscurePassword,
        controller: _passwordController,
        style: _inputTextStyle(),
        decoration: _inputDecoration('Password',
            backgroundColor: Color(0xFFF7ECE1),
            suffixIcon: _buildPasswordSuffixIcon()),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: _savePassword,
          onChanged: _toggleSavePassword,
          fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Color(0xFFF7ECE1);
              }
              return Color(0xFFF7ECE1);
            },
          ),
          checkColor: Color(0xFF35368E),
          activeColor: Color(0xFFF7ECE1),
        ),
        _buildCheckboxText('Remember me'),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _performLogin(context);
        },
        child: Text(
          'Login',
          style: _buttonTextStyle(),
        ),
        style: _buttonStyle(),
      ),
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignupPage()),
          );
        },
        child: RichText(
          text: TextSpan(
            text: 'Don\'t have an account? ',
            style: GoogleFonts.sora(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            children: [
              TextSpan(
                text: 'Sign up',
                style: GoogleFonts.sora(
                  textStyle: TextStyle(
                    color: Color(0xFF8D86C9),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7ECE1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: child,
    );
  }

  Widget _buildPasswordSuffixIcon() {
    return IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility : Icons.visibility_off,
        color: Color(0xFF9067C6),
      ),
      onPressed: _togglePasswordVisibility,
    );
  }

  TextStyle _inputTextStyle() {
    return GoogleFonts.sora(
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText,
      {Widget? suffixIcon, Color? backgroundColor}) {
    final borderColor = backgroundColor ?? Color(0xFFF7ECE1);

    return InputDecoration(
      labelText: labelText,
      labelStyle: GoogleFonts.sora(
        textStyle: TextStyle(
          color: Color(0xFF8D86C9),
          fontSize: 18,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      suffixIcon: suffixIcon,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: backgroundColor,
      filled: true,
    );
  }

  Widget _buildCheckboxText(String text) {
    return Text(
      text,
      style: GoogleFonts.sora(
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  TextStyle _buttonTextStyle() {
    return GoogleFonts.sora(
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      primary: Color(0xFF9067C6),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      minimumSize: Size(double.infinity, 48),
    );
  }

  Future<void> _performLogin(BuildContext context) async {
    print('Attempting login...');
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Assuming you have an API endpoint for login
    final String loginEndpoint = 'http://10.0.2.2:3000/login';

    try {
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {
          'Content-Type':
              'application/json', // Add this line to specify JSON content type
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Successful login, save username

// Save loggedInUser to SharedPreferences
        loggedInUser = username;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('loggedInUser', loggedInUser!);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              username: loggedInUser,
            ),
          ),
        );
      } else if (response.statusCode == 400) {
        // Username not found
        _showErrorDialog('Username not found');
      } else if (response.statusCode == 401) {
        // Incorrect password
        _showErrorDialog('Incorrect password');
      } else {
        // Handle other errors
        _showErrorDialog('Login failed. Please try again.');
      }
    } catch (error) {
      print('Error during login: $error');
      // Handle network or server errors
      _showErrorDialog('Error connecting to the server. Please try again.');
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
