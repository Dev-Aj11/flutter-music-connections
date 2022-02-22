import 'package:flutter/material.dart';
import 'package:music_connections/controllers/copy_req_song_controller.dart';
import 'package:music_connections/controllers/requested_song_list_controller.dart';
import 'package:music_connections/screens/playlist_owner_screen.dart';
import 'package:music_connections/screens/song_search_screen.dart';
import 'package:music_connections/screens/songs_list_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        // if (args is ReqSongListController) {
        return MaterialPageRoute(builder: (context) => SongsListScreen(args));
        // }
        return _errorRoute();
      case '/request':
        // if (args is ReqSongListController) {
        return MaterialPageRoute(builder: (_) => SongSearchScreen(args));
        // }
        return _errorRoute();
      case '/owner':
        print(args);
        if (args is CopyReqSongController) {
          // return MaterialPageRoute(builder: (_) => PlaylistOwnerScreen("hello", ))
        }
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
