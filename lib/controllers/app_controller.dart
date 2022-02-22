// determines which screens get access to what type of controller based on the
// playlist code
// manages state for the entire app

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_connections/controllers/copy_req_song_controller.dart';

Map<String, dynamic> currPlaylists = {
  'TESTIN': CopyReqSongController('TESTIN')
};
CollectionReference fbPlaylists =
    FirebaseFirestore.instance.collection('playlists');

class AppController {
  // creates a new playlist with given name
  // returns true if playlist
  static Future<CopyReqSongController?> createNewPlaylist(String name) async {
    // generate random 6 digit code
    String randCode = _getRandSixDigitCode();
    try {
      // update firebase with randCode & playlist Name
      await fbPlaylists
          .doc(randCode)
          .set({'playlistName': name, 'songs': []})
          .then((value) => print("playlist added successfully"))
          .catchError((onError) => print("Failed to add: $onError"));
    } catch (e) {
      print(e.toString());
    }

    currPlaylists.update(
      randCode,
      // ignore incoming value
      (value) => CopyReqSongController(randCode),
      ifAbsent: () => CopyReqSongController(randCode),
    );

    return currPlaylists[randCode];
  }

  // generates a unique, non-repeating 6 digit char sequence
  static String _getRandSixDigitCode() {
    var randCode = "";
    var possible =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    List<int> charPositions = [];
    for (var i = 0; i < 6; i++) {
      int randPos = Random().nextInt(possible.length);

      // check if character at position is already added to rand code
      while (charPositions.contains(randPos)) {
        randPos = Random().nextInt(possible.length);
      }
      charPositions.add(randPos);
      randCode += possible[randPos];
    }

    return randCode;
  }

  // returns true if playlist for code exists & adds to local db
  // returns false if playlist for given code doesn't exist
  Future<bool?> getPlaylistFromFb(String code) async {
    // loads all playlists from Firebase
    // such that the new Map is:
    try {
      await fbPlaylists.get().then((QuerySnapshot querySnapshot) {
        var docs = querySnapshot.docs;
        for (DocumentSnapshot doc in docs) {
          if (doc.toString() == code) {
            // ReqSongListController should take a "code" in constructor
            // so it pulls from the firebase obj.
            currPlaylists = {code: CopyReqSongController(code)};
            return true;
          }
        }
        return false;
      });
    } catch (e) {
      print(e);
    }
    return null;
  }
}
