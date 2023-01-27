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
  final PostRepo _postRepo = PostRepo();

  void selectPost(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> createPost(PostModel postModel) async {
    isUpLoading = true;
    notifyListeners();
    await _postRepo.createPost(postModel);
    isUpLoading = false;
    notifyListeners();
  }

  Future<void> readPost() async {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    isLoading = true;
    notifyListeners();
    postList = await _postRepo.readPost();
    isLoading = false;
    myPostList =
        postList.where((element) => element.createdByUid == uId).toList();
    notifyListeners();
  }

  Future<void> updatePost(PostModel postModel, String? imgPath) async {
    await _postRepo.updatePost(postModel, imgPath);
    notifyListeners();
  }

  Future<void> deletePost(String uid,String photoUrl) async {
    await _postRepo.deletePost(uid,photoUrl);
    notifyListeners();
  }
}
