import 'package:flutter/material.dart';
import 'package:music_connections/screens/request_song_screen.dart';
import 'package:music_connections/screens/songs_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SongsListScreen(),
        '/request': (context) => RequestSongScreen()
      },
    );
  }
}
