
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/database_model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _tweet;

  Stream<QuerySnapshot> get allTweets => _firestore
      .collection("Tweet")
      .orderBy('tweetDate', descending: true) //? PUT THE ORDERBY QUERY HERE
      .snapshots();

  Future<bool> addNewTweet(Tweet tweet) async {
    _tweet = _firestore.collection('Tweet');

    try {
      _tweet.add({
        "tweet": tweet.tweetText,
        "tweetDate": FieldValue.serverTimestamp()
      });

      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> removeTweet(String tweetId) async {
    _tweet = _firestore.collection('Tweet');
    try {
      await _tweet.doc(tweetId).delete();
      return true;
    } catch (e) {

      return Future.error(e); // return error
    }
  }

  Future<bool> editTweet(String tweet, String id) async {
    _tweet = _firestore.collection('Tweet');
    try {
      await _tweet
          .doc(id)
          .update({'tweet': tweet, 'tweetDate': FieldValue.serverTimestamp()});
      return true;
    } catch (e) {

      return Future.error(e); //return error
    }
  }
}

final databaseProvider = Provider((ref) => Database());
