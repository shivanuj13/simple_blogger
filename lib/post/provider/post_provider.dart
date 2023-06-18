import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/auth/model/user_model.dart';
import '../../auth/provider/auth_provider.dart';
import '../model/post_model.dart';
import '../repo/post_repo.dart';

class PostProvider extends ChangeNotifier {
  List<PostModel> postList = [];
  List<PostModel> myPostList = [];
  List<PostModel> postBySelectedAuthor = [];
  List<PostModel> postBySubscriptions = [];
  int? selectedIndex;
  bool isLikeUnlike = false;
  bool isLoading = false;
  bool isUpLoading = false;
  bool isDeleting = false;
  final PostRepo _postRepo = PostRepo();

  void selectPost(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> createPost(PostModel postModel, BuildContext context) async {
    isUpLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> secrets = jsonDecode(
          await DefaultAssetBundle.of(context)
              .loadString("assets/secrets.json"));
      String token = context.read<AuthProvider>().currentUser?.token ?? "";
      await _postRepo.createPost(postModel, token, secrets);
      readPost(context);
      isUpLoading = false;
      notifyListeners();
    } on Exception {
      isUpLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> readPost(BuildContext context) async {
    UserModel? currentUser = context.read<AuthProvider>().currentUser;
    if (currentUser == null) {
      await context.read<AuthProvider>().initialAuthHandler();
      currentUser = context.read<AuthProvider>().currentUser;
    }
    String uId = currentUser!.id;
    String token = currentUser.token;
    isLoading = true;
    notifyListeners();
    try {
      postList = await _postRepo.readPost(token);
      getAllPostsFromSubscription(currentUser.subscriptionList);
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

  Future<void> updatePost(
      PostModel postModel, String? imgPath, BuildContext context) async {
    isUpLoading = true;
    String token = context.read<AuthProvider>().currentUser?.token ?? '';
    notifyListeners();
    try {
      Map<String, dynamic> secrets = jsonDecode(
          await DefaultAssetBundle.of(context)
              .loadString("assets/secrets.json"));
      await _postRepo.updatePost(postModel, imgPath, token, secrets);
      readPost(context);
      isUpLoading = false;
      notifyListeners();
    } on Exception {
      isUpLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> likeUnlikePost(BuildContext context) async {
    String postId = postList.elementAt(selectedIndex!).id;
    String token = context.read<AuthProvider>().currentUser?.token ?? '';
    try {
      isLikeUnlike = true;
      notifyListeners();
      await _postRepo.likeUnlikePost(postId, token);
      readPost(context);
      isLikeUnlike = false;
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }

  Future<void> deletePost(String postId, BuildContext context) async {
    isDeleting = true;
    String token = context.read<AuthProvider>().currentUser?.token ?? "";
    notifyListeners();
    try {
      await _postRepo.deletePost(postId, token);
      readPost(context);
      isDeleting = false;
      notifyListeners();
    } on Exception {
      isDeleting = false;
      notifyListeners();
      rethrow;
    }
  }

  void getPostBySelectedAuthor(String authorId) {
    postBySelectedAuthor =
        postList.where((element) => element.createdByUid == authorId).toList();
    notifyListeners();
  }

  void getAllPostsFromSubscription(List<String> subscriptionList) {
    postBySubscriptions = postList
        .where((element) => subscriptionList.contains(element.createdByUid))
        .toList();
    notifyListeners();
  }
}
