import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_connections/controllers/feedback_controller.dart';
import '../../constants.dart';

class BandFeedback extends StatefulWidget {
  const BandFeedback({Key? key}) : super(key: key);

  @override
  _BandFeedbackState createState() => _BandFeedbackState();
}

class _BandFeedbackState extends State<BandFeedback> {
  FeedbackController fbFeedbackController = FeedbackController();
  bool fbFeedbackLoaded = false;

  var userReactions = {
    Reactions.like: [0, false],
    Reactions.love: [0, false],
    Reactions.celebrate: [0, false],
    Reactions.dislike: [0, false],
  };

  updateReactions(Reactions reaction) async {
    // example: curr value = [6, false]
    // int represents # of votes; bool represents userVote status
    var currValue = userReactions[reaction];
    int currReactionNum = currValue![0] as int;
    bool currReactionStatus = currValue[1] as bool;

    // if userVoted, reduce num of reactions by 1 else
    // increase num of reactions by 1
    int newReactionNum;
    if (currReactionStatus) {
      newReactionNum = --currReactionNum;
    } else {
      newReactionNum = ++currReactionNum;
    }

    // update user voted status
    bool newReactionStatus = !currReactionStatus;

    // update in local database
    // could ignore this as realtime read will automatically update
    // local db
    userReactions.update(
        reaction, (value) => [newReactionNum, newReactionStatus]);

    // originally written to ensure that user can only react to
    // 1 of the emojis instead of all of them
    /*
    for (Reactions r in userReactions.keys) {
      if (r != reaction) {
        if (userReactions[r]![1] as bool) {
          userReactions.update(r, (currValue) {
            int currReactions = currValue[0] as int;
            return [--currReactions, false];
          });
        }
      }
    }
    */
    await fbFeedbackController.updateFeedbackOnFb(reaction, newReactionNum);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: fbFeedbackController.getStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          Map<Reactions, int> fbReactionValues =
              fbFeedbackController.getReactionsFromFb(snapshot);

          // update local user reactions db
          _updateUserReactions(fbReactionValues);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _constructReactionWidgets(),
          );
        });
  }

  _updateUserReactions(Map<Reactions, int> fbReactions) {
    // update local user reactions db
    for (Reactions fbReaction in fbReactions.keys) {
      bool existingUserStatus = userReactions[fbReaction]![1] as bool;
      int fbReactionNum = fbReactions[fbReaction] as int;
      this
          .userReactions
          .update(fbReaction, (value) => [fbReactionNum, existingUserStatus]);
    }
  }

  _constructReactionWidgets() {
    List<Widget> reactionWidgets = [];
    for (Reactions userReaction in userReactions.keys) {
      reactionWidgets
          .add(ReactionButton(userReaction, userReactions, updateReactions));
    }
    return reactionWidgets;
  }
}

class ReactionButton extends StatelessWidget {
  final Reactions reaction;
  final Map<Reactions, List<Object>> currUserReactions;
  final Function userReacted;

  ReactionButton(this.reaction, this.currUserReactions, this.userReacted);

  @override
  Widget build(BuildContext context) {
    var reactionIcons = getIcons();
    return ElevatedButton.icon(
        onPressed: () => userReacted(this.reaction),
        icon: (currUserReactions[reaction]![1] as bool)
            ? Icon(
                reactionIcons[0],
                color: Colors.blue,
                size: 24,
              )
            : Icon(
                reactionIcons[1],
                color: Colors.blue,
                size: 24,
              ),
        label: (this.reaction == Reactions.dislike)
            ? Text("")
            : Text(
                "${currUserReactions[reaction]![0]}",
                style: TextStyle(color: Colors.blue),
              ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10),
          ),
        ));
  }

  getIcons() {
    switch (this.reaction) {
      case Reactions.like:
        return [Icons.thumb_up, Icons.thumb_up_outlined];
      case Reactions.love:
        return [Icons.favorite, Icons.favorite_border_outlined];
      case Reactions.celebrate:
        return [Icons.celebration, Icons.celebration_outlined];
      case Reactions.dislike:
        return [Icons.thumb_down, Icons.thumb_down_outlined];
    }
  }
}
