import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import 'package:music_connections/controllers/app_controller.dart';
import 'package:music_connections/controllers/req_song_controller.dart';
import 'package:music_connections/screens/components/playlist_info.dart';
import 'package:music_connections/screens/components/settings_dialog.dart';
import 'components/requested_songs_tiles_list.dart';

class PlaylistViewerScreen extends StatelessWidget {
  late ReqSongListController reqSongController;
  final String playlistCode;

  PlaylistViewerScreen(this.playlistCode) {
    reqSongController = currPlaylists[playlistCode];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff9f9f9),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 10, 0),
          child: const Text(
            "Party Playlist",
            textAlign: TextAlign.left,
            style: kAppBarHeadingStyle,
          ),
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
        backgroundColor: kPrimaryColor,
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
        padding: EdgeInsets.only(top: 20, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlayListInfo(reqSongController.getPlaylistCode()),
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
              child: RequestedSongsTileList(this.playlistCode),
            )
          ],
        ),
      ),
    );
  }
}
