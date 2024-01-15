# Evil Bank Mobile App

This is a mobile banking app built with Flutter that allows users to manage their bank account, transfer funds and more.

# Note you only need to run 'flutter build apk --release' and install the apk on your phone . 

# Overview
The app has the following features:

User account registration and login
View account balance
Transfer money to another registered user
View transaction history
Update user profile details
It uses a bottom navigation bar to switch between Home, Transfer and Profile pages after login.

# Code Structure

# main.dart

The app entry point that runs the main MaterialApp.
Sets up theme and home route to LoginPage widget.
# login.dart

Contains UI and logic for login page.
Has text fields for user to enter username and password.
Calls login API on button click, saves auth token and username to local storage on success.
Navigates to Home page after login.
Displays error snackbar on invalid credentials.
# signup.dart

UI and logic for registration page.
Text fields for first name, last name, date of birth, address and other account details.
Calls signup API on button click and navigates to Login page after successful account creation.
# home.dart

Home page displayed after successful login.
Fetches user details from API and displays account balance.
Has options to transfer money or view profile which navigate to respective pages.
# amount.dart

Entry page for user to enter transfer amount.
Input field with currency formatting and validation.
Transfers control to transfer page on next click.
# transfer.dart

Collects recipient details such as name, account number etc.
Fetches recipient name from API based on account number entered.
Navigates to confirmation page with all details on next click.
# confirmation.dart

Displays all transfer details for user confirmation.
Calls transfer API on confirm button click.
Navigates to success or failure page based on API response.
success.dart

Shown on successful money transfer.
Has option to navigate back to Home page.
# failure.dart

Shown when transfer API call fails.
Option to return to Home page.
# profile.dart

Displays user profile details fetched from API.
Shows transaction history listing.
Option to logout which clears local storage and returns to Login page.