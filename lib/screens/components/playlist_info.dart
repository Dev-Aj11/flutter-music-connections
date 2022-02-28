import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import 'package:flutter/services.dart';

class PlayListInfo extends StatefulWidget {
  final String playlistCode;

  PlayListInfo(this.playlistCode);

  @override
  State<PlayListInfo> createState() => _PlayListInfoState();
}

class _PlayListInfoState extends State<PlayListInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Playlist Code",
          style: kSectionHeadingStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputChip(
                onPressed: () {
                  // copy to clipboard
                  Clipboard.setData(ClipboardData(text: widget.playlistCode));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                side:
                    BorderSide(style: BorderStyle.solid, color: kPrimaryColor),
                label: Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.playlistCode}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.copy,
                        size: 20,
                      )
                    ],
                  ),
                ),
                backgroundColor: Colors.white,
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note,
                    size: 18,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text("Tap to copy & share with your party friends",
                      style: kPlaylistCodeDescStyle),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
