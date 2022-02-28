import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class JoinPlaylistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff9f9f9),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                text: "Please enter the 6 digit code to join a ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito',
                  fontSize: 24,
                ),
                children: [
                  TextSpan(
                    text: "party ",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nunito',
                      fontSize: 24,
                    ),
                  ),
                  TextSpan(text: "playlist"),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            PinCodeTextField(
                appContext: context,
                length: 6,
                cursorColor: kPrimaryColor,
                pinTheme: PinTheme(
                  activeColor: kPrimaryColor,
                  selectedColor: kPrimaryColor,
                ),
                onChanged: (value) {
                  print(value);
                }),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.pushNamed(context, '/join');
              },
              style: ElevatedButton.styleFrom(primary: kPrimaryColor),
              child: Container(
                width: double.infinity,
                height: 48,
                child: Center(
                  child: Text(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: kPrimaryActionBtnStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
