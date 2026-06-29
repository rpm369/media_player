import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> handleDiskAcessPermissions() async {
    if (await Permission.manageExternalStorage.isGranted) return true;

    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }
}
