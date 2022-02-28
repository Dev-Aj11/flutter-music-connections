import 'package:flutter/material.dart';

const kSectionHeadingStyle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.w700);
const kPrimaryColor = Color(0xFFFF5722);
const kPrimaryActionBtnStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 22,
);
const kAppBarHeadingStyle = TextStyle(color: Colors.white);
const kSearchFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
  ),
  hintText: "Search for songs",
  suffixIcon: Icon(Icons.search),
);

var kPlaylistCodeDescStyle = TextStyle(
  color: Colors.grey.shade600,
  fontWeight: FontWeight.w600,
);

const kAppDescriptionStyle = TextStyle(
  fontWeight: FontWeight.w800,
  fontSize: 36,
  color: Colors.black,
);

const kPlaylistCodeNameStyle = TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.w600,
  fontSize: 16,
);

const kPlaylistCodeStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
);
enum Reactions {
  like,
  love,
  celebrate,
  dislike,
}

enum SocialMediaEnum {
  facebook,
  instagram,
  youtube,
  spotify,
  venmo,
}
