import 'package:flutter/material.dart';
import 'package:music_connections/screens/components/app_icons.dart';
import '../constants.dart';

class SocialMedia {
  SocialMediaEnum type;
  late String _url;
  late Icon _icon;
  late String _name;

  String get url => _url;
  String get name => _name;
  Icon get icon => _icon;
  set url(String url) {
    _url = url;
  }

  set name(String name) {
    _name = name;
  }

  set icon(Icon icon) {
    _icon = icon;
  }

  SocialMedia({required this.type}) {
    switch (this.type) {
      case SocialMediaEnum.facebook:
        {
          this.icon = Icon(Icons.facebook);
          this.url =
              'https://www.facebook.com/madroneartbar/'; // pull id from firebase
          this.name = 'Facebook';
          break;
        }
      case SocialMediaEnum.instagram:
        {
          this.icon = Icon(
            AppIcons.instagram,
            color: Colors.orange,
          );
          this.url =
              'https://www.gofundme.com/f/help-madronepops-survive-the-shutdown';
          this.name = 'Instagram';
          break;
        }
      case SocialMediaEnum.spotify:
        {
          this.icon = Icon(
            AppIcons.spotify,
            color: Colors.green,
          );
          this.url = 'https://www.spotify.com';
          this.name = 'Spotify';
          break;
        }
      case SocialMediaEnum.youtube:
        {
          this.icon = Icon(AppIcons.youtube);
          this.url = 'https://www.youtube.com';
          this.name = 'Youtube';
          break;
        }
      case SocialMediaEnum.venmo:
        {
          this.icon = Icon(Icons.attach_money);
          this.url =
              'https://www.gofundme.com/f/help-madronepops-survive-the-shutdown';
          this.name = 'Go Fund Me';
          break;
        }
      default:
        {
          this.icon = Icon(Icons.error);
        }
    }
  }
}
