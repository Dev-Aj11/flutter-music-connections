import 'package:flutter/material.dart';
import '../models/requested_song_list.dart';
import '../models/song.dart';
import '../components/song_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestedSongsTileList extends StatefulWidget {
  const RequestedSongsTileList({Key? key}) : super(key: key);

  @override
  _SongTilesState createState() => _SongTilesState();
}

class _SongTilesState extends State<RequestedSongsTileList> {
  RequestedSongList reqSongList = RequestedSongList();
  bool reqSongListReady = false;

  @override
  void initState() {
    super.initState();
    _createSongList();
  }

  _createSongList() async {
    // init adds songs from firebase to local copy
    await reqSongList.getSongsFromFb();
    reqSongListReady = true;
    setState(() {});
  }

  void updateVote(Song song, bool userVoted) async {
    // show progress indicator?
    await reqSongList.updateVoteCount(song, userVoted);
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
    return StreamBuilder<QuerySnapshot>(
        stream: reqSongList.getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          reqSongList.updateSongList(snapshot);

          List<Song> songList = reqSongList.getSongs();
          return SongTile(songList, null, this.updateVote);
        });
  }
}
