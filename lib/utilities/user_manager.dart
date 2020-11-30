import 'dart:async';
import 'package:esamudaayapp/models/User.dart';
import 'package:esamudaayapp/repository/database_manage.dart';
import 'package:esamudaayapp/utilities/stringConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static Future<User> userDetails() async {
    var dbClient = await DatabaseManager().db;
    List<Map> maps = await dbClient.rawQuery('SELECT * FROM User');
    if (maps.length > 0) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  static UserManager shared = UserManager();

  Future<bool> isLoggedIn() async => await getToken().then((token) {
        return token != null;
      });

  Future<bool> isAddressEntered() async =>
      await getAddressStatus().then((value) {
        return value != null;
      });

  Future<bool> isSkipPressed() async => await getSkipStatus().then((value) {
        return value != null && value == true;
      });

  // Future<bool> isOrderProgressing() async =>
  //     await getOrderProgressStatus().then((value) {
  //       return value != null && value == true;
  //     });

  static Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dbClient = await DatabaseManager().db;
    await saveSkipStatus(status: false);
    prefs.remove(tokenKey);
    int resp = await dbClient.delete('User');
//    await dbClient.delete(cartTable);
//    await dbClient.delete(merchantTable);
    print(resp);
  }

  static Future<void> deleteCart() async {
    var dbClient = await DatabaseManager().db;
//    await dbClient.delete(cartTable);
  }

  static Future<bool> getSkipStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(skipKey);
    return value;
  }

  static Future<void> saveSkipStatus({status: bool}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(skipKey, status);
  }

  // static Future<bool> getOrderProgressStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool value = prefs.getBool(inProgress);
  //   return value;
  // }

  // static Future<void> saveOrderProgressStatus({status: bool}) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool(inProgress, status);
  // }

  static Future<bool> getAddressStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(addressKey);
    return value;
  }

  static Future<void> saveAddressStatus({status: bool}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(addressKey, status);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(tokenKey);
    print("retrived token : $value");
    return value;
  }

  static Future<void> saveToken({token: String}) async {
    print("saved token : $token");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(fcmToken);
    print("retrived token : $value");
    return value;
  }

  // static Future<void> saveCurrentOrderId({orderId: String}) async {
  //   print("save CurrentOrderId : $orderId");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(orderIdKey, orderId);
  // }

  // static Future<String> getCurrentOrderId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String value = prefs.getString(orderIdKey);
  //   print("retrived CurrentOrderId : $value");
  //   return value;
  // }

  static Future<void> saveFcmToken({token: String}) async {
    print("saved token : $token");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(fcmToken, token);
  }

  static Future<int> saveUser(User user) async {
    var dbClient = await DatabaseManager().db;
    int resp = await dbClient.delete('User');
    int res = await dbClient.insert("User", user.toJson());
    return res;
  }

  Future<int> update() async {
    var dbClient = await DatabaseManager().db;
    dbClient.rawUpdate(
      "User",
    );
  }
}

var userManager = UserManager();
