import 'package:flutter/material.dart';
import '../../models/song.dart';

class SongTile extends StatelessWidget {
  final List<Song> songList;
  final Function? addSong;
  final Function? updateVote;

  SongTile(this.songList, [this.addSong, this.updateVote]);

  @override
  Widget build(BuildContext context) {
    bool voteExist = (this.updateVote != null) ? true : false;
    return ListView.builder(
        itemCount: songList.length,
        itemBuilder: (context, index) {
          Song song = songList[index];
          return Card(
            elevation: 4,
            child: ListTile(
              leading: Image.network(song.albumCover),
              title: Text(song.songName),
              subtitle: Text(song.artist),
              onTap: (!voteExist) ? () => this.addSong!(song) : null,
              trailing:
                  (voteExist) ? VoteTextButton(song, this.updateVote!) : null,
            ),
          );
        });
  }
}

class VoteTextButton extends StatelessWidget {
  final Song song;
  final Function updateVote;

  VoteTextButton(this.song, this.updateVote);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: song.didUserVote()
          ? TextButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2))
          : null,
      onPressed: () {
        updateVote(song, song.didUserVote());
      },
      icon: Icon(Icons.arrow_upward),
      label: Text(
        song.voteCount.toString(),
      ),
    );
  }
}
