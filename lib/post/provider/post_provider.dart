import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/post_model.dart';
import '../repo/post_repo.dart';

class PostProvider extends ChangeNotifier {
  List<PostModel> postList = [];
  List<PostModel> myPostList = [];
  int? selectedIndex;
  bool isLoading = false;
  bool isUpLoading = false;
  bool isDeleting = false;
  final PostRepo _postRepo = PostRepo();

  void selectPost(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> createPost(PostModel postModel) async {
    isUpLoading = true;
    notifyListeners();
    try {
      await _postRepo.createPost(postModel);
      readPost();
      isUpLoading = false;
      notifyListeners();
    } on FirebaseException {
      isUpLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> readPost() async {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    isLoading = true;
    notifyListeners();
    try {
      postList = await _postRepo.readPost();
      isLoading = false;
      myPostList =
          postList.where((element) => element.createdByUid == uId).toList();
      notifyListeners();
    } on FirebaseException {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePost(PostModel postModel, String? imgPath) async {
    isUpLoading = true;
    notifyListeners();
    try {
      await _postRepo.updatePost(postModel, imgPath);
      readPost();
      isUpLoading = false;
      notifyListeners();
    } on FirebaseException {
      isUpLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deletePost(String uid, String photoUrl) async {
    isDeleting = true;
    notifyListeners();
    try {
      await _postRepo.deletePost(uid, photoUrl);
      readPost();
      isDeleting = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      isDeleting = false;
      notifyListeners();
      rethrow;
    }
  }
}
