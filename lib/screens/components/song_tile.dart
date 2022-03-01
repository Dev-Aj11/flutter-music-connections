import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import '../../models/song.dart';

class SongTile extends StatelessWidget {
  final List<Song> songList;

  // function could be
  // to add song to firebase (search screen)
  // or to update vote (playlist viewer screen)
  final Function onTap;
  final bool isSearchScreen;

  final bool? isOwner;
  final Function? removeSong;

  // add song & update vote functions are optional (depending on screen)
  SongTile(this.songList, this.onTap, this.isSearchScreen,
      [this.isOwner, this.removeSong]);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: songList.length,
      separatorBuilder: (context, int) => SizedBox(height: 10),
      itemBuilder: (context, index) {
        Song song = songList[index];
        // More details on why we used Stack here
        // https://stackoverflow.com/questions/51508438/flutter-inkwell-does-not-work-with-card
        // A stack will position widgets one on top of the other
        // Card (bottom) & the InkWell widget on top (positioned to fill width / height of card)
        if (isSearchScreen) {
          return Stack(
            children: [
              SongInfo(song, onTap, isSearchScreen),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: () => this.onTap(song)),
                ),
              ),
            ],
          );
        } else {
          if (isOwner != null && isOwner == true) {
            return Stack(
              children: [
                SongInfo(song, onTap, isSearchScreen),
                Positioned.directional(
                  textDirection: TextDirection.ltr,
                  start: -10,
                  top: -10,
                  child: IconButton(
                    iconSize: 20,
                    onPressed: () {
                      this.removeSong!(song);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return SongInfo(song, onTap, isSearchScreen);
          }
        }
      },
    );
  }
}

class SongInfo extends StatelessWidget {
  final Song song;
  final Function onTap;
  final bool isSearchScreen;
  SongInfo(
    this.song,
    this.onTap,
    this.isSearchScreen,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
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
            (isSearchScreen) ? Container() : VoteTextButton(song, this.onTap),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
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
