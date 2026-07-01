import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class PermissionHandler {
  static Future<bool> handleFileManipulationPermission() async {
    if (await Permission.manageExternalStorage.isGranted) return true;

    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }

  static Future<bool> handleDiskAcessPermission() async {
    PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) return false;
    return true;
  }
}
