import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiver/core.dart';

class Song {
  late String artist;
  late String songName;
  late String albumCover;
  late int popularity;
  late int voteCount;
  bool _userVoted = false;

  Song(
      {required this.artist,
      required this.songName,
      required this.albumCover,
      required this.popularity,
      required this.voteCount});

  // Will accept QueryDocumentSnapshot or DocumentSnapshot
  Song.fromFirebase(dynamic doc) {
    this.albumCover = doc["albumUrl"];
    this.artist = doc["artist"];
    this.songName = doc["songName"];
    this.popularity = doc["popularity"];
    this.voteCount = doc["voteCount"];
  }

  Song getSongFromFirebase(DocumentSnapshot doc) {
    // Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    return Song.fromFirebase(doc);
  }

  String toString() {
    return "$songName$artist$albumCover$popularity";
  }

  void incrementVoteCount() {
    _userVoted = true;
    this.voteCount++;
  }

  void decrementVoteCount() {
    _userVoted = false;
    this.voteCount--;
  }

  void toggleUserVoted() {
    _userVoted = !_userVoted;
  }

  bool didUserVote() {
    // does this send a copy of the vote or the pointer to the original value?
    return _userVoted;
  }

  String getUID() {
    return "${this.songName}${this.artist}${this.albumCover}${this.popularity}";
  }
}
