// determines which screens get access to what type of controller based on the
// playlist code
// manages state for the entire app

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_connections/controllers/req_song_controller.dart';

/*
  GLOBAL FIELDS 
  Meant to be accessed by all views / controllers throughout the app
*/
Map<String, dynamic> currPlaylists = {
  'TESTIN': ReqSongListController('TESTIN')
};
CollectionReference fbPlaylists =
    FirebaseFirestore.instance.collection('playlists');

/*
  Manages states such that each 6 digit code has a reference to the right playlist 
  in Firebase.
*/
class AppController {
  // creates a new playlist with given name in firebase
  // @returns: song controller pointer
  static Future<String?> createNewPlaylist(String name) async {
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

    // add to  global local database
    currPlaylists.update(
      randCode,
      // ignore incoming value
      (_) => ReqSongListController(randCode),
      ifAbsent: () => ReqSongListController(randCode),
    );

    return randCode;
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

  // @returns true if playlist for 6 digit code exists & adds to local db
  // @returns false if playlist for given code doesn't exist in firebase
  static Future<bool> isValidPlaylist(String code) async {
    bool playlistExists = false;
    await fbPlaylists.get().then((QuerySnapshot querySnapshot) {
      var docs = querySnapshot.docs;
      for (DocumentSnapshot doc in docs) {
        if (doc.id == code) {
          currPlaylists = {code: ReqSongListController(code)};
          playlistExists = true;
          break;
        }
      }
    });
    return playlistExists;
  }
}
