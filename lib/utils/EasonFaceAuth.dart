import 'package:local_auth/local_auth.dart';

class EasonFaceAuth {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// 调用系统面容识别，返回 true 表示验证成功，false 表示失败或取消
  static Future<bool> verifyFace() async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      if (!canCheckBiometrics || !isDeviceSupported) {
        return false;
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: '请进行面容识别以继续',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      print('面容识别异常: $e');
      return false;
    }
  }
}
