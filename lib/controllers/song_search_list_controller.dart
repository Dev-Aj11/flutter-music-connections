import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_connections/controllers/requested_song_list_controller.dart';
import 'package:music_connections/services/spotify_service.dart';

import '../models/song.dart';

class SongSearchListController {
  List<Song> _songsList = [];
  final CollectionReference fbSongs =
      FirebaseFirestore.instance.collection('songs');

  final ReqSongListController reqSongController;

  SongSearchListController(this.reqSongController);

  getSongList(userQuery) async {
    await SpotifyService().getSongs(userQuery, _songsList);
    // return UnmodifiableListView(_songsList);
  }

  getSongsSortedByPopularity() {
    // sorts by comparing popularity of song 1 with song 2
    // if song2 popularity > song1 popularity, compareTo returns 1
    // if song2 popularity == song1 popularity, compareTo returns 0
    // if song2 < song1, compareTo returns -1
    _songsList.sort((song1, song2) {
      return song2.popularity.compareTo(song1.popularity);
    });
    return UnmodifiableListView(_songsList);
  }

  // If a future doesn't produce a usable value, future's type is Future<void>
  // Future indicates that this function is conducting an async operation
  Future<bool> addSongToFb(
      String songName, String artist, String albumUrl, int popularity) async {
    Song song = Song(
        songName: songName,
        artist: artist,
        albumCover: albumUrl,
        popularity: popularity,
        voteCount: 0);

    // Create UID based on user inputs to check for duplication
    int uid = song.getUID();

    // if song already exists in DB, return false (song will not be added)
    bool songExists = reqSongController.containsSong(song);
    if (songExists) return false;

    // check if song already exists in the requestes songs db
    songExists = await fbSongs.doc(uid.toString()).get().then((docSnapshot) {
      fbSongs
          .doc(uid.toString())
          .set({
            'songName': songName,
            'artist': artist,
            'albumUrl': albumUrl,
            'popularity': popularity,
            'voteCount': 0,
          })
          .then((value) {})
          .catchError((error) {});
      return true;
    });
    // song added to DB
    return true;
  }
}
