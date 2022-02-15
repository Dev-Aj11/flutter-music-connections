import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';

class FeedbackController {
  final Stream<QuerySnapshot> _feedbackStream =
      FirebaseFirestore.instance.collection('feedback').snapshots();
  final CollectionReference fbFeedbackInfo =
      FirebaseFirestore.instance.collection('feedback');
  late Map<Reactions, int> reactions;

  FeedbackController() {
    reactions = {};
  }

// Not called since StreamBuilder Invokes setState()
// when data is loaded
/*
  Future getFeedbackFromFb() async {
    try {
      await fbFeedbackInfo.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          reactions.putIfAbsent(Reactions.like, () => doc["like"]);
          reactions.putIfAbsent(Reactions.love, () => doc["love"]);
          reactions.putIfAbsent(Reactions.celebrate, () => doc["celebrate"]);
          reactions.putIfAbsent(Reactions.dislike, () => doc["dislike"]);
        });
      });
    } catch (e) {
      print(e);
    }
  }
*/

  updateFeedbackOnFb(Reactions reaction, int reactionNum) async {
    await fbFeedbackInfo.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        fbFeedbackInfo
            .doc(doc.id)
            .update({reaction.name.toString(): reactionNum});
      });
    });
  }

  getReactionsFromFb(snapshot) {
    Map<Reactions, int> reactionValues = {};
    var docSnapshots = snapshot.data!.docs;
    for (DocumentSnapshot doc in docSnapshots) {
      Map<String, dynamic> reactionInfo = doc.data()! as Map<String, dynamic>;
      for (String reactionStr in reactionInfo.keys) {
        Reactions type = _getReactionEnum(reactionStr);
        reactionValues.putIfAbsent(type, () => reactionInfo[reactionStr]);
        // reactionWidgets.add(ReactionButton(
        //     Reactions.celebrate, userReactions, updateReactions));
      }
    }
    return reactionValues;
  }

  _getReactionEnum(String reaction) {
    switch (reaction) {
      case "like":
        return Reactions.like;
      case "dislike":
        return Reactions.dislike;
      case "celebrate":
        return Reactions.celebrate;
      case "love":
        return Reactions.love;
    }
  }

  getReactions() {
    return reactions;
  }

  getStream() {
    return _feedbackStream;
  }
}
