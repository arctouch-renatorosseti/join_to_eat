import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:join_to_eat/app/model/meeting.dart';
import 'package:join_to_eat/app/model/option_quiz.dart';
import 'package:join_to_eat/app/model/quiz.dart';

class FirestoreProvider {
  static const String COLLECTION_USERS = "users";
  static const String COLLECTION_MEETINGS = "meetings";
  static const String COLLECTION_QUIZ = "quiz";
  static const String COLLECTION_OPTION_QUIZ = "option_quiz";

  Firestore _firestore = Firestore.instance;

  Future<void> insertMeeting(Meeting meeting) async {
    _firestore.collection(COLLECTION_MEETINGS).add({
      "description": meeting.description,
      "idMapPlace": meeting.idMapPlace,
      "users": meeting.users,
      "startTime": meeting.startTime,
      "endTime": meeting.endTime,
    });
  }

  Future<void> insertQuiz(Quiz quiz) async {
    _firestore.collection(COLLECTION_QUIZ).add({"question": quiz.question, "id_options": quiz.answersOptions});
  }

  Future<DocumentReference> insertOptionQuiz(OptionQuiz option) async {
    return _firestore
        .collection(COLLECTION_OPTION_QUIZ)
        .add({"selected_times": option.selectedTimes, "answer": option.answer});
  }

  Future<void> updateMeetingCollection(Meeting meeting) async {
    _firestore
        .collection(COLLECTION_MEETINGS)
        .where("description", isEqualTo: meeting.description)
        .where("idMapPlace", isEqualTo: meeting.idMapPlace)
        .snapshots()
        .listen((onData) =>
            _firestore.collection(COLLECTION_MEETINGS).document(onData.documents.first.documentID).updateData({
              "description": meeting.description,
              "idMapPlace": meeting.idMapPlace,
              "users": meeting.users,
              "startTime": meeting.startTime,
              "endTime": meeting.endTime,
            }));
  }

  Stream<QuerySnapshot> getCurrentMeetings() {
    return _firestore
        .collection(COLLECTION_MEETINGS)
        .where("endTime", isGreaterThanOrEqualTo: Timestamp.now())
        .snapshots();
  }

  void saveUserCollection(Map<String, dynamic> data, String id) {
    _firestore.collection(COLLECTION_USERS).document(id).setData({'user': data, 'merge': true});
  }

  Future<DocumentSnapshot> isEmailRegistered(String email) async {
    return (await _firestore.collection(COLLECTION_USERS).where('user.email', isEqualTo: email).getDocuments())
        .documents
        .first;
  }

  Future<DocumentSnapshot> getUser(String id) {
    return _firestore.collection(COLLECTION_USERS).document(id).get();
  }
}
