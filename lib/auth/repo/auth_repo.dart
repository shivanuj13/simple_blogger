import 'dart:convert';

import 'package:simple_blog/auth/model/user_model.dart';
import 'package:http/http.dart' as http;
import '../../shared/const/url_const.dart';

class AuthRepo {
  String apiPath = "$baseUrl/users";
  Map<String, String> headersList = {
    'Accept': '*/*',
    'User-Agent': 'Simple Blogging Android App',
    'Content-Type': 'application/json'
  };
  // Future<List<UserModel>> fetchUsers() async {
  //   List<UserModel> userList = [];
  //   await _fireStore.collection('users').get().then((snapshot) {
  //     for (var doc in snapshot.docs) {
  //       userList.add(UserModel.fromMap(doc.data()));
  //     }
  //   });
  //   return userList;
  // }

  Future<UserModel> signUp(UserModel userModel) async {
    try {
      Uri path = Uri.parse("$apiPath/signUp");
      http.Response response = await http.post(
        path,
        headers: headersList,
        body: userModel.toJson(),
      );

      Map<String, dynamic> res = jsonDecode(response.body);

      if (res["status"]) {
        UserModel userModel = UserModel.fromMap(res["data"]["user"]);
        userModel.token = res["data"]["token"];

        print(userModel);
        return userModel;
      } else {
        throw http.ClientException(res["error"]);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<void> updateUser(String name, String? imgPath, String token) async {
    // String photoUrl = _auth.currentUser!.photoURL ?? "";
    try {
      //   if (imgPath != null) {
      //     await deleteImage(photoUrl);
      //     photoUrl = await uploadImage(imgPath);
      //     _auth.currentUser!.updatePhotoURL(photoUrl);
      //   }
      headersList['Authorization'] = "Bearer $token";
      Uri url = Uri.parse("$apiPath/update");
      http.Response response = await http.post(
        url,
        headers: headersList,
        body: jsonEncode({
          "name": name,
        }),
      );
      Map<String, dynamic> res = jsonDecode(response.body);
      if (!res["status"]) {
        throw http.ClientException(res["error"]);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<String> uploadImage(String path) async {
    String fileName = path.split('/').last;
    try {
      // String url = await _storage
      //     .ref()
      //     .child('userImages/$fileName')
      //     .putFile(File(path))
      //     .then((p0) => p0.ref.getDownloadURL());
      return fileName;
    } on Exception {
      rethrow;
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      // await _storage.refFromURL(url).delete();
    } on Exception {
      rethrow;
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    try {
      Uri path = Uri.parse("$apiPath/signIn");
      http.Response response = await http.post(
        path,
        headers: headersList,
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      // check if got the user

      Map<String, dynamic> res = jsonDecode(response.body);
      if (res["status"]) {
        UserModel userModel = UserModel.fromMap(res["data"]["user"]);
        userModel.token = res["data"]["token"];

        return userModel;
      } else {
        throw http.ClientException(res["error"]);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<void> signOut() async {
    // await _auth.signOut();
  }
}
