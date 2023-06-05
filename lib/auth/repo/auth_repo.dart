import 'dart:io';

import 'package:simple_blog/auth/model/user_model.dart';

class AuthRepo {
  dynamic _fireStore;
  Future<List<UserModel>> fetchUsers() async {
    List<UserModel> userList = [];
    await _fireStore.collection('users').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        userList.add(UserModel.fromMap(doc.data()));
      }
    });
    return userList;
  }

  Future<void> signUp(UserModel userModel, String password) async {
    // try {
    //   dynamic userCredential =
    //       await _auth.createUserWithEmailAndPassword(
    //     email: userModel.email,
    //     password: password,
    //   );
    //   await userCredential.user!.updateDisplayName(userModel.name);
    //   userModel.id = userCredential.user!.uid;
    //   await insertUser(userModel);
    //   return userCredential.user;
    // } on FirebaseAuthException {
    //   rethrow;
    // }
  }

  Future<void> insertUser(UserModel userModel) async {
    // try {
    //   userModel.photoUrl = await uploadImage(userModel.photoUrl);
    //   await _auth.currentUser!.updatePhotoURL(userModel.photoUrl);
    //   await _fireStore.collection('users').add(userModel.toMap());
    // } on FirebaseException {
    //   rethrow;
    // }
  }

  Future<void> updateUser(String name, String? imgPath) async {
    // String photoUrl = _auth.currentUser!.photoURL ?? "";
    try {
      //   if (imgPath != null) {
      //     await deleteImage(photoUrl);
      //     photoUrl = await uploadImage(imgPath);
      //     _auth.currentUser!.updatePhotoURL(photoUrl);
      //   }
      //   _auth.currentUser!.updateDisplayName(name);
      //   DocumentReference documentReference = await _fireStore
      //       .collection('users')
      //       .where('id', isEqualTo: _auth.currentUser!.uid)
      //       .get()
      //       .then((value) => value.docs.first.reference);
      //   await documentReference.update({
      //     'name': name,
      //     'photoUrl': photoUrl,
      //   });
    } on Exception {
      rethrow;
    }
  }

  Future<String> uploadImage(String path) async {
    String fileName = path.split('/').last;
    try {
      // String url = await _storage
      //     .ref()
      //     .child('userImages/$fileName')
      //     .putFile(File(path))
      //     .then((p0) => p0.ref.getDownloadURL());
      return fileName;
    } on Exception {
      rethrow;
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      // await _storage.refFromURL(url).delete();
    } on Exception {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      // UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      // return userCredential.user;
    } on Exception {
      rethrow;
    }
  }

  Future<void> signOut() async {
    // await _auth.signOut();
  }
}
