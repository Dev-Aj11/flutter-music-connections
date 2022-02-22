import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import 'package:music_connections/controllers/copy_req_song_controller.dart';
import 'package:music_connections/controllers/requested_song_list_controller.dart';
import 'package:music_connections/controllers/song_search_list_controller.dart';
import '../models/song.dart';
import './components/song_tile.dart';

class SongSearchScreen extends StatefulWidget {
  final CopyReqSongController reqSongController;
  SongSearchScreen(this.reqSongController);

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
    // TODO: pass playlist ID
    songs = SongSearchListController(widget.reqSongController, 'TESTIN');
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
      appBar: AppBar(
        title: Text(
          "Request a song",
          style: kAppBarHeadingStyle,
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
