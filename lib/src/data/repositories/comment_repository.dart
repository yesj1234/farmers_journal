import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/model/comment.dart';

import '../../domain/interface/comment_interface.dart';

class FireStoreCommentRepository extends CommentRepository {
  final FirebaseFirestore instance;

  FireStoreCommentRepository({required this.instance});

  @override
  Future<List<Comment>> getComments(String journalId) async {
    try {
      final snapshot = await instance
          .collection('journals')
          .doc(journalId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => Comment.fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint('Firebase error while fetching comments: ${e.message}');
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unknown error while fetching comments: $e');
      }
      return [];
    }
  }

  @override
  Future<void> addComment(String journalId, Comment comment) async {
    try {
      final docRef = instance
          .collection('journals')
          .doc(journalId)
          .collection('comments')
          .doc();

      await docRef.set(comment.copyWith(id: docRef.id).toJson());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint('Firebase error while adding comment: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unknown error while adding comment: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteComment({
    required String journalId,
    required String commentId,
  }) async {
    try {
      await instance
          .collection('journals')
          .doc(journalId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint('Firebase error while deleting comment: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unknown error while deleting comment: $e');
      }
      rethrow;
    }
  }
}
