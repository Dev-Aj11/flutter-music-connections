import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import '../../models/song.dart';

class SongTile extends StatelessWidget {
  final List<Song> songList;
  final Function? addSong;
  final Function? updateVote;

  SongTile(this.songList, [this.addSong, this.updateVote]);

  @override
  Widget build(BuildContext context) {
    bool voteExist = (this.updateVote != null) ? true : false;
    return ListView.separated(
        itemCount: songList.length,
        // itemExtent: 84,
        separatorBuilder: (context, int) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          Song song = songList[index];
          return InkWell(
            onTap: (!voteExist) ? () => this.addSong!(song) : null,
            child: Card(
                elevation: 4,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Image.network(
                        song.albumCover,
                        scale: 0.9,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.songName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              song.artist,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff797979)),
                            ),
                          ],
                        ),
                      ),
                      (voteExist)
                          ? VoteTextButton(song, this.updateVote!)
                          : Container(),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                )

                // child: ListTile(
                //   leading: Image.network(
                //     song.albumCover,
                //     scale: 0.79,
                //   ),
                //   contentPadding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                //   title: Text(song.songName),
                //   subtitle: Text(song.artist),
                //   onTap: (!voteExist) ? () => this.addSong!(song) : null,
                //   trailing:
                //       (voteExist) ? VoteTextButton(song, this.updateVote!) : null,
                // ),
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
              backgroundColor: kPrimaryColor.withOpacity(0.2),
              shadowColor: kPrimaryColor.withOpacity(0.2),
            )
          : null,
      onPressed: () {
        updateVote(song, song.didUserVote());
      },
      icon: Icon(
        Icons.arrow_upward,
        color: kPrimaryColor,
      ),
      label: Text(
        song.voteCount.toString(),
        style: TextStyle(color: kPrimaryColor),
      ),
    );
  }
}
