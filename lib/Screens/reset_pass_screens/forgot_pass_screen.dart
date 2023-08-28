import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gogobook/common_widgets/button.dart';
import 'package:gogobook/common_widgets/text_form_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailTextController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'forgotPassScreenTitle'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      fontFamily: 'Sora',
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  color: Color.fromRGBO(49, 51, 51, 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                            child: reusableTextField(
                                "forgotPassScreenFieldText".tr, Icons.email, false, _emailTextController
                            ),
                        ),


                        SizedBox(height: 16.0),
                    firebaseUIButton(context, "forgotPassScreenButton".tr, () {
                      String email = _emailTextController.text.trim();

                      if (email.isEmpty) {
                        showSnackbar(context, 'forgotPassScreenError1'.tr);
                        return; // Exit the function if email is not provided
                      }

                      // Validate email format
                      bool isValidEmail = validateEmail(email);
                      if (!isValidEmail) {
                        showSnackbar(context, 'forgotPassScreenError2'.tr);
                        return; // Exit the function if email format is invalid
                      }

                      FirebaseAuth.instance.sendPasswordResetEmail(email: email)
                          .then((value) {
                        showSnackbar(context, 'forgotPassScreenError3'.tr);
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        String errorMessage = 'forgotPassScreenError4'.tr;

                        if (error is FirebaseAuthException) {
                          if (error.code == 'user-not-found') {
                            errorMessage = 'forgotPassScreenError5'.tr;
                          }
                        }
                        showSnackbar(context, errorMessage);
                      });
                    }),
                    ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
