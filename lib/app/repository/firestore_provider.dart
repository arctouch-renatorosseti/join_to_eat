import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  void saveUserCollection(Map<String, dynamic> data, String id) {
    _firestore.collection("users").document(id).setData({'user': data, 'merge': true});
  }

  Future<QuerySnapshot> isEmailRegistered(String email) async {
    return _firestore.collection("users").where('user.email', isEqualTo: email).getDocuments();
  }
}
