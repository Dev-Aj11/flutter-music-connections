import 'package:flutter/material.dart';

import 'package:music_connections/constants.dart';
import 'package:music_connections/controllers/requested_song_list_controller.dart';

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
          style: kSectionHeadingStyle,
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
  const BandInfo({Key? key}) : super(key: key);

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
                  Text("The Rock & Rolls"),
                ],
              ),
              children: [
                Text("yolo"),
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
  int like = 0;
  int dislike = 0;
  var userVoted = [false, false];

  updateLikes() {
    setState(() {
      if (userVoted[0]) {
        --like;
        userVoted[0] = false;
      } else {
        ++like;
        userVoted[0] = true;
      }
      if (userVoted[1]) {
        userVoted[1] = false;
      }
    });
  }

  updateDislikes() {
    setState(() {
      if (userVoted[1]) {
        --dislike;
        userVoted[1] = false;
      } else {
        ++dislike;
        userVoted[1] = true;
      }
      if (userVoted[0]) {
        userVoted[0] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            updateLikes();
          },
          icon: userVoted[0]
              ? Icon(Icons.thumb_up)
              : Icon(Icons.thumb_up_outlined),
          label: Text("$like"),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton.icon(
          onPressed: () {
            updateDislikes();
          },
          icon: userVoted[1]
              ? Icon(Icons.thumb_down)
              : Icon(Icons.thumb_down_outlined),
          label: Text("$dislike"),
        ),
      ],
    );
  }
}
