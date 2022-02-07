class Song {
  String artist;
  String songName;
  String albumCover;
  int popularity;
  int voteCount;
  bool _userVoted = false;

  Song(
      {required this.artist,
      required this.songName,
      required this.albumCover,
      required this.popularity,
      required this.voteCount});

  String toString() {
    return "$popularity: $artist, $songName, $albumCover, $voteCount";
  }

  void incrementVoteCount() {
    _userVoted = true;
    this.voteCount++;
  }

  void decrementVoteCount() {
    _userVoted = false;
    this.voteCount--;
  }

  bool didUserVote() {
    // does this send a copy of the vote or the pointer to the original value?
    return _userVoted;
  }
}
