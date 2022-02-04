class Song {
  String artist;
  String songName;
  String albumCover;
  int popularity;

  Song(
      {required this.artist,
      required this.songName,
      required this.albumCover,
      required this.popularity});

  String toString() {
    return "$popularity: $artist, $songName, $albumCover";
  }
}
