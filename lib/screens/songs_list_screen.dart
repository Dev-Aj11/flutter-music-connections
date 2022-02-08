import 'package:flutter/material.dart';
import 'package:music_connections/models/requested_song_list.dart';
import '../models/song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
              child: RequestedSongListScreen(),
            )
          ],
        ),
      ),
    );
  }
}

class RequestedSongListScreen extends StatefulWidget {
  const RequestedSongListScreen({Key? key}) : super(key: key);

  @override
  _RequestedSongListScreenState createState() =>
      _RequestedSongListScreenState();
}

class _RequestedSongListScreenState extends State<RequestedSongListScreen> {
  RequestedSongList reqSongList = RequestedSongList();
  bool reqSongListReady = false;

  @override
  void initState() {
    super.initState();
    _createSongList();
  }

  _createSongList() async {
    // init adds songs from firebase to local copy
    await reqSongList.getSongsFromFb();
    reqSongListReady = true;
    setState(() {});
  }

  void updateVote(Song song, bool userVoted) async {
    // show progress indicator?
    await reqSongList.updateVoteCount(song, userVoted);
    // don't need to call setState here since
    // StreamBuilder<> will automatically do so when value is updated
  }

  @override
  Widget build(BuildContext context) {
    if (!reqSongListReady) {
      return Container(child: CircularProgressIndicator());
    }

    // i don't like this solution as it makes the view directly talk
    // to the model (FB); is there a better way to do this?
    return StreamBuilder<QuerySnapshot>(
        stream: reqSongList.getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          reqSongList.updateSongList(snapshot);

          List<Song> songList = reqSongList.getSongs();
          return ListView.builder(
              itemCount: songList.length,
              itemBuilder: (context, index) {
                Song song = songList[index];

                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: Image.network(song.albumCover),
                    title: Text(song.songName),
                    subtitle: Text(song.artist),
                    trailing: TextButton.icon(
                      onPressed: () {
                        updateVote(song, song.didUserVote());
                      },
                      icon: Icon(Icons.arrow_upward),
                      label: Text(
                        song.voteCount.toString(),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
