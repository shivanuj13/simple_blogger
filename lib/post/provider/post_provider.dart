import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog/auth/model/user_model.dart';

// import '../../auth/repo/auth_repo.dart';
import '../../auth/provider/auth_provider.dart';
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
  // final AuthRepo _authRepo = AuthRepo();

  void selectPost(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> createPost(PostModel postModel, BuildContext context) async {
    isUpLoading = true;
    notifyListeners();
    try {
      String token = context.read<AuthProvider>().currentUser?.token ?? "";
      await _postRepo.createPost(postModel, token);
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
    String uId = context.read<AuthProvider>().currentUser!.id;
    String token = context.read<AuthProvider>().currentUser?.token ?? "";
    isLoading = true;
    notifyListeners();
    try {
      postList = await _postRepo.readPost(token);
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

//todo
  Future<void> updatePost(PostModel postModel, String? imgPath,BuildContext context) async {
    isUpLoading = true;
    String token = context.read<AuthProvider>().currentUser?.token ?? '';
    notifyListeners();
    try {
      await _postRepo.updatePost(postModel, imgPath,token);
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
      await _postRepo.likeUnlikePost(postId, token);
      readPost(context);
    } on Exception {
      rethrow;
    }
  }


  Future<void> deletePost(
      String postId, String photoUrl, BuildContext context) async {
    isDeleting = true;
    String token = context.read<AuthProvider>().currentUser?.token ?? "";
    print(postId);
    notifyListeners();
    try {
      await _postRepo.deletePost(postId, photoUrl, token);
      readPost(context);
      isDeleting = false;
      notifyListeners();
    } on Exception {
      isDeleting = false;
      notifyListeners();
      rethrow;
    }
  }
}
