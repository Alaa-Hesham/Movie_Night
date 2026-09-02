import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Future<void> createUserProfile({
    required String name,
    required String username,
    required String phone,
    required String dateOfBirth,
    required String country,
    required String favoriteGenre,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user is logged in');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set({
      'name': name,
      'username': username,
      'email': user.email,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'country': country,
      'favoriteGenre': favoriteGenre,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final document = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!document.exists) {
      return null;
    }

    return document.data();
  }
}
