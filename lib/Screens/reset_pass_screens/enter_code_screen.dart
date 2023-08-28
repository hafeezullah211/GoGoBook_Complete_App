// import 'package:flutter/material.dart';
//
//
// class VerifyCodeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/images/sfondo.jpg'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.black12,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Verify Code',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 32,
//                 fontFamily: 'Sora',
//               ),
//             ),
//             Card(
//               color: Color.fromRGBO(49, 51, 51, 0.5),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0)
//               ),
//               margin: EdgeInsets.all(16.0),
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.fromLTRB(0, 14, 0, 0),
//                       child: Text(
//                         'An authentication code has been sent to your email.',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontFamily: 'Sora',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//
//
//                     SizedBox(height: 16.0),
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.fromLTRB(16.0, 18, 16, 14),
//                       child: TextFormField(
//                         // obscureText: true,
//                         cursorColor: Colors.black,
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontFamily: 'Sora'
//                         ),
//                         decoration: InputDecoration(
//                           labelText: 'Enter Code',
//                           labelStyle: TextStyle(
//                               fontFamily: 'Sora'
//                           ),
//                           contentPadding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
//                           filled: true,
//                           fillColor: Color(0xFFEAF4F4),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                             borderSide: BorderSide(),
//                           ),
//                         ),
//                       ),
//                     ),
//
//
//                     SizedBox(height: 16.0),
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.fromLTRB(16.0, 14, 16, 14),
//                       child: ElevatedButton(
//                         child: Text(
//                           'Set Password',
//                           style: TextStyle(
//                             fontFamily: "Sora",
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18.0,
//                           ),
//                         ),
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/set_password');
//                         },
//                         style: ElevatedButton.styleFrom(
//                             padding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
//                             backgroundColor: Color(0xFF07abb8),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             )),
//                       ),
//                     ),
//
//
//                     SizedBox(height: 16.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Didn't receive a code?",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontFamily: 'Sora',
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         IconButton(
//                             color: Color(0xFF07abb8),
//                             onPressed: () {
//                               // Handle resend icon button press
//                             },
//                             icon: Icon(Icons.refresh),
//                             iconSize: 32.0
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
