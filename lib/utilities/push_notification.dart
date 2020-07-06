import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/main.dart';
import 'package:esamudaayapp/modules/home/actions/home_page_actions.dart';
import 'package:esamudaayapp/utilities/global.dart' as globals;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  showMessage(String msg) {
    showDialog(
        context: navigatorKey.currentState.overlay.context,
        child: AlertDialog(
          title: Text("eSamudaay"),
          content: Text("message['text']"),
          actions: <Widget>[
            FlatButton(
              child: Text(tr('screen_account.cancel')),
              onPressed: () {},
            ),
            FlatButton(
              child: Text("ok"),
              onPressed: () async {},
            )
          ],
        ));
  }

  Future<void> init() async {
    if (!_initialized) {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          showMessage(message['text']);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
      _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        globals.deviceToken = token;
        print(token);
      });

      _initialized = true;
    }
  }

  Future<void> logout() async {
    _firebaseMessaging.deleteInstanceID();
  }
}
