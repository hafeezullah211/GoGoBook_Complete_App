// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gogobook/Screens/login_screens/logo_screen.dart';
//
// import 'Screens/home_screens/nav_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//
//     Timer(Duration(seconds: 5), () {
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => FirebaseAuth.instance.currentUser != null
//                 ? HomeScreen3(onLogout: () {})
//                 : LogoScreen(),
//           ));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.white, // First color
//                 Color(0xFF07abb8), // Second color
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: Center(
//             child: Column(
//               children: [
//                 Image.asset('assets/images/GOGOBOOK_rast.png',
//                   width: 170.0,
//                   height: 170.0,
//                 ),
//                 SizedBox(height: 16,),
//                 Text(
//                   'GOGOBOOK',
//                   style: TextStyle(
//                       fontFamily: 'Sora',
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xfffab313)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gogobook/Screens/login_screens/logo_screen.dart';
import 'Screens/home_screens/nav_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FirebaseAuth.instance.currentUser != null
                ? HomeScreen3(onLogout: () {})
                : LogoScreen(),
          ));
    });

    // Add a delay to show the content with a fade-in animation
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showContent = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
          child: AnimatedOpacity(
            opacity: _showContent ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/GOGOBOOK_rast.png',
                    width: 170.0,
                    height: 170.0,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'GOGOBOOK',
                    style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfffab313)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

