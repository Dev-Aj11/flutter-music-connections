import 'package:flutter/material.dart';
import 'package:music_connections/screens/song_search_screen.dart';
import 'package:music_connections/screens/songs_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/requested_song_list_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ReqSongListController reqSongController = ReqSongListController();
  bool reqSongListReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createSongList();
  }

  _createSongList() async {
    // init adds songs from firebase to local copy
    await reqSongController.getSongsFromFb();
    setState(() {
      reqSongListReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(dividerColor: Colors.transparent),
      initialRoute: '/',
      routes: {
        '/': (context) => SongsListScreen(reqSongController),
        '/request': (context) => SongSearchScreen(reqSongController)
      },
    );
  }
}
