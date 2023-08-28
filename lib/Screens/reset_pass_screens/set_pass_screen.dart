// import 'package:flutter/material.dart';
// import 'package:gogobook/common_widgets/pass_text_field.dart';
//
// class SetPasswordScreen extends StatelessWidget {
//   final TextEditingController textEditingController1 = TextEditingController();
//   final TextEditingController textEditingController2 = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//           inputDecorationTheme: InputDecorationTheme(
//             contentPadding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
//             filled: true,
//             fillColor: Color(0xFFEAF4F4),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide(),
//             ),
//             labelStyle: TextStyle(
//               color: Colors.black,
//             ),
//           )
//
//       ),
//       home: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/sfondo.jpg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.black12,
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'Code Verified',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 32,
//                   fontFamily: 'Sora',
//                 ),
//               ),
//
//               SizedBox(height: 16.0,),
//               Card(
//                 color: Color.fromRGBO(49, 51, 51, 0.5),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0)
//                 ),
//                 margin: EdgeInsets.all(16.0),
//                 child: Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       MyPassTextField(
//                         defaultHelpingText: 'Enter new password',
//                         controller: textEditingController1,
//                       ),
//
//                       SizedBox(height: 16.0),
//                       MyPassTextField(
//                         defaultHelpingText: 'Re-type new password',
//                         controller: textEditingController2,
//                       ),
//
//
//
//                       SizedBox(height: 16.0),
//                       Text(
//                         'At least 8 characters',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Sora'
//                         ),
//                       ),
//                       SizedBox(height: 16.0),
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.fromLTRB(16.0, 14, 16, 14),
//                         child: ElevatedButton(
//                           child: Text(
//                             'Set Password',
//                             style: TextStyle(
//                               fontFamily: "Sora",
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18.0,
//                             ),
//                           ),
//                           onPressed: () {
//                             Navigator.pushNamed(context, '/');
//                           },
//                           style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
//                               backgroundColor: Color(0xFF07abb8),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                               )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
