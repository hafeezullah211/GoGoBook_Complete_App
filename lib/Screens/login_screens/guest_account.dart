import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gogobook/Screens/home_screens/nav_screen.dart';

// Function to generate a random string
String generateRandomString(int length) {
  final chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    length, (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}

// Function to create a guest user account
Future<void> createGuestAccount(BuildContext context) async {
  try {
    // Generate random email and password for the guest user
    final email = generateRandomString(10) + '@example.com';
    final password = generateRandomString(10);

    // Create the guest user account in Firebase
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Navigate to the profile screen and pass the guest user's email
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen3(onLogout: (){},),
      ),
    );
  } catch (error) {
    // Handle any errors that occur during account creation
    print('Error creating guest account: $error');
  }
}
