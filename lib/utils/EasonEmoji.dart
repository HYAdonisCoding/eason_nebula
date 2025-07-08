import 'dart:convert';
import 'package:flutter/services.dart';

class EasonEmoji {
  static Future<Map<String, String>> loadEmojiMap() async {
    final jsonStr = await rootBundle.loadString('assets/data/emojis.json');
    final Map<String, dynamic> data = json.decode(jsonStr);
    return data.map((k, v) => MapEntry(k, v.toString()));
  }
}