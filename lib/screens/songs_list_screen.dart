import 'package:flutter/material.dart';
import '../models/song_list.dart';
import '../models/song.dart';
import '../components/song_tile.dart';
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
              child: RequestedSongsList(),
            )
          ],
        ),
      ),
    );
  }
}

class RequestedSongsList extends StatefulWidget {
  const RequestedSongsList({Key? key}) : super(key: key);

  @override
  _RequestedSongsListState createState() => _RequestedSongsListState();
}

class _RequestedSongsListState extends State<RequestedSongsList> {
  final Stream<QuerySnapshot> _songsStream =
      FirebaseFirestore.instance.collection('songs').snapshots();
  SongList songList = SongList();

  @override
  void initState() {
    super.initState();
    // songList = SongList();
  }

  void incrementVoteCount(Song song) {
    songList.incrementVote(song);
    print(song.toString());
    setState(() {});
  }

  void decreaseVoteCount(Song song) {
    // decrease vote when user disables
    songList.decrementVote(song);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _songsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          // A postfix exclamation mark (!) takes the expression on the left and casts it to its underlying non-nullable type
          // In this case, snapshot.data! is casted to _jsonQuerySnapshot
          var docSnapshots = snapshot.data!.docs;

          songList.clear();
          // Firebase structure collection -> Documents Snapshot --> Could contain nested collections
          for (DocumentSnapshot document in docSnapshots) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            Song song = songList.getSongFromJson(data);
            songList.addSong(song);
          }

          List<Song> songs = songList.getSongsSortedByVoteCount();
          print(songs.length);
          // print(songs.toList().toString());
          return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                Song song = songs[index];
                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: Image.network(song.albumCover),
                    title: Text(song.songName),
                    subtitle: Text(song.artist),
                    trailing: TextButton.icon(
                      style: (song.didUserVote() == true)
                          ? TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.12))
                          : null,
                      onPressed: () {
                        // when setState is triggered in this function
                        // is it rebuilding all the widgets or only one widget?
                        song.didUserVote()
                            ? decreaseVoteCount(song)
                            : incrementVoteCount(song);
                      },
                      icon: Icon(Icons.arrow_upward),
                      label: Text(song.voteCount.toString()),
                    ),
                  ),
                );
              });
        });
  }
}
