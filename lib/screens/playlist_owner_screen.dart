import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import 'package:music_connections/screens/components/settings_dialog.dart';
import './components/requested_songs_tiles_list.dart';
import './components/playlist_info.dart';

// TODO: Remove this screen & leverage styling from Viewer Screen;
// Add bool property isOwner
class PlaylistOwnerScreen extends StatelessWidget {
  final String playlistCode;

  PlaylistOwnerScreen(this.playlistCode);

  @override
  Widget build(BuildContext context) {
    print(playlistCode);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Music Connections",
          style: kAppBarHeadingStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              settingsDialog(context);
            },
            icon: Icon(Icons.settings),
            iconSize: 24,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // pull up screen allowing user to add a new song
          Navigator.pushNamed(context, '/request', arguments: playlistCode);
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
            PlayListInfo(playlistCode),
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
              child: RequestedSongsTileList(playlistCode),
            )
          ],
        ),
      ),
    );
  }
}
