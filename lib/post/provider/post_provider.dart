import 'package:flutter/material.dart';
import 'package:simple_blog/auth/model/user_model.dart';

import '../../auth/repo/auth_repo.dart';
import '../model/post_model.dart';
import '../repo/post_repo.dart';

class PostProvider extends ChangeNotifier {
  List<PostModel> postList = [];
  List<PostModel> myPostList = [];
  List<UserModel> userList = [];
  int? selectedIndex;
  bool isLoading = false;
  bool isUpLoading = false;
  bool isDeleting = false;
  final PostRepo _postRepo = PostRepo();
  final AuthRepo _authRepo = AuthRepo();

  void selectPost(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  UserModel? getUser(String uid) {
    return userList.firstWhere((element) => element.id == uid, orElse: () {
      return UserModel(
        id: '',
        name: '',
        email: '',
        photoUrl: '',
        createdAt: DateTime.now(),
      );
    });
  }

  Future<void> createPost(PostModel postModel) async {
    isUpLoading = true;
    notifyListeners();
    try {
      await _postRepo.createPost(postModel);
      readPost();
      isUpLoading = false;
      notifyListeners();
    } on Exception {
      isUpLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> readPost() async {
    String uId = "uid";
    isLoading = true;
    notifyListeners();
    try {
      postList = await _postRepo.readPost();
      userList = await _authRepo.fetchUsers();
      isLoading = false;
      myPostList =
          postList.where((element) => element.createdByUid == uId).toList();
      notifyListeners();
    } on Exception {
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
    } on Exception {
      isUpLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> likePost() async {
    String postId = postList.elementAt(selectedIndex!).id;
    String uid = "uid";
    try {
      await _postRepo.likePost(postId, uid);
      readPost();
    } on Exception {
      rethrow;
    }
  }

  Future<void> unlikePost() async {
    String postId = postList.elementAt(selectedIndex!).id;
    String uid = "id";
    try {
      await _postRepo.unlikePost(postId, uid);
      readPost();
    } on Exception {
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
    } on Exception {
      isDeleting = false;
      notifyListeners();
      rethrow;
    }
  }
}
