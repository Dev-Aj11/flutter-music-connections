import 'package:flutter/material.dart';
import 'package:music_connections/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
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
  // ReqSongListController reqSongController = ReqSongListController();
  // bool reqSongListReady = true;

  @override
  void initState() {
    super.initState();
    // _createSongList();
  }

  // _createSongList() async {
  //   // init adds songs from firebase to local copy, so other apps of the
  //   // app can pull it from here.
  //   // await reqSongController.getSongsFromFb();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(dividerColor: Colors.transparent),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
