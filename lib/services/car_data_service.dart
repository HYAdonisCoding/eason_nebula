import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CarDataService {
  static Future<Map<String, dynamic>> loadCarData() async {
    final jsonString = await rootBundle.loadString('lib/assets/data/cars.json');
    final data = json.decode(jsonString);
    return data['result'] as Map<String, dynamic>;
  }

  static Future<List<String>> extractKeyParams(List<dynamic> titles) async {
    final keyParams = <String>[];
    for (var group in titles) {
      final items = group['items'] as List<dynamic>? ?? [];
      for (var item in items) {
        keyParams.add(item['itemname'] as String);
      }
    }
    return keyParams;
  }

  static List<String> extractCarNames(List<dynamic> carValues) {
    return carValues.map((car) {
      final paramList = car['paramconflist'] as List<dynamic>? ?? [];
      final nameItem = paramList.firstWhere(
        (e) => e['titleid']?.toString() == '1',
        orElse: () => {},
      );
      return (nameItem is Map && nameItem['value'] != null)
          ? nameItem['value'].toString()
          : '车型';
    }).toList();
  }

  static List<List<String>> buildCarsData(
    List<String> keyParams,
    List<dynamic> carValues,
  ) {
    final carsData = <List<String>>[];
    for (var i = 0; i < keyParams.length; i++) {
      final paramValues = <String>[];
      for (var car in carValues) {
        final paramList = car['paramconflist'] as List<dynamic>? ?? [];
        if (i < paramList.length) {
          final item = paramList[i];
          if (item is Map && item['itemname'] != null) {
            paramValues.add(item['itemname'].toString());
          } else {
            paramValues.add('-');
          }
        } else {
          paramValues.add('-');
        }
      }
      carsData.add(paramValues);
    }
    return carsData;
  }
}
