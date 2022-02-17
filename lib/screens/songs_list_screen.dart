import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import 'package:music_connections/controllers/app_controller.dart';
import 'package:music_connections/controllers/requested_song_list_controller.dart';
import 'package:music_connections/screens/components/settings_dialog.dart';
import './components/band_info.dart';
import 'components/requested_songs_tiles_list.dart';

// Future TODO:
// Add artist information in top row
// Add quick way of giving feedback
class SongsListScreen extends StatelessWidget {
  final ReqSongListController reqSongController;
  SongsListScreen(this.reqSongController);

  _settingsDialog(BuildContext context) async {
    switch (await showDialog(
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
        })) {
      case Settings.join:
        // show invalid or valid code
        break;
      case Settings.create:
        // ask user to name playlist
        var playlist_name = await _createPlaylistDialog(context);

        // create playlist in Firebase
        // TODO: should check for errors
        // TODO: show spinner while playlist is being made
        var copyReqSongController =
            await AppController().createNewPlaylist(playlist_name);

        Navigator.pushReplacementNamed(context, '/owner',
            arguments: {playlist_name, copyReqSongController});
        break;
      case null:
        // dialog dismissed
        Navigator.pop(context);
        break;
    }
  }

  _createPlaylistDialog(BuildContext context) async {
    String userValue = "";
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Music Connections",
          style: kAppBarHeadingStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _settingsDialog(context);
            },
            icon: Icon(Icons.settings),
            iconSize: 24,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // pull up screen allowing user to add a new song
          Navigator.pushNamed(context, '/request');
        },
        icon: Icon(Icons.music_note_outlined),
        label: Text(
          "Request",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BandInfo(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Requested Songs",
              style: kSectionHeadingStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              // load from Firebase
              child: RequestedSongsTileList(this.reqSongController),
            )
          ],
        ),
      ),
    );
  }
}
