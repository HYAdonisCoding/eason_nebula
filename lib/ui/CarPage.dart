import 'package:eason_nebula/services/car_data_service.dart';
import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class CarPage extends EasonBasePage {
  CarPage({super.key});

  @override
  String get title => '车辆数据表';

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends BasePageState<CarPage> {
  List<String> keyParams = [];
  List<String> carNames = [];
  List<List<String>> carsData = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    try {
      final result = await CarDataService.loadCarData();
      final titlesData = result['titlelist'] as List<dynamic>;
      final carValuesData = result['datalist'] as List<dynamic>;

      final keyParams = await CarDataService.extractKeyParams(titlesData);
      final carNames = CarDataService.extractCarNames(carValuesData);
      final carsData = CarDataService.buildCarsData(keyParams, carValuesData);

      setState(() {
        this.keyParams = keyParams;
        this.carNames = carNames;
        this.carsData = carsData;
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    return _CarPageBody(
      keyParams: keyParams,
      carNames: carNames,
      carsData: carsData,
      isLoading: isLoading,
      hasError: hasError,
    );
  }
}

class _CarPageBody extends StatelessWidget {
  final List<String> keyParams;
  final List<String> carNames;
  final List<List<String>> carsData;
  final bool isLoading;
  final bool hasError;

  const _CarPageBody({
    Key? key,
    required this.keyParams,
    required this.carNames,
    required this.carsData,
    required this.isLoading,
    required this.hasError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Center(child: Text('加载数据失败，请重试'));
    }
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final paramColumnWidth = 60.0;
        final rawWidth =
            (totalWidth - paramColumnWidth) /
            (carNames.isNotEmpty ? carNames.length : 1);
        final otherColumnWidth = rawWidth < 100 ? 100.0 : rawWidth.toDouble();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: totalWidth),
              child: DataTable(
                columnSpacing: 12,
                columns: [
                  DataColumn(
                    label: SizedBox(
                      width: paramColumnWidth,
                      child: const Text(
                        '参数项',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  for (var carName in carNames)
                    DataColumn(
                      label: SizedBox(
                        width: otherColumnWidth,
                        child: Text(
                          carName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
                rows: [
                  for (
                    var rowIndex = 0;
                    rowIndex < keyParams.length;
                    rowIndex++
                  )
                    DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: paramColumnWidth,
                            child: Text(keyParams[rowIndex], softWrap: true),
                          ),
                        ),
                        for (
                          var carIndex = 0;
                          carIndex < carNames.length;
                          carIndex++
                        )
                          DataCell(
                            SizedBox(
                              width: otherColumnWidth,
                              child: Text(
                                carsData[rowIndex][carIndex],
                                softWrap: true,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
