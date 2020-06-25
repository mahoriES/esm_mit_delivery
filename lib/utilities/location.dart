import 'package:location_permissions/location_permissions.dart';

void goToSettings() async {
  bool isOpened = await LocationPermissions().openAppSettings();
}
