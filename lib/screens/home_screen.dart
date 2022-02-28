import 'package:flutter/material.dart';
import 'package:music_connections/screens/components/settings_dialog.dart';
import '../constants.dart';
import '../controllers/app_controller.dart';

const music_party_image = 'lib/assets/images/music_party.png';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 80),
        width: double.infinity,
        color: Color(0xfff9f9f9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "PLAY MY SONG",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: kAppDescriptionStyle, children: [
                TextSpan(text: "Request, Vote, & Play the most "),
                TextSpan(
                  text: "poppin'",
                  style: kAppDescriptionStyle.copyWith(
                    color: kPrimaryColor,
                  ),
                ),
                TextSpan(text: "music")
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset(
              music_party_image,
              width: 300,
              height: 300,
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // ask to enter 6 digit code
                    Navigator.pushNamed(context, '/join');
                  },
                  style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    child: Center(
                      child: Text(
                        "Join Playlist",
                        textAlign: TextAlign.center,
                        style: kPrimaryActionBtnStyle,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    // go to owner screen
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFFFFF),
                      side: BorderSide(color: kPrimaryColor)),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    child: Center(
                      child: Text(
                        "Create Playlist",
                        textAlign: TextAlign.center,
                        style: kPrimaryActionBtnStyle.copyWith(
                            color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/*

class _HomeScreenState extends State<HomeScreen> {
  String playlistCode = "";
  String playlistName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Music Connections",
          style: kAppBarHeadingStyle,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                child: Column(children: [
                  Text(
                    "Enter Playlist Code",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      playlistCode = value;
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        (playlistCode.length == 6)
                            ? Text(
                                " Enter 6 digit code",
                                style: TextStyle(color: Colors.green),
                              )
                            : Text(
                                "X Enter 6 digit code",
                                style: TextStyle(color: Colors.red),
                              ),
                        TextButton(
                          onPressed: () async {
                            // check if it's a valid 6 digit code
                            bool validPlaylist =
                                await AppController.isValidPlaylist(
                                    playlistCode);

                            if (validPlaylist) {
                              // Replace with playlist songs
                              Navigator.pushReplacementNamed(context, '/viewer',
                                  arguments: playlistCode);
                            } else {
                              showInvalidCodeDialog(context);
                            }
                          },
                          child: Text("SUBMIT"),
                        )
                      ])
                ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("OR"),
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                child: Column(children: [
                  Text(
                    "Create New Playlist",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      playlistName = value;
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      // create playlist in Firebase
                      var playlistCode =
                          await AppController.createNewPlaylist(playlistName);

                      // Navigate to next screen
                      Navigator.pushReplacementNamed(context, '/owner',
                          arguments: playlistCode);
                    },
                    child: Text("SUBMIT"),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
