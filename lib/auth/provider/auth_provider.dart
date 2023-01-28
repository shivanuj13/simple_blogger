import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_blog/auth/model/user_model.dart';
import 'package:simple_blog/auth/repo/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  UserModel? userModel;
  bool isLoading = false;

  Future<void> insertUser(UserModel userModel, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await _authRepo.signUp(userModel, password);
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await _authRepo.signIn(email, password);
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
  }
}
