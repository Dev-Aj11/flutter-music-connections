import 'package:flutter/material.dart';
import 'package:music_connections/constants.dart';
import 'package:flutter/services.dart';
import 'package:music_connections/controllers/app_controller.dart';

class PlayListInfo extends StatefulWidget {
  final String playlistCode;

  PlayListInfo(this.playlistCode);

  @override
  State<PlayListInfo> createState() => _PlayListInfoState();
}

class _PlayListInfoState extends State<PlayListInfo> {
  String playlistName = "";

  @override
  void initState() {
    super.initState();
    _getPlaylistName();
  }

  _getPlaylistName() async {
    var reqSongsController = currPlaylists[widget.playlistCode];
    playlistName = await reqSongsController.getPlaylistName();
    print(playlistName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Playlist Code",
          style: kSectionHeadingStyle,
        ),
        Card(
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  "Invite folks to your playlist:",
                  style: kPlaylistCodeDescStyle,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      " ${this.playlistName} ",
                      style: kPlaylistCodeNameStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                InputChip(
                  onPressed: () {
                    // copy to clipboard
                    Clipboard.setData(ClipboardData(text: widget.playlistCode));
                  },
                  padding: EdgeInsets.all(12),
                  label: Text(
                    "${widget.playlistCode}",
                    style: kPlaylistCodeStyle,
                  ),
                  backgroundColor: Colors.blue,
                ),
                SizedBox(
                  height: 4,
                ),
                Text("Tap to copy", style: kPlaylistCodeDescStyle),
              ],
            ),
          ),
        )
      ],
    );
  }
}
