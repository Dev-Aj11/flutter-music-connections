import 'dart:collection';

import './song.dart';

class SongList {
  List<Song> _songs = [];

  addSong(
      {required artist,
      required songName,
      required albumCover,
      required popularity}) {
    _songs.add(Song(
        artist: artist,
        songName: songName,
        albumCover: albumCover,
        popularity: popularity));
  }

  _sortByPopularity() {
    for (Song song in _songs) {
      // implement compareTo method
    }
  }

  getSongs() {
    _sortByPopularity();
    return UnmodifiableListView(_songs);
  }

  String toString() {
    List<String> strSongList = [];
    for (Song song in _songs) {
      strSongList.add(song.toString());
    }
    return strSongList.toString();
  }
}
