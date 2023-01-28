import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:simple_blog/auth/model/user_model.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<User?> signUp(UserModel userModel, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(userModel.name);
      userModel.uid = userCredential.user!.uid;
      await insertUser(userModel);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<void> insertUser(UserModel userModel) async {
    try {
      userModel.photoUrl = await uploadImage(userModel.photoUrl);
      await _fireStore.collection('users').add({
        'uid': userModel.uid,
        'name': userModel.name,
        'email': userModel.email,
        'photoUrl': userModel.photoUrl,
        'joinedAt': userModel.joinedAt,
      });
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Future<String> uploadImage(String path) async {
    String fileName = path.split('/').last;
    try {
      String url = await _storage
          .ref()
          .child('userImages/$fileName')
          .putFile(File(path))
          .then((p0) => p0.ref.getDownloadURL());
      return url;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
