import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import './song.dart';

class RequestedSongList {
  List<Song> _songs = [];
  late CollectionReference fbSongList;

  RequestedSongList() {
    // get songs from firebase
    fbSongList = FirebaseFirestore.instance.collection('songs');
  }

  Future getSongsFromFb() async {
    try {
      await fbSongList.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Song song = Song(
            albumCover: doc["albumUrl"],
            artist: doc["artist"],
            songName: doc["songName"],
            popularity: doc["popularity"],
            voteCount: doc["voteCount"],
          );
          _songs.add(song);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  // returns list of songs sorted by vote count
  List<Song> getSongs() {
    return UnmodifiableListView(_sortByVoteCount());
  }

  // increase vote count of song
  updateVoteCount(Song song, bool userVoted) async {
    // is this even required?
    int songIndex = _songs.indexOf(song);

    // update firebase
    int uid = song.toString().hashCode;

    // increment voteCount by 1
    int currVoteCount = _songs[songIndex].voteCount;
    int newVoteCount = (userVoted) ? currVoteCount-- : currVoteCount++;
    await fbSongList
        .doc(uid.toString())
        .update({'voteCount': newVoteCount})
        .then((value) => print("user updated vote count"))
        .catchError((onError) => print("Failed to update: $onError"));
  }

  // decrease vote count of song

  // return wether user has already voted for song

  Stream<QuerySnapshot> getStream() {
    return fbSongList.snapshots();
  }

  void updateSongList(snapshot) {
    // A postfix exclamation mark (!) takes the expression on the left and casts it to its underlying non-nullable type
    // In this case, snapshot.data! is casted to _jsonQuerySnapshot
    var docSnapshots = snapshot.data!.docs;

    // 2 ways to update local copy
    // 1) clear & refill (expensive)
    // 2) either vote count has changed or new song added (check for change & update)
    _songs.clear();

    // Firebase structure collection -> Documents Snapshot --> Could contain nested collections
    for (DocumentSnapshot document in docSnapshots) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      Song song = _getSongFromJson(data);
      _songs.add(song);
    }
    _sortByVoteCount();
  }

  // returns a list of songs sorted by Vote Count (high to low)
  List<Song> _sortByVoteCount() {
    _songs.sort((song1, song2) {
      return song2.voteCount.compareTo(song1.voteCount);
    });
    return _songs;
  }

  Song _getSongFromJson(Map<String, dynamic> songInfo) {
    int popularity = songInfo["popularity"] as int;
    int voteCount = songInfo["voteCount"];
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
}
