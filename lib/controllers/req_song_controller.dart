import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/song.dart';

// Controller for Requested Songs List
class ReqSongListController {
  List<Song> _songs = [];
  late DocumentReference fbSongList;
  late String _playlistCode;

  ReqSongListController(String playlistCode) {
    // get songs from firebase
    fbSongList =
        FirebaseFirestore.instance.collection('playlists').doc(playlistCode);
    _playlistCode = playlistCode;
  }

  Future getSongsFromFb() async {
    try {
      await fbSongList.get().then((DocumentSnapshot doc) {
        // return if song list is empty
        if (doc["songs"].length == 0) return;
        Map<String, dynamic> songList = doc["songs"];
        for (var songId in songList.keys) {
          Song song = Song.fromFirebase(songList[songId]);
          _songs.add(song);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  removeSongFromFb(Song song) async {
    await fbSongList.get().then((doc) {
      for (var songId in doc["songs"].keys) {
        if (songId == song.getUID().toString()) {
          var songCopyList = doc["songs"];
          songCopyList.remove(songId);
          fbSongList.update({'songs': songCopyList});
          _songs.remove(song);
          return;
        }
      }
    });
  }

  bool containsSong(Song s) {
    for (Song currSong in _songs) {
      if (s.toString() == currSong.toString()) {
        return true;
      }
    }
    return false;
  }

  // returns list of songs sorted by vote count
  List<Song> getSongs() {
    return UnmodifiableListView(_sortByVoteCount());
  }

  String getPlaylistCode() {
    return _playlistCode;
  }

  // returns a list of songs sorted by Vote Count (high to low)
  List<Song> _sortByVoteCount() {
    _songs.sort((song1, song2) {
      return song2.voteCount.compareTo(song1.voteCount);
    });
    return _songs;
  }

  // customIndexOf function
  int _indexOf(Song s) {
    for (var i = 0; i < _songs.length; i++) {
      if (_songs[i].toString() == s.toString()) {
        return i;
      }
    }
    return -1;
  }

  // ooff; changed return type from QuerySnapshot to DocumentSnapshot
  // something to do with Bloc pattern?
  Stream<DocumentSnapshot> getStream() {
    return fbSongList.snapshots();
  }

  // increase vote count of song
  updateVoteCount(Song song, bool userVoted) async {
    // update firebase
    int uid = song.toString().hashCode;

    int newVoteCount = 0;
    int songIndex = _indexOf(song);
    if (songIndex != -1) {
      Song song = _songs[songIndex];
      newVoteCount = (userVoted) ? --song.voteCount : ++song.voteCount;
    }

    // update localDB with new information about user
    song.toggleUserVoted();

    // update cloud DB
    await fbSongList
        .get()
        .then((DocumentSnapshot doc) {
          // {songId: {songName: "", }, songId: {songName: "", ...}, }
          Map<String, dynamic> songsCopy = doc["songs"];
          for (String songId in doc["songs"].keys) {
            if (uid.toString() == songId) {
              // update vote count
              songsCopy[songId]["voteCount"] = newVoteCount;
              fbSongList.update({"songs": songsCopy});
              break;
            }
          }
        })
        .then((value) => print("user updated vote count"))
        .catchError((onError) => print("Failed to update: $onError"));
  }

  // triggered when there is a change to firebase songs db
  void updateSongList(snapshot) {
    // A postfix exclamation mark (!) takes the expression on the left and casts it to its underlying non-nullable type
    // In this case, snapshot.data! is casted to _jsonQuerySnapshot
    var docSnapshots = snapshot.data!;

    if (docSnapshots["songs"].length == 0) {
      return;
    }
    Map<String, dynamic> songList = docSnapshots["songs"];
    for (String songId in songList.keys) {
      Song song = Song.fromFirebase(songList[songId]);

      // if song already exists, then only update vote count
      // if song doesn't exist, then add song to local db
      int songIndex = _indexOf(song);
      if (songIndex != -1) {
        // update vote count
        _songs[songIndex].voteCount = song.voteCount;
      } else {
        // if song doesn't exist, then add to the list
        print("added song in req_song_controller $_playlistCode");
        _songs.add(song);
      }
    }
    _sortByVoteCount();
  }
}
