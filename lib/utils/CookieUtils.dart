import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CookieUtils {
  static Future<String> loadAndGetCookie() async {
    final prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString('rednote_cookie');
    if (cookie != null) {
      return cookie;
    }

    // 读取本地 JSON 文件，内容是 List<Map>
    final jsonStr = await rootBundle.loadString(
      'lib/assets/data/XHSBot_cookies.json',
    );
    final List<dynamic> jsonList = json.decode(jsonStr);

    // 将 List 中每个 cookie 转成 name=value，拼接成字符串
    cookie = jsonList
        .map((item) {
          final Map<String, dynamic> c = item;
          return '${c["name"]}=${c["value"]}';
        })
        .join('; ');

    // 缓存到 SharedPreferences
    await prefs.setString('rednote_cookie', cookie);

    return cookie;
  }

  static Future<void> setCookie(String cookie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rednote_cookie', cookie);
  }
}
