import 'package:flutter/material.dart';
import 'package:simple_blog/auth/ui/screens/sign_in_screen.dart';
import 'package:simple_blog/auth/ui/screens/sign_up_screen.dart';
import 'package:simple_blog/post/ui/screens/home_screen.dart';
import 'package:simple_blog/post/ui/screens/my_posts_screen.dart';
import 'package:simple_blog/post/ui/screens/post_editor_screen.dart';
import 'package:simple_blog/post/ui/screens/post_screen.dart';
import 'package:simple_blog/post/util/post_list_type.dart';
import 'package:simple_blog/profile/ui/screen/author_profile_screen.dart';
import 'package:simple_blog/profile/ui/screen/my_profile_screen.dart';
import 'package:simple_blog/shared/route/route_const.dart';

import '../../post/model/post_model.dart';
import '../../profile/ui/screen/about_screen.dart';
import '../../profile/ui/screen/edit_profile_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConst.signIn:
        return _buildRoute(settings, const SignInScreen());
      case RouteConst.signUp:
        return _buildRoute(settings, const SignUpScreen());
      case RouteConst.home:
        return _buildRoute(settings, const HomeScreen());
      case RouteConst.post:
        return _buildRoute(
            settings,
            PostScreen(
              postListType: settings.arguments as PostListType,
            ));
      case RouteConst.myPosts:
        return _buildRoute(settings, const MyPostsScreen());
      case RouteConst.postEditor:
        return _buildRoute(
            settings,
            PostEditorScreen(
              postModel: settings.arguments as PostModel?,
            ));
      case RouteConst.myProfile:
        return _buildRoute(settings, const MyProfileScreen());
      case RouteConst.editProfile:
        return _buildRoute(settings, const EditProfileScreen());
      case RouteConst.authorProfile:
        return _buildRoute(settings, const AuthorProfileScreen());
      case RouteConst.about:
        return _buildRoute(settings, const AboutScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
    }
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => builder,
    );
  }
}
