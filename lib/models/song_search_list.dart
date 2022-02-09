import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_connections/services/spotify_service.dart';

import './song.dart';

class SongSearchList {
  List<Song> _songs = [];
  final CollectionReference fbSongs =
      FirebaseFirestore.instance.collection('songs');

  getSongList(userQuery) async {
    await SpotifyService().getSongs(userQuery, _songs);
    // return UnmodifiableListView(_songs);
  }

  getSongsSortedByPopularity() {
    // sorts by comparing popularity of song 1 with song 2
    // if song2 popularity > song1 popularity, compareTo returns 1
    // if song2 popularity == song1 popularity, compareTo returns 0
    // if song2 < song1, compareTo returns -1
    _songs.sort((song1, song2) {
      return song2.popularity.compareTo(song1.popularity);
    });
    return UnmodifiableListView(_songs);
  }

  // If a future doesn't produce a usable value, future's type is Future<void>
  // Future indicates that this function is conducting an async operation
  Future<bool> addSongToFb(
      String songName, String artist, String albumUrl, int popularity) async {
    // Create UID based on user inputs to check for duplication
    int uid = "$songName$artist$albumUrl$popularity".hashCode;
    bool songExists;

    // check if song already exists in the requestes songs db
    songExists = await fbSongs.doc(uid.toString()).get().then((docSnapshot) {
      if (!docSnapshot.exists) {
        fbSongs.doc(uid.toString()).set({
          'songName': songName,
          'artist': artist,
          'albumUrl': albumUrl,
          'popularity': popularity,
          'voteCount': 0,
        }).then((value) {
          return false;
        }).catchError((error) {
          return false;
        });
      } else {
        return true;
      }

      // why do I need to return here?
      return false;
    });
    return songExists;
  }
}
