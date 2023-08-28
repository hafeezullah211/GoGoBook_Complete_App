import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gogobook/Screens/home_screens/nav_screen.dart';
import 'package:gogobook/Screens/reset_pass_screens/forgot_pass_screen.dart';
import 'package:gogobook/Screens/signUp_screen/sign_up_screen.dart';
import 'package:gogobook/common_widgets/button.dart';
import 'package:gogobook/common_widgets/text_form_field.dart';


class LoginScreen extends StatefulWidget {
  final Function onLogin; // Add this line
  LoginScreen({required this.onLogin}); // Add this constructor

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController textEditingController1 = TextEditingController();

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
            filled: true,
            fillColor: const Color(0xFFEAF4F4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(),
            ),
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
          )

      ),
      home: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/sfondo.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.black12,
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Card(
                        color: const Color.fromRGBO(49, 51, 51, 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 16,),
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                                  child: reusableTextField(
                                      'SignUpScreenEmailField'.tr, Icons.email, false, _emailTextController
                                  )
                              ),

                              const SizedBox(height: 16,),
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                                  child: reusableTextField(
                                      "SignUpScreenPassField".tr, Icons.password, true, _passwordTextController
                                  )
                              ),


                              const SizedBox(height: 32.0),
                              firebaseUIButton(context, 'Login', () async {
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                  );
                                  Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => HomeScreen3(onLogout: (){},))
                                  );
                                } catch (error) {
                                  // String errorMessage = 'An error occurred.';
                                  Fluttertoast.showToast(
                                    msg: 'loginError1'.tr,
                                    gravity: ToastGravity.BOTTOM,
                                    toastLength: Toast.LENGTH_SHORT,
                                  );

                                  if (error is FirebaseAuthException) {
                                    if (error.code == 'user-not-found') {
                                      // errorMessage = 'User not found. Please create an account.';
                                      Fluttertoast.showToast(
                                        msg: 'loginError2'.tr,
                                        gravity: ToastGravity.BOTTOM,
                                        toastLength: Toast.LENGTH_SHORT,
                                      );
                                      // showSnackbar(context, 'User not found. Please create your account.');
                                    } else if (error.code == 'wrong-password') {
                                      // errorMessage = 'Incorrect email or password.';
                                      Fluttertoast.showToast(
                                        msg: 'loginError2'.tr,
                                        gravity: ToastGravity.BOTTOM,
                                        toastLength: Toast.LENGTH_SHORT,
                                      );
                                      // showSnackbar(context, 'Incorrect email or password.');
                                    }
                                  }
                                }
                              }),

                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                // padding: EdgeInsets.fromLTRB(0, 0, 0, 14),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                                  },
                                  child: Text(
                                    'loginText'.tr,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Sora'
                                    ),
                                  ),
                                ),
                              ),


                              const SizedBox(height: 32.0),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'loginText2'.tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Sora',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => SignUpScreen())
                                        );
                                      },
                                      child: Text(
                                        "loginText3".tr,
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
                              ),
                              const SizedBox(height: 16,)
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
      ),
    );
  }
}

class ShowSnackbar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

