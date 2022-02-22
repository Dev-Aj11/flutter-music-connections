import 'package:flutter/material.dart';
import 'package:music_connections/controllers/app_controller.dart';
import 'package:music_connections/controllers/copy_req_song_controller.dart';
import 'package:music_connections/controllers/requested_song_list_controller.dart';
import 'package:music_connections/screens/playlist_owner_screen.dart';
import 'package:music_connections/screens/song_search_screen.dart';
import 'package:music_connections/screens/songs_list_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    // TODO: Should switch to getting 6 digit code from args
    // instead of using 'TESTIN'
    switch (settings.name) {
      case '/':
        var songsController = currPlaylists['TESTIN'];
        return MaterialPageRoute(
            builder: (context) => SongsListScreen(songsController));
      case '/request':
        var songsController = currPlaylists['TESTIN'];
        return MaterialPageRoute(
            builder: (_) => SongSearchScreen(songsController));
      case '/owner':
        // see: https://stackoverflow.com/questions/60245865/the-operator-isnt-defined-for-the-class-object-dart
        // on why casting to map is needed
        var x = args as Map;

        return MaterialPageRoute(
            builder: (_) =>
                PlaylistOwnerScreen(x["playlistName"], x["controller"]));

        // args = playlist name

        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
