import 'package:flutter/material.dart';
import 'package:music_connections/controllers/req_song_controller.dart';
import '../../models/song.dart';
import '../components/song_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestedSongsTileList extends StatefulWidget {
  const RequestedSongsTileList({Key? key}) : super(key: key);

  @override
  _SongTilesState createState() => _SongTilesState();
}

class _SongTilesState extends State<RequestedSongsTileList> {
  ReqSongListController reqSongController = ReqSongListController("TESTIN");
  bool reqSongListReady = false;

  @override
  void initState() {
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

  void updateVote(Song song, bool userVoted) async {
    // show progress indicator?
    await reqSongController.updateVoteCount(song, userVoted);
    // don't need to call setState here since
    // StreamBuilder<> will automatically do so when value is updated
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
          return SongTile(songList, null, this.updateVote);
        });
  }
}
