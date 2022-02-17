import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/song.dart';

// Controller for Requested Songs List

class ReqSongListController {
  List<Song> _songs = [];
  late CollectionReference fbSongList;

  ReqSongListController() {
    // get songs from firebase
    fbSongList = FirebaseFirestore.instance.collection('songs');
  }

  Future getSongsFromFb() async {
    try {
      await fbSongList.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Song song = Song.fromFirebase(doc);
          _songs.add(song);
        });
      });
    } catch (e) {
      print(e);
    }
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
    await fbSongList
        .doc(uid.toString())
        .update({'voteCount': newVoteCount})
        .then((value) => print("user updated vote count"))
        .catchError((onError) => print("Failed to update: $onError"));
  }

  Stream<QuerySnapshot> getStream() {
    return fbSongList.snapshots();
  }

  // triggered when there is a change to firebase songs db
  void updateSongList(snapshot) {
    // A postfix exclamation mark (!) takes the expression on the left and casts it to its underlying non-nullable type
    // In this case, snapshot.data! is casted to _jsonQuerySnapshot
    var docSnapshots = snapshot.data!.docs;

    // Firebase structure collection -> Documents Snapshot --> Could contain nested collections
    for (DocumentSnapshot document in docSnapshots) {
      Song song = Song.fromFirebase(document);

      // if song already exists, then only update vote count
      // if song doesn't exist, then add song to local db
      int songIndex = _indexOf(song);
      if (songIndex != -1) {
        // update vote count
        _songs[songIndex].voteCount = song.voteCount;
      } else {
        // if song doesn't exist, then add to the list
        _songs.add(song);
      }
    }
    _sortByVoteCount();
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

  // returns a list of songs sorted by Vote Count (high to low)
  List<Song> _sortByVoteCount() {
    _songs.sort((song1, song2) {
      return song2.voteCount.compareTo(song1.voteCount);
    });
    return _songs;
  }
}
