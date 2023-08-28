import 'package:flutter/material.dart';

class PasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_image.jpg'),
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
                      'Log in',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                        fontFamily: 'Gotham',
                      ),
                    ),
                  ),


                  const SizedBox(height: 16.0),
                  Card(
                    color: Color.fromRGBO(49, 51, 51, 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [

                          SizedBox(height: 16,),
                          Text(
                            'John Doe',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Gotham'
                            ),
                          ),
                          Text(
                            'john.doe@example.com',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Gotham'
                            ),
                          ),


                          SizedBox(height: 16,),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(16.0, 18, 16, 14),
                            child: TextFormField(
                              obscureText: true,
                              cursorColor: Colors.black,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
                                filled: true,
                                fillColor: Color(0xFFEAF4F4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                hintText: 'Password',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                          ),



                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                            child: ElevatedButton(
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  fontFamily: "Gotham",
                                  color: Color(0xFF313333),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/home');
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
                                  backgroundColor: Color(0xFFCDE7BE),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                            ),
                          ),


                          SizedBox(height: 16.0),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 14),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/forgot_password');
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
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
    );
  }
}