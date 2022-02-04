import 'package:flutter/material.dart';
import 'models/song.dart';
import './services/spotify_service.dart';

class SongsListScreen extends StatelessWidget {
  void getSongList() async {
    await SpotifyService().getSongs('Moves like a jagger');
  }

  @override
  Widget build(BuildContext context) {
    getSongList();
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Request a song",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TextField(
            onChanged: (value) {},
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Requested Songs",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text("song name"),
                  subtitle: Text("artist name"),
                  // TODO: add voting up arrow with metadata
                );
              },
              itemCount: 2,
            ),
          )
        ],
      ),
    );
  }
}
