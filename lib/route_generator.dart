import 'package:flutter/material.dart';
import 'package:music_connections/screens/join_playlist_screen.dart';
import 'package:music_connections/screens/home_screen.dart';
import 'package:music_connections/screens/song_search_screen.dart';
import 'package:music_connections/screens/playlist_viewer_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // argument passed in args = playlist code
    // if passing more then 1 variable, then convert args to map & extract values
    // see: https://stackoverflow.com/questions/60245865/the-operator-isnt-defined-for-the-class-object-dart
    final playlistCode = settings.arguments.toString();

    // loads screen based on route selected
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/join':
        return MaterialPageRoute(builder: (_) => JoinPlaylistScreen());
      case '/viewer':
        return MaterialPageRoute(
            builder: (context) => PlaylistViewerScreen(playlistCode, false));
      case '/request':
        return MaterialPageRoute(
            builder: (_) => SongSearchScreen(playlistCode));
      case '/owner':
        return MaterialPageRoute(
            builder: (_) => PlaylistViewerScreen(playlistCode, true));

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
