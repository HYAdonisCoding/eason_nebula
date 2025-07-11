import 'package:eason_nebula/services/car_data_service.dart';
import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class CarDataTablePage extends EasonBasePage {
  const CarDataTablePage({Key? key}) : super(key: key);

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
  List<String> keyParams = [];
  List<String> carNames = [];
  List<List<String>> carsData = [];
  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final result = await CarDataService.loadCarData();
    final titlesData = result['titlelist'] as List<dynamic>;
    final carValuesData = result['datalist'] as List<dynamic>;

    final keyParams = await CarDataService.extractKeyParams(titlesData);
    final carNames = CarDataService.extractCarNames(carValuesData);
    final carsData = CarDataService.buildCarsData(keyParams, carValuesData);

    setState(() {
      titles = titlesData;
      _carValues = carValuesData;
      this.keyParams = keyParams;
      this.carNames = carNames;
      this.carsData = carsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (titles.isEmpty || _carValues.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

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
