import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_blog/auth/model/user_model.dart';
import 'package:simple_blog/auth/repo/auth_repo.dart';
import 'package:simple_blog/shared/util/shared_pref.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  UserModel? userModel;
  UserModel? currentUser;
  List<UserModel> userList = [];
  UserModel? selectedAuthor;
  bool isLoading = false;
  bool isUpdatingSubscription = false;

  Future<void> initialAuthHandler() async {
    try {
      currentUser = SharedPref.instance.getUser();
      await getAllUsers();
    } on Exception {
      rethrow;
    }
  }

  Future<void> insertUser(UserModel userModel, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> secrets = jsonDecode(
          await DefaultAssetBundle.of(context)
              .loadString("assets/secrets.json"));
      currentUser = await _authRepo.signUp(userModel, secrets);
      await SharedPref.instance.setUser(currentUser!);
      currentUser = SharedPref.instance.getUser();
      await getAllUsers();
      isLoading = false;
      notifyListeners();
    } on Exception {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      currentUser = await _authRepo.signIn(email, password);
      await SharedPref.instance.setUser(currentUser!);
      currentUser = SharedPref.instance.getUser();
      await getAllUsers();
      isLoading = false;
      notifyListeners();
    } on Exception {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();
    await _authRepo.signOut();
    await SharedPref.instance.removeUser();
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(
      String name, String email, String? imgPath, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      String token = currentUser!.token;
      Map<String, dynamic> secrets = jsonDecode(
          await DefaultAssetBundle.of(context)
              .loadString("assets/secrets.json"));
      currentUser = await _authRepo.updateUser(
        name,
        email,
        imgPath,
        currentUser!.token,
        secrets,
      );
      currentUser!.token = token;
      await SharedPref.instance.setUser(currentUser!);
      currentUser = SharedPref.instance.getUser();
      isLoading = false;
      notifyListeners();
    } on Exception {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> getAllUsers() async {
    userList = await _authRepo.getAllUsers(currentUser!.token);
    // notifyListeners();
  }

  void selectAuthor(String authId) {
    selectedAuthor = userList.firstWhere((element) => element.id == authId);
    notifyListeners();
  }

  Future<void> updateSubscription(String authorId) async {
    try {
      isUpdatingSubscription = true;
      notifyListeners();
      String token = currentUser!.token;
      currentUser = await _authRepo.updateSubscription(token, authorId);
      currentUser!.token = token;
      await SharedPref.instance.setUser(currentUser!);
      currentUser = SharedPref.instance.getUser();
      isUpdatingSubscription = false;
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }
}
