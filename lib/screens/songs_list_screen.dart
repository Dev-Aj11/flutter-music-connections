import 'package:flutter/material.dart';

import 'package:music_connections/constants.dart';
import 'package:music_connections/controllers/requested_song_list_controller.dart';
import './components/app_icons.dart';
import 'components/requested_songs_tiles_list.dart';

// Future TODO:
// Add artist information in top row
// Add quick way of giving feedback
class SongsListScreen extends StatelessWidget {
  final ReqSongListController reqSongController;

  SongsListScreen(this.reqSongController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Music Connections",
          style: kAppBarHeadingStyle,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // pull up screen allowing user to add a new song
          Navigator.pushNamed(context, '/request');
        },
        icon: Icon(Icons.music_note_outlined),
        label: Text(
          "Request",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BandInfo(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Requested Songs",
              style: kSectionHeadingStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              // load from Firebase
              child: RequestedSongsTileList(this.reqSongController),
            )
          ],
        ),
      ),
    );
  }
}

class BandInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Band",
          style: kSectionHeadingStyle,
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ExpansionTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://img.particlenews.com/image.php?type=thumbnail_580x000&url=1SaRYZ_0cjJhVQr00'),
                    radius: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // need to move this up
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("The Rock & Rolls"),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "SF's hottest band",
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                  )
                ],
              ),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 1,
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Find us on",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 0,
                        children: [
                          InputChip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              child: Icon(Icons.facebook),
                            ),
                            label: Text("facebook"),
                            onPressed: () {},
                            backgroundColor: Colors.grey.shade100,
                          ),
                          InputChip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              child: Icon(AppIcons.facebook_squared),
                            ),
                            label: Text("IG"),
                          ),
                          InputChip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              child: Icon(Icons.facebook),
                            ),
                            label: Text("Spotify"),
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          Text(
                            "Love what we play? We accept tips on:",
                          ),
                          InputChip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              child: Icon(Icons.facebook),
                            ),
                            label: Text("Venmo"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        BandFeedback(),
      ],
    );
  }
}

class BandFeedback extends StatefulWidget {
  const BandFeedback({Key? key}) : super(key: key);

  @override
  _BandFeedbackState createState() => _BandFeedbackState();
}

class _BandFeedbackState extends State<BandFeedback> {
  var userReactions = {
    Reactions.like: [0, false],
    Reactions.love: [0, false],
    Reactions.celebrate: [0, false],
    Reactions.dislike: [0, false],
  };

  updateReactions(Reactions reaction) {
    var currValue = userReactions[reaction];
    int currReactionNum = currValue![0] as int;
    bool currReactionStatus = currValue[1] as bool;

    int newReactionNum;
    if (currReactionStatus) {
      newReactionNum = --currReactionNum;
    } else {
      newReactionNum = ++currReactionNum;
    }

    bool newReactionStatus = !currReactionStatus;
    userReactions.update(
        reaction, (value) => [newReactionNum, newReactionStatus]);

    for (Reactions r in userReactions.keys) {
      if (r != reaction) {
        if (userReactions[r]![1] as bool) {
          userReactions.update(r, (currValue) {
            int currReactions = currValue[0] as int;
            return [--currReactions, false];
          });
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReactionButton(Reactions.like, userReactions, updateReactions),
        ReactionButton(Reactions.love, userReactions, updateReactions),
        ReactionButton(Reactions.celebrate, userReactions, updateReactions),
        ReactionButton(Reactions.dislike, userReactions, updateReactions),
      ],
    );
  }
}

class ReactionButton extends StatelessWidget {
  final Reactions reaction;
  final Map<Reactions, List<Object>> currUserReactions;
  final Function userReacted;

  ReactionButton(this.reaction, this.currUserReactions, this.userReacted);

  @override
  Widget build(BuildContext context) {
    var reactionIcons = getIcons();
    return ElevatedButton.icon(
        onPressed: () => userReacted(this.reaction),
        icon: (currUserReactions[reaction]![1] as bool)
            ? Icon(
                reactionIcons[0],
                color: Colors.blue,
                size: 24,
              )
            : Icon(
                reactionIcons[1],
                color: Colors.blue,
                size: 24,
              ),
        label: (this.reaction == Reactions.dislike)
            ? Text("")
            : Text(
                "${currUserReactions[reaction]![0]}",
                style: TextStyle(color: Colors.blue),
              ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10),
          ),
        ));
  }

  getIcons() {
    switch (this.reaction) {
      case Reactions.like:
        return [Icons.thumb_up, Icons.thumb_up_outlined];
      case Reactions.love:
        return [Icons.favorite, Icons.favorite_border_outlined];
      case Reactions.celebrate:
        return [Icons.celebration, Icons.celebration_outlined];
      case Reactions.dislike:
        return [Icons.thumb_down, Icons.thumb_down_outlined];
    }
  }
}

enum Reactions {
  like,
  love,
  celebrate,
  dislike,
}
