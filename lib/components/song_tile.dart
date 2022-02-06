import 'package:flutter/material.dart';
import '../models/song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

/*
Future TODO: Upgrade styling for songs with a custom Card that includes: 
a) taller cards
b) larger artwork
c) moving the votecount metadata below the upvote arrow
*/
class SongTile extends StatelessWidget {
  final List<Song> songs;
  final Function? updateVoteCount;
  final CollectionReference fbSongs =
      FirebaseFirestore.instance.collection('songs');

  Future<void> addSong(
      String songName, String artist, String albumUrl, int popularity) {
    // var id = uuid.v5(options: {
    //   'songName': songName,
    //   'artist': artist,
    //   'albumUrl': albumUrl,
    //   'popularity': popularity,
    // });
    // Create UID based on user inputs to check for duplication
    int uid = "$songName$artist$albumUrl$popularity".hashCode;

    // check if song already exists in the requestes songs db
    return fbSongs.doc(uid.toString()).get().then((docSnapshot) {
      if (!docSnapshot.exists) {
        fbSongs
            .doc(uid.toString())
            .set({
              'songName': songName,
              'artist': artist,
              'albumUrl': albumUrl,
              'popularity': popularity,
              'voteCount': 0,
            })
            .then((value) => print("song added"))
            .catchError((error) => print("Failed due to $error"));
      }
    });
  }

  // sets itself to null if updateVoteCount is not passed
  SongTile(this.songs, [this.updateVoteCount]);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Song song = songs[index];
        return InkWell(
          onTap: () {
            addSong(
              song.songName,
              song.artist,
              song.albumCover,
              song.popularity,
            );
          },
          child: Card(
            elevation: 4,
            child: ListTile(
              leading: Image.network(song.albumCover),
              title: Text(song.songName),
              subtitle: Text(song.artist),
              trailing: (updateVoteCount != null)
                  ? TextButton.icon(
                      onPressed: () {
                        this.updateVoteCount!(song);
                      },
                      icon: Icon(Icons.arrow_upward),
                      label: Text(song.voteCount.toString()))
                  : SizedBox.shrink(),
            ),
          ),
        );
      },
      itemCount: this.songs.length,
    );
  }
}
