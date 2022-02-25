import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';

enum Settings { create, join }

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
            child: Text('Join Party Playlist'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, Settings.create);
            },
            // create party playlist
            child: Text("Create Party Playlist"),
          ),
        ],
      );
    },
  );
}

showJoinPlaylistDialog(BuildContext context) async {
  // TODO: limit to only 6 characters
  String userValue = "";
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Playlist Code"),
          content: TextField(
            onChanged: (value) {
              userValue = value;
            },
          ),
          actions: [
            TextButton(
              style: ButtonStyle(),
              onPressed: () async {
                if (await AppController.isValidPlaylist(userValue)) {
                  // show error & ask to retry code
                  Navigator.pop(context, userValue);
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      });
}

showPlaylistCreationDialog(BuildContext context, String userValue) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Enter Playlist Name"),
        content: TextField(
          onChanged: (value) {
            userValue = value;
          },
        ),
        // button enabled only if less than X char
        actions: [
          TextButton(
            style: ButtonStyle(),
            onPressed: () => Navigator.pop(context, userValue),
            child: Text("Submit"),
          )
        ],
      );
    },
  );
}
