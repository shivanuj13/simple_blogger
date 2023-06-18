import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

import 'package:simple_blog/post/model/post_model.dart';

import '../../shared/const/url_const.dart';

class PostRepo {
  String apiPath = "$baseUrl/posts";
  Map<String, String> headersList = {
    'Accept': '*/*',
    'User-Agent': 'Simple Blogging Android App',
    'Content-Type': 'application/json',
    'Authorization': '',
  };

  Future<void> createPost(
      PostModel postModel, String token, Map<String, dynamic> secrets) async {
    try {
      postModel.photoUrl = await uploadImage(postModel.photoUrl, secrets);
      headersList['Authorization'] = "Bearer $token";
      Uri url = Uri.parse("$apiPath/create");
      http.Response response = await http.post(
        url,
        headers: headersList,
        body: postModel.toJson(),
      );
      Map<String, dynamic> res = jsonDecode(response.body);
      if (!res["status"]) {
        throw http.ClientException(res["error"]);
      }
      // print(response.body);
    } on Exception {
      rethrow;
    }
  }

  Future<List<PostModel>> readPost(String token) async {
    List<PostModel> postList = [];
    try {
      headersList['Authorization'] = "Bearer $token";
      Uri url = Uri.parse("$apiPath/fetch");
      http.Response response = await http.get(
        url,
        headers: headersList,
      );

      Map<String, dynamic> res = jsonDecode(response.body);
      if (res["status"]) {
        List<dynamic> posts = res["data"]["posts"];
        for (var element in posts) {
          // log(PostModel.fromMap(element).toString());
          postList.add(PostModel.fromMap(element));
        }

        return postList.reversed.toList();
      } else {
        throw http.ClientException(res["error"]);
      }
    } on Exception {
      rethrow;
    }
  }

  Future<void> updatePost(PostModel postModel, String? imgPath, String token,
      Map<String, dynamic> secrets) async {
    try {
      if (imgPath != null) {
        // deleteImage(postModel.photoUrl);
        postModel.photoUrl = await uploadImage(imgPath, secrets);
      }
      headersList['Authorization'] = "Bearer $token";
      Uri url = Uri.parse("$apiPath/update");
      await http.post(
        url,
        headers: headersList,
        body: postModel.toJson(),
      );
    } on Exception {
      rethrow;
    }
  }

  Future<void> likeUnlikePost(String postId, String token) async {
    try {
      headersList['Authorization'] = "Bearer $token";
      Uri url = Uri.parse("$apiPath/likeUnlike");
      http.Response response = await http.post(
        url,
        headers: headersList,
        body: jsonEncode({
          "id": postId,
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

  Future<void> deletePost(String postId, String token) async {
    try {
      // await deleteImage(photoUrl);
      headersList['Authorization'] = "Bearer $token";
      Uri url = Uri.parse("$apiPath/delete");
      http.Response response = await http.delete(url,
          headers: headersList, body: jsonEncode({"id": postId}));
      // print(response.body);
      Map<String, dynamic> res = jsonDecode(response.body);
      if (!res["status"]) {
        throw http.ClientException(res["error"]);
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

  Future<void> deleteImage(String path) async {
    try {
      // await _storage.refFromURL(path).delete();
    } on Exception {
      rethrow;
    }
  }
}
