import 'package:flutter/material.dart';
import 'package:music_connections/controllers/app_controller.dart';
import 'package:music_connections/controllers/req_song_controller.dart';
import '../../models/song.dart';
import '../components/song_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestedSongsTileList extends StatefulWidget {
  final String playlistCode;
  final bool isOwner;
  RequestedSongsTileList(this.playlistCode, this.isOwner);

  @override
  _SongTilesState createState() => _SongTilesState();
}

class _SongTilesState extends State<RequestedSongsTileList> {
  late ReqSongListController reqSongController;
  bool reqSongListReady = false;

  @override
  void initState() {
    super.initState();

    // update song list controller tied to playlist code, so
    // instance of _songs can be shared across classes
    reqSongController = currPlaylists[widget.playlistCode];
    _createSongList();
  }

  _createSongList() async {
    // init adds songs from firebase to local copy
    await reqSongController.getSongsFromFb();
    setState(() {
      reqSongListReady = true;
    });
  }

  void updateVote(Song song, bool userVoted) async {
    // show progress indicator?
    print("from req_song_tile");
    await reqSongController.updateVoteCount(song, userVoted);
    // don't need to call setState here since
    // StreamBuilder<> will automatically do so when value is updated
  }

  void removeSong(Song song) async {
    await reqSongController.removeSongFromFb(song);
  }

  @override
  Widget build(BuildContext context) {
    if (!reqSongListReady) {
      return Container(child: CircularProgressIndicator());
    }

    // i don't like this solution as it makes the view directly talk
    // to the model (FB); is there a better way to do this?
    return StreamBuilder<DocumentSnapshot>(
        stream: reqSongController.getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          reqSongController.updateSongList(snapshot);

          List<Song> songList = reqSongController.getSongs();
          if (songList.isEmpty) {
            return Text('No songs added to queue.');
          }
          return SongTile(
            songList,
            this.updateVote,
            false, // not search screen
            widget.isOwner, // playlist owner
            removeSong,
          );
        });
  }
}
