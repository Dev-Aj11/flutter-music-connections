import 'package:flutter/material.dart';
import 'package:music_connections/components/song_tile.dart';
import 'package:music_connections/models/song_search_list.dart';
import '../models/song.dart';

class SongSearchScreen extends StatefulWidget {
  const SongSearchScreen({Key? key}) : super(key: key);

  @override
  _SongSearchScreenState createState() => _SongSearchScreenState();
}

class _SongSearchScreenState extends State<SongSearchScreen> {
  SongSearchList songs = SongSearchList();
  String userQuery = "";
  bool showSnackBar = false;
  String snackBarMsg = "";

  void getSongs() async {
    await songs.getSongList(userQuery);
    setState(() {});
  }

  void addSong(Song s) async {
    bool songExists = await songs.addSongToFb(
        s.songName, s.artist, s.albumCover, s.popularity);
    print(songExists);
    if (songExists) {
      // already exists
      snackBarMsg = "Song already added!";
    } else {
      // added to song list
      snackBarMsg = "Added song to requested songs list";
    }
    final snackBar = SnackBar(content: Text(snackBarMsg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request a song"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // text field
            TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                hintText: "Search for songs",
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                userQuery = value;
                getSongs();
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Results",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // circular indicator
                  // add to firebase
                  // show task bar / snack that song is added to requested songs menu
                  // Navigator.pop(context)
                  // check if song is already in the db
                  print('user touched');
                },
                child: SongTile(songs.getSongsSortedByPopularity(), addSong),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomSnackBar extends StatelessWidget {
//   final String snackBarMsg; 

//   @override
//   Widget build(BuildContext context) {
//     final snackBar = SnackBar(content: Text(snackBarMsg));
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }