import 'package:flutter/material.dart';
import 'package:simple_blog/auth/model/user_model.dart';
import 'package:simple_blog/auth/repo/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  UserModel? userModel;
  UserModel? currentUser;
  bool isLoading = false;

  Future<void> insertUser(UserModel userModel) async {
    isLoading = true;
    notifyListeners();
    try {
      currentUser = await _authRepo.signUp(userModel);
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
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(String name, String? imgPath) async {
    isLoading = true;
    notifyListeners();
    try {
      await _authRepo.updateUser(name, imgPath, currentUser!.token);
      isLoading = false;
      notifyListeners();
    } on Exception {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
