import 'package:flutter/material.dart';
import 'package:music_connections/controllers/app_controller.dart';
import 'package:music_connections/controllers/copy_req_song_controller.dart';
import 'package:music_connections/route_generator.dart';
import 'package:music_connections/screens/playlist_owner_screen.dart';
import 'package:music_connections/screens/song_search_screen.dart';
import 'package:music_connections/screens/songs_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/requested_song_list_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
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
  // bool reqSongListReady = true;

  @override
  void initState() {
    super.initState();
    _createSongList();
  }

  _createSongList() async {
    // init adds songs from firebase to local copy, so other apps of the
    // app can pull it from here.
    await reqSongController.getSongsFromFb();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(dividerColor: Colors.transparent),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      // routes: {
      //   '/': (context) => SongsListScreen(reqSongController),
      //   '/request': (context) => SongSearchScreen(reqSongController),
      //   '/owner': (context) {
      //     // TODO: FIX
      //     print('why am I here?');
      //     return PlaylistOwnerScreen("herl", CopyReqSongController('yolo'));
      //   }
    );
  }
}
