class Song {
  String artist;
  String songName;
  String albumCover;
  int popularity;
  int voteCount;

  Song(
      {required this.artist,
      required this.songName,
      required this.albumCover,
      required this.popularity,
      required this.voteCount});

  String toString() {
    return "$popularity: $artist, $songName, $albumCover";
  }

  void incrementVoteCount() {
    this.voteCount++;
  }
}
