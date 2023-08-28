import 'package:flutter/material.dart';

class MyPassTextField extends StatefulWidget {
  final String defaultHelpingText;
  final TextEditingController controller;
  MyPassTextField({required this.defaultHelpingText, required this.controller});


  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<MyPassTextField> {
  bool _showPassword = false;
  late String helpingText;

  @override
  void initState() {
    super.initState();
    helpingText = widget.defaultHelpingText;
  }

  void updateHelpingText(String newText) {
    setState(() {
      helpingText = newText;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.0, 18, 16, 14),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: Colors.black,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: 'Password',
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Sora'
          ),
          hintText: helpingText,
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
        ),
        obscureText: !_showPassword,
      ),
    );
  }
}
