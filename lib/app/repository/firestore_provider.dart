import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  void saveUserCollection(Map<String, dynamic> data, String id) {
    _firestore.collection("users").document(id).setData({'users': data, 'merge': true});
  }
}
