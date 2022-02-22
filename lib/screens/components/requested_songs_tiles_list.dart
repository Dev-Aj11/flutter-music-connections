import 'package:flutter/material.dart';
import 'package:music_connections/controllers/copy_req_song_controller.dart';
import 'package:music_connections/screens/components/song_tile.dart';
import '../../models/song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestedSongsTileList extends StatefulWidget {
  final CopyReqSongController reqSongsController;
  RequestedSongsTileList(this.reqSongsController);

  @override
  _SongTilesState createState() => _SongTilesState();
}

class _SongTilesState extends State<RequestedSongsTileList> {
  void updateVote(Song song, bool userVoted) async {
    // show progress indicator?
    await widget.reqSongsController.updateVoteCount(song, userVoted);
    // don't need to call setState here since
    // StreamBuilder<> will automatically do so when value is updated
  }

  @override
  Widget build(BuildContext context) {
    // i don't like this solution as it makes the view directly talk
    // to the model (FB); is there a better way to do this?
    return StreamBuilder<DocumentSnapshot>(
        stream: widget.reqSongsController.getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          widget.reqSongsController.updateSongList(snapshot);

          List<Song> songList = widget.reqSongsController.getSongs();
          print(songList);
          return SongTile(songList, null, this.updateVote);
        });
  }
}
