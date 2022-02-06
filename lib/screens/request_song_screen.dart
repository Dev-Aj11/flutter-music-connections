import 'package:flutter/material.dart';
import '../components/song_tile.dart';
import '../models/song_list.dart';
import '../services/spotify_service.dart';

class RequestSongScreen extends StatefulWidget {
  const RequestSongScreen({Key? key}) : super(key: key);

  @override
  _RequestSongScreenState createState() => _RequestSongScreenState();
}

class _RequestSongScreenState extends State<RequestSongScreen> {
  SongList songList = SongList();
  String userQuery = "";

  void getSongList() async {
    await SpotifyService().getSongs(userQuery, songList);
    setState(() {});
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
                getSongList();
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
                },
                child: SongTile(songList.getSongs()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
