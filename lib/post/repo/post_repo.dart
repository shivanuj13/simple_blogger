import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:simple_blog/post/model/post_model.dart';

class PostRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createPost(PostModel postModel) async {
    postModel.photoUrl = await uploadImage(postModel.photoUrl);
    DocumentReference reference =
        await _fireStore.collection('posts').add(postModel.toMap());
    await reference.update({'uid': reference.id});
  }

  Future<List<PostModel>> readPost() async {
    List<PostModel> postList = [];
    await _fireStore.collection('posts').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        postList.add(PostModel.fromMap(doc.data()));
      }
    });
    return postList;
  }

  Future<void> updatePost(PostModel postModel, String? imgPath) async {
    if (imgPath != null) {
      deleteImage(postModel.photoUrl);
      postModel.photoUrl = await uploadImage(imgPath);
    }
    await _fireStore
        .collection('posts')
        .doc(postModel.uid)
        .update(postModel.toMap());
  }

  Future<void> deletePost(String uid,String photoUrl) async {
    await deleteImage(photoUrl);
    await _fireStore.collection('posts').doc(uid).delete();
  }

  Future<String> uploadImage(String path) async {
    String fileName = path.split('/').last;
    try {
      String url = await _storage
          .ref()
          .child('postImages/$fileName')
          .putFile(File(path))
          .then((p0) => p0.ref.getDownloadURL());
      return url;
    } on FirebaseException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteImage(String path)  async {
    try {
      await _storage.refFromURL(path).delete();
    } on FirebaseException catch (e) {
      print(e);
      rethrow;
    }
  }
}
