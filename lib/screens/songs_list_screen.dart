import 'package:flutter/material.dart';
import 'package:music_connections/components/requested_songs_tiles_list.dart';
import 'package:music_connections/models/requested_song_list.dart';

// Future TODO:
// Add artist information in top row
// Add quick way of giving feedback
class SongsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Connections"),
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
            SizedBox(
              height: 20,
            ),
            Text(
              "Requested Songs",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              // load from Firebase
              child: RequestedSongsTileList(),
            )
          ],
        ),
      ),
    );
  }
}
