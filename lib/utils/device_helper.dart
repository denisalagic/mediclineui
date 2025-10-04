import 'dart:io';
import 'package:flutter/foundation.dart';

class DeviceHelpers {
  static bool get isMobileDevice => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  static bool get isDesktopDevice =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
  static bool get isDesktopDeviceOrWeb => kIsWeb || isDesktopDevice;
}