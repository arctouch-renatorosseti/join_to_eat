import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  static const String _COLLECTION_MEETINGS = "meetings";

  Firestore _firestore = Firestore.instance;

  Future<String> saveMeetingCollection(Map<String, dynamic> data) async {
    var documentRef = await _firestore.collection(_COLLECTION_MEETINGS).add({'meeting': data, 'merge': true});

    return documentRef?.documentID;
  }

  void updateMeetingCollection(Map<String, dynamic> data, String id) {
    _firestore.collection(_COLLECTION_MEETINGS).document(id).updateData({'meeting': data, 'merge': true});
  }

  Stream<QuerySnapshot> getActiveMeetings() {
    return _firestore.collection(_COLLECTION_MEETINGS).where("expiredTime", isGreaterThan: DateTime.now()).snapshots();
  }

  void saveUserCollection(Map<String, dynamic> data, String id) {
    _firestore.collection("users").document(id).setData({'user': data, 'merge': true});
  }

  Future<DocumentSnapshot> isEmailRegistered(String email) async {
    return (await _firestore.collection("users").where('user.email', isEqualTo: email).getDocuments()).documents.first;
  }
}
