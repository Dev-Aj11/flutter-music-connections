import 'package:flutter/material.dart';

const kSectionHeadingStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
const kPrimaryColor = Color(0xFFFF5722);
const kPrimaryActionBtnStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 22,
);
const kAppBarHeadingStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w800,
  fontSize: 26,
);

const kBorderProperties = OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ));

const kSearchFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  border: kBorderProperties,
  focusedBorder: kBorderProperties,
  enabledBorder: kBorderProperties,
  hintText: "Search for songs",
  suffixIcon: Icon(
    Icons.search,
    color: kPrimaryColor,
  ),
);

var kPlaylistCodeDescStyle = TextStyle(
  color: Colors.grey.shade600,
  fontWeight: FontWeight.w600,
  fontSize: 12,
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

enum BtnStyle {
  primary,
  secondary,
}
