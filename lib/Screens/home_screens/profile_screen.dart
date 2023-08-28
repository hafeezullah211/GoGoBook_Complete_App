import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gogobook/LanguageChnageProvider.dart';
import 'package:gogobook/LocaleString.dart';
import 'package:gogobook/Screens/login_screens/logo_screen.dart';
import 'package:gogobook/Screens/signUp_screen/sign_up_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/button.dart';
import '../../theme_changer.dart';
import '../login_screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  final List locale = [
    {'name': 'English', 'locale': Locale('en_US')},
    {'name': 'Italian', 'locale': Locale('it_IT')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  builddialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(
              'Choose a Language',
              style: TextStyle(
                fontFamily: 'Sora',
              ),
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            updateLanguage(locale[index]['locale']);
                          },
                          child: Text(locale[index]["name"])),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.blue,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  Future<void> _signOutAndClearCache(BuildContext context) async {
    try {
      // Step 1: Perform sign-out operation
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (user.providerData
            .any((userInfo) => userInfo.providerId == 'password')) {
          // User logged in using Email/Password, perform sign out
          await FirebaseAuth.instance.signOut();
        } else if (user.providerData
            .any((userInfo) => userInfo.providerId == 'google.com')) {
          // User logged in using Google Sign-In, perform sign out
          await GoogleSignIn().signOut();
          await FirebaseAuth.instance.signOut();
        }
      }

      // Step 2: Clear cache using shared_preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Navigate to the login page or any other page as per your app's navigation flow
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen(onLogin: () {})));
    } catch (e) {
      // Handle sign-out or cache clearing errors here
      print('Error during sign-out or cache clearing: $e');
      // Show a snackbar or dialog to notify the user about the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during sign-out or cache clearing')),
      );
    }
  }

  // void _showDeleteConfirmationDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Confirm Account Deletion'),
  //         content: Text('Are you sure you want to delete your account?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.of(context).pop(); // Close the dialog
  //               await _deleteAccount(context);
  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => SignUpScreen()),
  //               );
  //             },
  //             child: Text('Confirm'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // Future<void> _deleteAccount(BuildContext context) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //
  //   try {
  //     if (user != null) {
  //       await FirebaseFirestore.instance
  //           .collection('Users')
  //           .doc(user.uid)
  //           .delete();
  //
  //       await user.delete();
  //     }
  //   } catch (error) {
  //     print('Error deleting user account: $error');
  //   }
  // }

  void deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        // Delete user data from Firestore
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).delete();

        // Delete the user account from FirebaseAuth
        await user.delete();

        // Navigate to the signup screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );
      }
    } catch (error) {
      print('Error deleting user account: $error');
      // Handle any errors that occurred during the deletion process
      // Show a snackbar or an alert dialog with an error message
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeChanger>(
      builder: (context, themeChanger, _) => MaterialApp(
        // translations: LocaleString(),
        // locale: Locale('en_US'),
        title: 'Profile Screen',
        theme: themeChanger.currentTheme,
        home: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white, // First color
                Color(0xFF07abb8), // Second color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentUser?.displayName ?? 'loadingText...'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: 'Sora',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Email:'.tr,
                      style: TextStyle(
                        // color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Sora',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _currentUser?.email ?? 'loadingText...'.tr,
                      style: const TextStyle(fontSize: 16.0),
                    ),

                    const SizedBox(
                      height: 32,
                    ),
                    firebaseUIButton(context, 'signOut'.tr, () {
                      _signOutAndClearCache(context);
                    }),

                    //Other Details
                    const SizedBox(height: 16.0),
                    Text(
                      'basicOptions'.tr,
                      style: TextStyle(
                        // color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: 'Sora',
                      ),
                    ),

                    const SizedBox(height: 16.0),
                    ListTile(
                      leading: const Icon(
                        Icons.wallet_giftcard,
                        color: Color(0xFFfab313),
                        size: 40,
                      ),
                      title: Text(
                        'supportUs'.tr,
                        style: TextStyle(
                          // color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Sora',
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Paypal support link:",
                              style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22
                              ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      launch("https://paypal.me/GoGOBook?country.x=IT&locale.x=it_IT");
                                    },
                                    child: Text(
                                      "https://paypal.me/GoGOBook?country.x=IT&locale.x=it_IT",
                                      style: TextStyle(
                                          color: Colors.blue,
                                        fontFamily: 'Sora'
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text("Paga con gogo book PayPal.Me\nVai su paypal.me/GoGOBook e immetti l'importo È facile e sicuro. Non hai un conto PayPal? Nessun problema.",
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Close"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 16.0),
                    ListTile(
                      leading: const Icon(
                        Icons.mail,
                        color: Color(0xFFfab313),
                        size: 40,
                      ),
                      title: const Text(
                        'gogobook.it@gmail.com',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Sora',
                        ),
                      ),
                      onTap: () {
                        // Handle contact mail option
                        // Implement your logic here
                      },
                    ),
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        builddialog(context);
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.language,
                          color: Color(0xFFfab313),
                          size: 40,
                        ),
                        title: Text(
                          'changeLanguageText'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<ThemeChanger>(context, listen: false)
                              .toggleTheme();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            padding: const EdgeInsets.fromLTRB(
                                14.0, 14.0, 14.0, 14.0),
                            backgroundColor: const Color(0xFF07abb8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.light_mode, // Light mode icon
                              size: 40,
                              color: Color(0xFFfab313),
                            ),
                            SizedBox(width: 8), // Space between icons
                            Text(
                              'switchThemeButton'.tr,
                              style: TextStyle(
                                fontFamily: "Sora",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                      child: ElevatedButton(
                        onPressed: () {
                          deleteAccount();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            padding: const EdgeInsets.fromLTRB(
                                14.0, 14.0, 14.0, 14.0),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_forever, // Light mode icon
                              size: 40,
                              color: Color(0xFFfab313),
                            ),
                            SizedBox(width: 8), // Space between icons
                            Text(
                              'deleteAccountButton'.tr,
                              style: TextStyle(
                                fontFamily: "Sora",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
