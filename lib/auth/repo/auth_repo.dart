import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
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

  Future<UserModel> signUp(
      UserModel userModel, Map<String, dynamic> secrets) async {
    try {
      userModel.photoUrl = await uploadImage(userModel.photoUrl, secrets);
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

        return userModel;
      } else {
        throw http.ClientException(res["error"]);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<UserModel> updateUser(String name, String email, String? imgPath,
      String token, Map<String, dynamic> secrets) async {
    Map<String, String> updatedUser = {
      "name": name,
      "email": email,
    };
    try {
      UserModel userModel;
      if (imgPath != null) {
        String photoUrl = await uploadImage(imgPath, secrets);
        updatedUser["photoUrl"] = photoUrl;
      }
      headersList['Authorization'] = "Bearer $token";
      Uri url = Uri.parse("$apiPath/update");
      http.Response response = await http.post(
        url,
        headers: headersList,
        body: jsonEncode(updatedUser),
      );
      Map<String, dynamic> res = jsonDecode(response.body);
      if (!res["status"]) {
        throw http.ClientException(res["error"]);
      } else {
        userModel = UserModel.fromMap(res["data"]["user"]);
        return userModel;
      }
    } on Exception {
      rethrow;
    }
  }

  Future<String> uploadImage(String path, Map<String, dynamic> secrets) async {
    try {
      CloudinaryPublic cloudinaryPublic = CloudinaryPublic(
        secrets["cloudName"]!,
        secrets["uploadPreset"]!,
        cache: true,
      );

      CloudinaryResponse response = await cloudinaryPublic.uploadFile(
        CloudinaryFile.fromFile(path,
            resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } on Exception {
      rethrow;
    }
  }

  // Future<void> deleteImage(String url) async {
  //   try {
  //     // await _storage.refFromURL(url).delete();
  //   } on Exception {
  //     rethrow;
  //   }
  // }

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

  Future<void> signOut() async {}

  Future<List<UserModel>> getAllUsers(String token) async {
    try {
      List<UserModel> userList = [];
      headersList['Authorization'] = "Bearer $token";
      http.Response response = await http.get(
        Uri.parse("$apiPath/getAllUsers"),
        headers: headersList,
      );
      Map<String, dynamic> res = jsonDecode(response.body);
      if (res["status"]) {
        for (var user in res["data"]["users"]) {
          userList.add(UserModel.fromMap(user));
        }
        return userList;
      } else {
        throw http.ClientException(res["error"]);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<UserModel> updateSubscription(String token, String authorId) async {
    try {
      headersList['Authorization'] = "Bearer $token";
      http.Response response = await http.post(
        Uri.parse("$apiPath/updateSubscriptions"),
        headers: headersList,
        body: jsonEncode({
          "authorId": authorId,
        }),
      );

      Map<String, dynamic> res = jsonDecode(response.body);

      if (!res["status"]) {
        throw http.ClientException(res["error"]);
      }

      UserModel userModel = UserModel.fromMap(res["data"]["user"]);
      return userModel;
    } on Exception {
      rethrow;
    }
  }
}
