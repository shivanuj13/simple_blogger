import '../../auth/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../route/route_const.dart';

class SharedPref {
  SharedPref._();
  static final SharedPref instance = SharedPref._();
  String route = RouteConst.signIn;
  late SharedPreferences _preferences;
  Future<void> initialAuthHandler() async {
    // String route;
    _preferences = await SharedPreferences.getInstance();
    UserModel? user = getUser();
    if (user != null) {
      route = RouteConst.home;
    } else {
      route = RouteConst.signIn;
    }
  }

  Future<void> setUser(UserModel userModel) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    await _preferences.setString('user', userModel.toJson());
  }

  UserModel? getUser() {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = _preferences.getString('user');
    if (user != null) {
      return UserModel.fromJson(user);
    }
    return null;
  }

  Future<void> removeUser() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    await _preferences.remove('user');
  }
}
