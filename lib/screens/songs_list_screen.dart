import 'package:flutter/material.dart';
import '../models/song_list.dart';
import '../models/song.dart';
import '../components/song_tile.dart';

class SongsListScreen extends StatefulWidget {
  @override
  State<SongsListScreen> createState() => _SongsListScreenState();
}

class _SongsListScreenState extends State<SongsListScreen> {
  SongList songList = SongList();
  String userQuery = "";

  void updateVoteCount(Song song) {
    songList.incrementVote(song);
    setState(() {});
  }

  void decreaseVoteCount(Song song) {
    // decrease vote when user disables
  }

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
              // if list is empty, ask user to request a song below
              child: SongTile(songList.getSongs(), updateVoteCount),
            )
          ],
        ),
      ),
    );
  }
}
