import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gogobook/Screens/login_screens/guest_account.dart';
import 'package:gogobook/Screens/login_screens/login_screen.dart';
import 'package:gogobook/Screens/onBoardingScreens.dart';
import 'package:gogobook/Screens/signUp_screen/sign_up_screen.dart';

class LogoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sfondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.black12,
          body: Container(
            margin: EdgeInsets.only(bottom: 20, top: 20),
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/GOGOBOOK_rast.png',
                      width: 170.0,
                      height: 170.0,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      'GOGOBOOK',
                      style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xfffab313)
                      ),
                    ),
                    SizedBox(height: 200,),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16.0, 0, 16, 14),
                      child: ElevatedButton(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: "Sora",
                            color: Color(0xFF313333),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(onLogin: (){})));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
                            backgroundColor: Colors.white.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      ),
                    ),

                    SizedBox(height: 16.0,),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16.0, 0, 16, 14),
                      child: ElevatedButton(
                        child: Text(
                          'logoScreenSignUp'.tr,
                          style: TextStyle(
                            fontFamily: "Sora",
                            color: Color(0xFF313333),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
                            backgroundColor: Colors.white.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                      ),
                    ),

                    SizedBox(height: 16.0,),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16.0, 0, 16, 14),
                      child: ElevatedButton(
                        child: Text(
                          'logoScreenGuest'.tr,
                          style: TextStyle(
                            fontFamily: "Sora",
                            color: Color(0xFF313333),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () {
                          createGuestAccount(context);
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
                            backgroundColor: Colors.white.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
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
