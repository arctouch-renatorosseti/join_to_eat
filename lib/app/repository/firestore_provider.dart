import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  void saveMeetingCollection(Map<String, dynamic> data) {
    _firestore.collection("meetings").document().setData({'meeting': data, 'merge': true});
  }

  void updateMeetingCollection(Map<String, dynamic> data, String id) {
    _firestore.collection("meetings").document(id).updateData({'meeting': data, 'merge': true});
  }

  Future<List<DocumentSnapshot>> getAvailableMeetings() async {
    return (await _firestore
            .collection("meetings")
            .getDocuments())
        .documents;
  }

  void saveUserCollection(Map<String, dynamic> data, String id) {
    _firestore.collection("users").document(id).setData({'user': data, 'merge': true});
  }

  Future<DocumentSnapshot> isEmailRegistered(String email) async {
    return (await _firestore.collection("users").where('user.email', isEqualTo: email).getDocuments()).documents.first;
  }
}
