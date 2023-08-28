import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:gogobook/Screens/home_screens/nav_screen.dart';
import 'package:gogobook/Screens/onBoardingScreens.dart';
import 'package:gogobook/Screens/terms_screen.dart';
import 'package:gogobook/Services/firebase_service.dart';
import 'package:gogobook/common_widgets/button.dart';
import 'package:gogobook/common_widgets/text_form_field.dart';
import 'package:google_api_availability/google_api_availability.dart';

import '../login_screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isloggedIn = false;
  Map _userObj = {};
  bool _acceptTerms = false;
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  bool validateEmail(String email) {
    // Use a regular expression pattern to validate the email format
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }


  Future<void> storeUserData(String name, String email, String uid) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('Users');
      await userRef.doc(uid).set({
        'name': name,
        'email': email,
        'homePageTutorialCompleted': false,
        'searchPageTutorialCompleted': false,
      });
      print('User data stored successfully');
    } catch (error) {
      print('Failed to store user data: $error');
    }
  }

  void signInWithGoogle() async {
    if (_acceptTerms) {
      await FireBaseServices().SignInWithGoogle();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen3(onLogout: () {})),
      );
    } else {
      showTermsSnackbar(context);
    }
  }

  // Map<String,dynamic>? _userData;
  //
  // Future<UserCredential> signInFacebook() async {
  //   final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email,']);
  //   if (loginResult == LoginStatus.success){
  //     final userData = await FacebookAuth.instance.getUserData();
  //     _userData = userData;
  //   }else{
  //     print(loginResult.message);
  //   }
  //
  //   final OAuthCredential oAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //   return FirebaseAuth.instance.signInWithCredential(oAuthCredential);
  // }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sfondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.black12,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          'SignUpScreenTitle'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            fontFamily: 'Sora',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Card(
                        color: const Color.fromRGBO(49, 51, 51, 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 14, 16, 14),
                                  child: reusableTextField(
                                      'SignUpScreenNameField'.tr,
                                      Icons.text_fields,
                                      false,
                                      _userNameTextController)),

                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 14, 16, 14),
                                  child: reusableTextField(
                                      'SignUpScreenEmailField'.tr,
                                      Icons.email,
                                      false,
                                      _emailTextController)),

                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 14, 16, 14),
                                  child: reusableTextField(
                                      'SignUpScreenPassField'.tr,
                                      Icons.password,
                                      true,
                                      _passwordTextController)),

                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: _acceptTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _acceptTerms = value!;
                                      });
                                    },
                                    visualDensity: VisualDensity.comfortable,
                                    checkColor: Colors
                                        .white, // Sets the color of the check mark when checked
                                    side: const BorderSide(
                                        color: Colors
                                            .white), // Sets the border color
                                  ),
                                  Text(
                                    'SignUpScreenTPText'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Sora',
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TermsOfServiceScreen()));
                                    },
                                    child: Text(
                                      'SignUpScreenTPText2'.tr,
                                      style: TextStyle(
                                        color: Color(0xFF07abb8),
                                        fontFamily: 'Sora',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              //Sign Up Button
                              const SizedBox(
                                height: 16,
                              ),
                              firebaseUIButton(context, 'SignUpScreenButton'.tr,
                                  () {
                                if (_acceptTerms) {
                                  if (_userNameTextController.text.isEmpty) {
                                    showSnackbar(
                                        context, 'SignUpScreenError'.tr);
                                    return; // Exit the function if name is not provided
                                  }
                                  if (_emailTextController.text.isEmpty) {
                                    showSnackbar(
                                        context, 'SignUpScreenError2'.tr);
                                    return; // Exit the function if email is not provided
                                  }
                                  if (!validateEmail(
                                      _emailTextController.text)) {
                                    showSnackbar(
                                        context, 'SignUpScreenError3'.tr);
                                    return; // Exit the function if email format is invalid
                                  }

                                  if (_passwordTextController.text.length < 8) {
                                    showSnackbar(context,
                                        'Your password must be at least 8 characters long.');
                                    return;
                                  }
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                  )
                                      .then((value) {
                                    // Save the user's name in Firebase
                                    User? user =
                                        FirebaseAuth.instance.currentUser;
                                    user?.updateDisplayName(
                                        _userNameTextController.text);

                                    print('New Account Created Successfully');
                                    storeUserData(
                                      _userNameTextController.text,
                                      _emailTextController.text,
                                      value.user!.uid,
                                    ); // Store user data in Firestore
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen3(onLogout: () {})));
                                  }).catchError((error) {
                                    String errorMessage = 'An error occurred.';

                                    if (error is FirebaseAuthException) {
                                      if (error.code == 'weak-password') {
                                        errorMessage = 'SignUpScreenError5'.tr;
                                      } else if (error.code ==
                                          'email-already-in-use') {
                                        errorMessage = 'SignUpScreenError6'.tr;
                                      }
                                    }
                                    showSnackbar(context, errorMessage);
                                  });
                                } else {
                                  showTermsSnackbar(context);
                                }
                              }),

                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Color(0xFF939999),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                                    child: Text(
                                      'SignUpScreenDivider'.tr,
                                      style: TextStyle(
                                          fontFamily: 'Sora',
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF939999)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Color(0xFF939999),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 14, 16, 14),
                                    child: ElevatedButton(
                                      onPressed: signInWithGoogle,
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.fromLTRB(
                                              14.0, 16.0, 14.0, 16.0),
                                          backgroundColor:
                                              const Color(0xFFEAF4F4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0))),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image(
                                            image: AssetImage(
                                              'assets/images/g.png',
                                            ),
                                            width: 25.0,
                                            height: 25.0,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            'SignInWithGoogle'.tr,
                                            style: TextStyle(
                                              fontFamily: "Sora",
                                              color: Color(0xFF313333),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 14, 16, 14),
                                    child: ElevatedButton(
                                      onPressed: () {
                                            // signInFacebook();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.fromLTRB(
                                              14.0, 16.0, 14.0, 16.0),
                                          backgroundColor:
                                              const Color(0xFFEAF4F4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0))),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/images/f.png'),
                                            width: 25,
                                            height: 25,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            'SignInWithFacebook'.tr,
                                            style: TextStyle(
                                              fontFamily: "Sora",
                                              color: Color(0xFF313333),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen(
                                                onLogin: () {},
                                              )));
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'signUpScreenLastText'.tr,
                                        style: TextStyle(
                                          fontFamily: 'Sora',
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ' Login',
                                        style: TextStyle(
                                          color: Color(0xFF07abb8),
                                          fontFamily: 'Sora',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
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
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showTermsSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please accept the Terms and Policies to continue.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

