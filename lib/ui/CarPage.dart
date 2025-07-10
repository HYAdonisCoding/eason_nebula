import 'dart:convert';
import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CarPage extends EasonBasePage {
  const CarPage({Key? key}) : super(key: key);

  @override
  String get title => '车辆数据';

  @override
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Builds the content for the CarPage.
  ///
  /// This method returns a [_CarPageBody] widget, which is responsible for
  /// displaying the main content of the CarPage.
  ///
  /// The [context] parameter provides information about the location in the
  /// widget tree in which this widget is being built.
  /*******  1f04a993-d97e-4ff3-bdc6-ca6984211e19  *******/
  Widget buildContent(BuildContext context) {
    return _CarPageBody();
  }
}

class _CarPageBody extends StatefulWidget {
  @override
  State<_CarPageBody> createState() => _CarPageBodyState();
}

class _CarPageBodyState extends State<_CarPageBody> {
  List<dynamic> titles = [];
  List<dynamic> _carValues = [];

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final jsonString = await rootBundle.loadString('lib/assets/data/cars.json');
    final data = json.decode(jsonString);
    setState(() {
      titles = data['result']['titlelist'] as List<dynamic>;
      _carValues = data['result']['datalist'] as List<dynamic>;
      debugPrint('Loaded ${_carValues.length} groups');
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (titles.isEmpty || _carValues.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // 1. 提取所有参数名 key_params
    final keyParams = <String>[];
    for (var group in titles) {
      final items = group['items'] as List<dynamic>? ?? [];
      for (var item in items) {
        keyParams.add(item['itemname'] as String);
      }
    }

    // 2. 提取所有车型名称 (对应 Python spec_name)
    final carNames = _carValues.map((car) {
      final paramList = car['paramconflist'] as List<dynamic>? ?? [];
      final nameItem = paramList.firstWhere(
        (e) => e['titleid']?.toString() == '1',
        orElse: () => {},
      );
      return (nameItem is Map && nameItem['value'] != null)
          ? nameItem['value']
          : '车型';
    }).toList();

    // 3. 生成二维数据 carsData
    final carsData = <List<String>>[];
    for (var i = 0; i < keyParams.length; i++) {
      final paramValues = <String>[];
      for (var car in _carValues) {
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
    print(carNames);
    print(carsData);
    // 4. 渲染表格
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: (carNames.length + 1) * 120,
        child: ListView.builder(
          itemCount: keyParams.length + 1,
          itemBuilder: (context, rowIndex) {
            if (rowIndex == 0) {
              // 表头
              return Table(
                border: TableBorder.all(color: Colors.grey),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {0: FixedColumnWidth(120)},
                children: [
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey.shade200,
                        child: const Text(
                          '参数项',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (var carName in carNames)
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.grey.shade200,
                          child: Text(
                            carName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            } else {
              final paramName = keyParams[rowIndex - 1];
              return Table(
                border: TableBorder.all(color: Colors.grey),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {0: FixedColumnWidth(120)},
                children: [
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(paramName),
                      ),
                      for (
                        var carIndex = 0;
                        carIndex < carNames.length;
                        carIndex++
                      )
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(carsData[rowIndex - 1][carIndex]),
                        ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // _buildHeaderRow 和 _buildGroupedRows 方法已弃用，不再使用 Table 渲染
}
