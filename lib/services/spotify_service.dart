import 'dart:convert';
import 'package:music_connections/services/network_helper.dart';
import '../models/song.dart';
import '../models/song_list.dart';

const String client_id = '8500b7a8752047c7b3937e6271828d84';
const String client_secret = 'a86d849e83a142aeb92391153fe36980';

class SpotifyService {
  String authToken = "";

  _getAuthorizationToken() async {
    String spotifyURL = 'https://accounts.spotify.com/api/token';
    String credentials = '$client_id:$client_secret';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encodedToken = stringToBase64.encode(credentials);

    var requestHeader = {'Authorization': 'Basic $encodedToken'};
    var requestBody = {'grant_type': 'client_credentials'};
    var jsonResponse =
        await NetworkHelper(spotifyURL).postReq(requestHeader, requestBody);
    authToken = jsonResponse["access_token"] ?? "";
  }

  getSongs(String userQuery) async {
    if (authToken.isEmpty) {
      await _getAuthorizationToken();
    }

    String spotifyURL =
        'https://api.spotify.com/v1/search?type=track&limit=10&q=positions';
    var requestHeaders = {'Authorization': 'Bearer $authToken'};
    var jsonResponse = await NetworkHelper(spotifyURL).getReq(requestHeaders);
    SongList songList = SongList();
    var jsonTracks = jsonResponse["tracks"]["items"];
    for (var jsonTrack in jsonTracks) {
      var songName = jsonTrack["name"];
      var popularity = jsonTrack["popularity"];
      var artist = jsonTrack["artists"][0]["name"];
      // var album = jsonTrack["album"][0]["name"];
      // var artwork = jsonTrack["album"][0]["images"][""];

      songList.addSong(
        songName: songName,
        artist: artist,
        albumCover: "yolo",
        popularity: popularity,
      );
      print(jsonTrack["name"]);
      print(jsonTrack["track_number"]);
    }
    print(songList.toString());
  }
}
