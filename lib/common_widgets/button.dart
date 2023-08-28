import 'package:flutter/material.dart';

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(16.0, 14, 16, 14),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: "Sora",
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
          backgroundColor: Color(0xFF07abb8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          )),
    ),
  );
}