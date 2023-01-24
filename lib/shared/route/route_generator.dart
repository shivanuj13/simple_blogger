import 'package:flutter/material.dart';
import 'package:simple_blog/auth/ui/screens/sign_in_screen.dart';
import 'package:simple_blog/auth/ui/screens/sign_up_screen.dart';
import 'package:simple_blog/post/ui/screens/home_screen.dart';
import 'package:simple_blog/post/ui/screens/my_posts_screen.dart';
import 'package:simple_blog/post/ui/screens/post_editor_screen.dart';
import 'package:simple_blog/post/ui/screens/post_screen.dart';
import 'package:simple_blog/profile/my_profile_screen.dart';
import 'package:simple_blog/shared/route/route_const.dart';

import '../../profile/edit_profile_screen.dart';

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
        return _buildRoute(settings, PostScreen());
      case RouteConst.myPosts:
        return _buildRoute(settings, const MyPostsScreen());
      case RouteConst.postEditor:
        return _buildRoute(settings, const PostEditorScreen());
      case RouteConst.myProfile:
        return _buildRoute(settings, const MyProfileScreen());
      case RouteConst.editProfile:
        return _buildRoute(settings, const EditProfileScreen());
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
