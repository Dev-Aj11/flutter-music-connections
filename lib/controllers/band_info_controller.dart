import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/band.dart';

class BandInfoController {
  late CollectionReference fbBandInfo;
  late Band bandInfo;

  BandInfoController() {
    fbBandInfo = FirebaseFirestore.instance.collection('band');
    bandInfo = Band.empty();
  }

  Future<void> getBandInfoFromFb() async {
    try {
      await fbBandInfo.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          print("hello");
          bandInfo = Band.fromFirebase(doc);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  getBandInfo() {
    return bandInfo;
  }
}
