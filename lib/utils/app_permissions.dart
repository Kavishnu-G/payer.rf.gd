import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  // Requests READ_SMS permission from the user.
  // Returns true if granted, false otherwise.
  static Future<bool> requestSmsPermission() async {
    var status = await Permission.sms.status;
    if (status.isGranted) {
      return true;
    } else {
      var result = await Permission.sms.request();
      return result.isGranted;
    }
  }
}