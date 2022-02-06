import 'dart:collection';

import './song.dart';

class SongList {
  List<Song> _songs = [];

  addSong(
      {required artist,
      required songName,
      required albumCover,
      required popularity}) {
    _songs.add(
      Song(
          artist: artist,
          songName: songName,
          albumCover: albumCover,
          popularity: popularity,
          voteCount: 0),
    );
  }

  _sortByPopularity() {
    // sorts by comparing popularity of song 1 with song 2
    // if song2 popularity > song1 popularity, compareTo returns 1
    // if song2 popularity == song1 popularity, compareTo returns 0
    // if song2 < song1, compareTo returns -1
    _songs.sort((song1, song2) {
      return song2.popularity.compareTo(song1.popularity);
    });
  }

  incrementVote(Song song) {
    song.incrementVoteCount();
  }

  clear() {
    _songs.clear();
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
