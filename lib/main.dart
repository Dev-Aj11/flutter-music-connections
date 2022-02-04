import 'package:flutter/material.dart';
import 'package:music_connections/songs_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Music Connections"),
        ),
        body: SongsListScreen(),
      ),
    );
  }
}
