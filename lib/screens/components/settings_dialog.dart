import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controllers/app_controller.dart';

enum Settings { create, join }

settingsDialog(BuildContext context) async {
  switch (await showPlaylistOptionsDialog(context)) {
    case Settings.join:
      // @return: valid 6 digit playlist code inputted by user
      var playlistCode = await showJoinPlaylistDialog(context);
      if (playlistCode == null) return;

      // pass playlist code to the viewer screen via onGenerateRoute
      Navigator.pushReplacementNamed(context, '/viewer',
          arguments: playlistCode);

      break;
    case Settings.create:
      // create new playlist & add to firebase
      var playlistCode = await AppController.createNewPlaylist();

      // pass playlist code to next screen
      Navigator.pushReplacementNamed(context, '/owner',
          arguments: playlistCode);
      break;
    case null:
      // dialog dismissed by itself
      break;
  }
}

showPlaylistOptionsDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text("Select Option"),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, Settings.join);
            },
            child: Text('Join Party Playlist',
                style: TextStyle(color: kPrimaryColor)),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, Settings.create);
            },
            // create party playlist
            child: Text("Create Party Playlist",
                style: TextStyle(color: kPrimaryColor)),
          ),
        ],
      );
    },
  );
}

showJoinPlaylistDialog(BuildContext context) async {
  String userValue = "";
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Playlist Code"),
          content: PinCodeTextField(
              appContext: context,
              length: 6,
              cursorColor: kPrimaryColor,
              pinTheme: PinTheme(
                activeColor: kPrimaryColor,
                selectedColor: kPrimaryColor,
                fieldWidth: 24,
              ),
              onChanged: (value) {
                userValue = value;
              }),
          actions: [
            TextButton(
              style: ButtonStyle(),
              onPressed: () async {
                if (await AppController.isValidPlaylist(userValue)) {
                  // show error & ask to retry code
                  Navigator.pop(context, userValue);
                } else {
                  showInvalidCodeDialog(context);
                  userValue = "";
                }
              },
              child: Text("Submit", style: TextStyle(color: kPrimaryColor)),
            ),
          ],
        );
      });
}

showInvalidCodeDialog(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Invalid Playlist Code"),
          content: Text("Please enter a valid 6 digit playlist code"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(color: kPrimaryColor),
              ),
            )
          ],
        );
      });
}
