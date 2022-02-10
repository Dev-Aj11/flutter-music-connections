import 'package:flutter/material.dart';

const kSectionHeadingStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
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