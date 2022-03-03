import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_connections/controllers/app_controller.dart';
import 'package:music_connections/controllers/req_song_controller.dart';
import 'package:music_connections/services/spotify_service.dart';

import '../models/song.dart';

class SongSearchListController {
  List<Song> _songsList = [];
  late DocumentReference fbSongs;
  final String playlistCode;

  SongSearchListController(this.playlistCode) {
    fbSongs =
        FirebaseFirestore.instance.collection('playlists').doc(playlistCode);
  }

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
    String uid = song.getUID();

    // if song already exists in DB, return false (song will not be added)
    bool songExists = currPlaylists[playlistCode].containsSong(song);
    if (songExists) return false;

    // add to firebase if song doesn't exist in playlist
    songExists = await fbSongs.get().then((docSnap) {
      var songListCopy = {};
      if (docSnap["songs"].length != 0) {
        songListCopy = Map<String, dynamic>.from(docSnap["songs"]);
      }
      Map<String, dynamic> newSong = {
        'songName': songName,
        'artist': artist,
        'albumUrl': albumUrl,
        'popularity': popularity,
        'voteCount': 0
      };
      songListCopy.putIfAbsent(uid, () => newSong);
      fbSongs.update({'songs': songListCopy});
      return true;
    });
    return true;
  }
}
