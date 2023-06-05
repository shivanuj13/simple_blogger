import '../../auth/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../route/route_const.dart';

class SharedPref {
  SharedPref._();
  static final SharedPref instance = SharedPref._();

  String route = RouteConst.signIn;

  Future<void> initialAuthHandler() async {
    // String route;
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   route = RouteConst.home;
    // } else {
    //   route = RouteConst.signIn;
    // }
    route = RouteConst.signIn;
  }

  Future<void> setUser(UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('user', userModel.toJson());
  }

  Future<UserModel?> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString('user');
    if (user != null) {
      return UserModel.fromJson(user);
    }
    return null;
  }

  Future<void> removeUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('user');
  }
}
