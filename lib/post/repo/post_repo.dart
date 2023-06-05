

import 'package:simple_blog/post/model/post_model.dart';

class PostRepo {


  Future<void> createPost(PostModel postModel) async {
    try {
      postModel.photoUrl = await uploadImage(postModel.photoUrl);
      // DocumentReference reference =
      //     await _fireStore.collection('posts').add(postModel.toMap());
      // await reference.update({'uid': reference.id});
    } on Exception {
      rethrow;
    }
  }

  Future<List<PostModel>> readPost() async {
    List<PostModel> postList = [];
    try {
      // await _fireStore.collection('posts').get().then((snapshot) {
      //   for (var doc in snapshot.docs) {
      //     postList.add(PostModel.fromMap(doc.data()));
        // }
      // });
      //sort post list by date
      postList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return postList;
    } on Exception {
      rethrow;
    }
  }

  Future<void> updatePost(PostModel postModel, String? imgPath) async {
    try {
      if (imgPath != null) {
        deleteImage(postModel.photoUrl);
        postModel.photoUrl = await uploadImage(imgPath);
      }
      // await _fireStore
      //     .collection('posts')
      //     .doc(postModel.id)
      //     .update(postModel.toMap());
    } on Exception {
      rethrow;
    }
  }

  Future<void> likePost(String postId, String uid) async {
    try {
      // await _fireStore.collection('posts').doc(postId).update({
      //   'likedByUid': FieldValue.arrayUnion([uid])
      // });
    } on Exception {
      rethrow;
    }
  }

  Future<void> unlikePost(String postId, String uid) async {
    try {
      // await _fireStore.collection('posts').doc(postId).update({
      //   'likedByUid': FieldValue.arrayRemove([uid])
      // });
    } on Exception {
      rethrow;
    }
  }

  Future<void> deletePost(String uid, String photoUrl) async {
    try {
      // await deleteImage(photoUrl);
      // await _fireStore.collection('posts').doc(uid).delete();
    } on Exception {
      rethrow;
    }
  }

  Future<String> uploadImage(String path) async {
    String fileName = path.split('/').last;
    try {
      // String url = await _storage
      //     .ref()
      //     .child('postImages/$fileName')
      //     .putFile(File(path))
      //     .then((p0) => p0.ref.getDownloadURL());
      return fileName;
    } on Exception {
      rethrow;
    }
  }

  Future<void> deleteImage(String path) async {
    try {
      // await _storage.refFromURL(path).delete();
    } on Exception {
      rethrow;
    }
  }
}
