import 'package:music_connections/constants.dart';
import 'package:music_connections/models/social_media.dart';
import './social_media.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Band {
  late String bandName;
  late String bandDesc;
  late String bandImageUrl;
  late List<SocialMedia> socials;

  Band(this.bandName, this.bandDesc, this.bandImageUrl, this.socials);

  Band.fromFirebase(DocumentSnapshot doc) {
    this.socials = [];
    this.bandName = doc["bandName"];
    this.bandImageUrl = doc["bandImageUrl"];
    this.bandDesc = doc["bandDesc"];
    var socialsObj = doc["socials"];
    for (String socialMediaName in socialsObj.keys) {
      SocialMediaEnum type = _getEnumType(socialMediaName);
      this.socials.add(SocialMedia(type: type));
    }
  }

  Band.empty() {
    this.bandName = "loading";
    this.bandDesc = "loading";
    this.bandImageUrl =
        "https://images.ctfassets.net/bdyhigkzupmv/6lySzcy7qcIN1tf81Qkus/5b5ac73daeaf61f9057c0b0dd8447a31/hero-guitar-outro.jpg";
    this.socials = [];
  }

  _getEnumType(String socialMedia) {
    switch (socialMedia) {
      case "facebook":
        return SocialMediaEnum.facebook;
      case "instagram":
        return SocialMediaEnum.instagram;
      case "venmo":
        return SocialMediaEnum.venmo;
      case "spotify":
        return SocialMediaEnum.spotify;
      case "youtube":
        return SocialMediaEnum.youtube;
    }
  }
}
