import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference searchHistoryCollection =
  FirebaseFirestore.instance.collection('SearchHistory');

  Future<void> addSearchHistory(String userId, String searchText) {
    return searchHistoryCollection
        .doc(userId)
        .collection('history')
        .add({'searchText': searchText, 'timestamp': DateTime.now()});
  }

  Stream<QuerySnapshot> getSearchHistory(String userId) {
    return searchHistoryCollection
        .doc(userId)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> deleteSearchHistory(String userId, String searchId) {
    return searchHistoryCollection
        .doc(userId)
        .collection('history')
        .doc(searchId)
        .delete();
  }
}
