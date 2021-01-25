import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/presentations/custom_confirmation_dialog.dart';
import 'package:esamudaayapp/utilities/stringConstants.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

enum _UPDATE_TYPE { IMMEDIATE, FLEXIBLE, NONE }

/// Generic methods to handle app update availavility.
class AppUpdateService {
  // Defining this class as singleton to manage state variables.
  AppUpdateService._();
  static AppUpdateService _instance = AppUpdateService._();
  factory AppUpdateService() => _instance;

  static bool _isUpdateAvailable;
  static _UPDATE_TYPE _updateType;
  static bool _isSelectedLater;

  static bool get isSelectedLater => _isSelectedLater;

  static Future<void> checkAppUpdateAvailability() async {
    try {
      // TODO : IOS platform implementation.
      if (Platform.isIOS) {
        throw Exception("ios implementation not found");
      }
      // InAppUpdate works for Android platform only.
      final AppUpdateInfo appUpdateInfo = await InAppUpdate.checkForUpdate();

      debugPrint("appUpdateInfo => $appUpdateInfo");

      _isUpdateAvailable = appUpdateInfo?.updateAvailable ?? false;

      _updateType = (appUpdateInfo?.immediateUpdateAllowed ?? false)
          ? _UPDATE_TYPE.IMMEDIATE
          : (appUpdateInfo?.flexibleUpdateAllowed ?? false)
              ? _UPDATE_TYPE.FLEXIBLE
              : _UPDATE_TYPE.NONE;

      _isSelectedLater = false;
    } catch (e) {
      _isUpdateAvailable = false;
      _updateType = _UPDATE_TYPE.NONE;
      _isSelectedLater = false;
    }
  }

  static Future<void> showUpdateDialog(BuildContext context) async {
    // show app update dialog only if update is available and update priority is atleast flexible.
    if (_isUpdateAvailable && (_updateType != _UPDATE_TYPE.NONE)) {
      await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => Future.value(false),
            child: CustomConfirmationDialog(
              message: tr('app_update.popup_msg'),
              showAppLogo: true,
              title: tr('app_update.title'),
              positiveButtonText: tr('app_update.update'),
              // if update type is immediate then don't show 'Later' option.
              negativeButtonText: _updateType == _UPDATE_TYPE.IMMEDIATE
                  ? null
                  : tr('app_update.later'),
              positiveAction: updateApp,
              negativeAction: () {
                _isSelectedLater = true;
                Navigator.of(context).pop();
              },
            ),
          );
        },
      );
    }
  }

  static Future<void> updateApp() async {
    // TODO : IOS platform implementation.

    const PLAY_STORE_URL =
        'https://play.google.com/store/apps/details?id=${StringConstants.packageName}';
    if (await canLaunch(PLAY_STORE_URL)) {
      await launch(PLAY_STORE_URL);
    } else {
      throw 'Could not launch $PLAY_STORE_URL';
    }
  }
}
