import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import 'package:music_connections/controllers/copy_req_song_controller.dart';
import 'package:music_connections/controllers/requested_song_list_controller.dart';
import './components/requested_songs_tiles_list.dart';

class PlaylistOwnerScreen extends StatelessWidget {
  final String playlist_name;
  final CopyReqSongController reqSongController;

  PlaylistOwnerScreen(this.playlist_name, this.reqSongController) {
    print('triggered');
    reqSongController.getSongsFromFb();
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
              // _settingsDialog(context);
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
            // BandInfo(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Requested Songs $playlist_name",
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
