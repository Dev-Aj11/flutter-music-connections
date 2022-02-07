import 'dart:collection';

import './song.dart';

class SongList {
  List<Song> _songs = [];

  addNewSong(
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

  addSong(Song song) {
    if (!contains(song)) {
      _songs.add(song);
    }
  }

  _sortByVoteCount() {
    _songs.sort((song1, song2) {
      return song2.voteCount.compareTo(song1.popularity);
    });
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
    // update in firebase so that build() is retriggerd in requested_song list
  }

  decrementVote(Song song) {
    song.decrementVoteCount();
  }

  clear() {
    _songs.clear();
  }

  getSongsSortedByVoteCount() {
    _sortByVoteCount();
    return UnmodifiableListView(_songs);
  }

  getSongsSortedByPopularity() {
    _sortByPopularity();
    return UnmodifiableListView(_songs);
  }

  Song getSongFromJson(Map<String, dynamic> songInfo) {
    int popularity = songInfo["popularity"] as int;
    int voteCount = songInfo["voteCount"] as int;
    String artistName = songInfo["artist"];
    String songName = songInfo["songName"];
    String albumUrl = songInfo["albumUrl"];
    return Song(
        albumCover: albumUrl,
        popularity: popularity,
        voteCount: voteCount,
        songName: songName,
        artist: artistName);
  }

  String toString() {
    List<String> strSongList = [];
    for (Song song in _songs) {
      strSongList.add(song.toString());
    }
    return strSongList.toString();
  }

  bool contains(Song s) {
    for (Song song in _songs) {
      if (song.toString() == s.toString()) {
        return true;
      }
    }
    return false;
  }
}
