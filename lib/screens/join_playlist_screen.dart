import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import 'package:music_connections/screens/components/cta_btn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../controllers/app_controller.dart';
import 'components/settings_dialog.dart';

class JoinPlaylistScreen extends StatefulWidget {
  @override
  State<JoinPlaylistScreen> createState() => _JoinPlaylistScreenState();
}

class _JoinPlaylistScreenState extends State<JoinPlaylistScreen> {
  String userPlaylistCode = "";

  void onPressed() async {
    // check if it's a valid 6 digit code;
    if (await AppController.isValidPlaylist(userPlaylistCode)) {
      Navigator.pushNamedAndRemoveUntil(context, '/viewer', (_) => false,
          arguments: userPlaylistCode);
    } else {
      showInvalidCodeDialog(context);
    }
  }

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
                  userPlaylistCode = value;
                }),
            SizedBox(
              height: 30,
            ),
            CTA_Btn(onPressed, "Submit", BtnStyle.primary)
          ],
        ),
      ),
    );
  }
}
