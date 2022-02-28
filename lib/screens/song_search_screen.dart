import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import 'package:music_connections/controllers/song_search_list_controller.dart';
import '../models/song.dart';
import './components/song_tile.dart';

class SongSearchScreen extends StatefulWidget {
  final String playlistCode;
  SongSearchScreen(this.playlistCode);

  @override
  _SongSearchScreenState createState() => _SongSearchScreenState();
}

class _SongSearchScreenState extends State<SongSearchScreen> {
  late SongSearchListController songs;
  String userQuery = "";
  bool showSnackBar = false;
  String snackBarMsg = "";

  @override
  void initState() {
    super.initState();
    // get initial song list
    songs = SongSearchListController(widget.playlistCode);
  }

  void getSongs() async {
    await songs.getSongList(userQuery);
    setState(() {});
  }

  void addSong(Song s) async {
    bool songAdded = await songs.addSongToFb(
        s.songName, s.artist, s.albumCover, s.popularity);

    if (!songAdded) {
      // already exists
      snackBarMsg = "Song already added in list.";
    } else {
      // added to song list
      snackBarMsg = "Song added to requested songs list.";
    }
    final snackBar = SnackBar(content: Text(snackBarMsg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xfff9f9f9),
        iconTheme: IconThemeData(color: Colors.black),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 10, 0),
          child: const Text(
            "Request a Song",
            textAlign: TextAlign.left,
            style: kAppBarHeadingStyle,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: kSearchFieldDecoration,
              cursorColor: kPrimaryColor,
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
              style: kSectionHeadingStyle,
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: SongTile(
                songs.getSongsSortedByPopularity(),
                addSong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
