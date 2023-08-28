// import 'package:flutter/material.dart';
//
// class MyTextFormField extends StatelessWidget {
//   final String labelText;
//   final FormFieldValidator<String>? validator;
//   final TextEditingController? controller;
//   final String? helperText;
//   final bool? hideText;
//
//   MyTextFormField({
//     required this.labelText,
//     this.validator,
//     this.controller,
//     this.helperText,
//     this.hideText,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.fromLTRB(16.0, 18, 16, 14),
//       child: TextFormField(
//         validator: validator,
//         controller: controller,
//         obscureText: hideText,
//         cursorColor: Colors.black,
//         style: TextStyle(
//           color: Colors.black,
//         ),
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
//           filled: true,
//           fillColor: Color(0xFFEAF4F4),
//           hintText: helperText,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8.0),
//             borderSide: BorderSide(),
//           ),
//         ),
//       ),
//     );
//   }
// }
