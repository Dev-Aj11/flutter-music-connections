import 'dart:ffi';

import 'package:flutter/material.dart';

enum Settings { create, join }

class SettingsDialog extends StatelessWidget {
  Future<void> _random(context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Select Option"),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Settings.join);
                },
                child: Text('Join Party Playlist'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Settings.create);
                },
                child: Text("Create Party Playlist"),
              ),
            ],
          );
        })) {
      case Settings.join:
        break;
      case Settings.create:
        break;
      case null:
        // dialog dismissed
        Navigator.pop(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _random(context);
    return Container();
  }
}
