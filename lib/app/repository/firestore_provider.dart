import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:join_to_eat/app/model/meeting.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<void> saveMeetingCollection(Meeting meeting) async {

    _firestore.collection("meetings").document().setData({'meeting': meeting, 'merge': true});
  }

  void updateMeetingCollection(Map<String, dynamic> data, String id) {
    _firestore.collection("meetings").document(id).updateData({'meeting': data, 'merge': true});
  }

  Future<List<DocumentSnapshot>> getAvailableMeetings() async {
    return (await _firestore.collection("meetings").where("meeting.expiredTime", isGreaterThan: Timestamp.now()).getDocuments()).documents;
  }

  void saveUserCollection(Map<String, dynamic> data, String id) {
    _firestore.collection("users").document(id).setData({'user': data, 'merge': true});
  }

  Future<DocumentSnapshot> isEmailRegistered(String email) async {
    return (await _firestore.collection("users").where('user.email', isEqualTo: email).getDocuments()).documents.first;
  }
}
