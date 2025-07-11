import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';
import 'package:eason_nebula/services/car_data_service.dart';

class PaginatedDataTablePage extends EasonBasePage {
  const PaginatedDataTablePage({Key? key}) : super(key: key);

  @override
  String get title => 'Paginated';

  @override
  State<PaginatedDataTablePage> createState() =>
      _PaginatedDataTablePagePageState();

  @override
  Widget buildContent(BuildContext context) {
    // This method will be overridden by the State class.
    throw UnimplementedError();
  }
}

class _PaginatedDataTablePagePageState
    extends BasePageState<PaginatedDataTablePage> {
  List<String> keyParams = [];
  List<String> carNames = [];
  List<List<String>> carsData = [];
  List<dynamic> titles = [];
  List<dynamic> _carValues = [];

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
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Builds the content for the PaginatedDataTablePage.
  ///
  /// This method checks if the [titles] or [_carValues] lists are empty, and if so,
  /// displays a loading indicator. Otherwise, it returns a [PaginatedDataTable] widget
  /// with a header labeled '宝马', displaying car parameter names and their values.
  ///
  /// The [PaginatedDataTable] is populated using a [_CarDataTableSource] with
  /// [keyParams], [carNames], and [carsData] to provide data for the table rows.
  ///
  /// The [context] parameter provides information about the location in the widget
  /// tree in which this widget is being built.
  /*******  ebadbf49-a944-4dc3-97fa-88c83caf27ce  *******/
  Widget buildContent(BuildContext context) {
    if (titles.isEmpty || _carValues.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return PaginatedDataTable(
      header: const Text(
        '宝马',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      columns: [
        const DataColumn(label: Text('参数项')),
        for (var carName in carNames) DataColumn(label: Text(carName)),
      ],
      source: _CarDataTableSource(keyParams, carNames, carsData),
      rowsPerPage: 10,
    );
  }
}

class _CarDataTableSource extends DataTableSource {
  final List<String> keyParams;
  final List<String> carNames;
  final List<List<String>> carsData;

  _CarDataTableSource(this.keyParams, this.carNames, this.carsData);

  @override
  DataRow? getRow(int index) {
    if (index >= keyParams.length) return null;
    return DataRow(
      cells: [
        DataCell(Text(keyParams[index])),
        for (var carIndex = 0; carIndex < carNames.length; carIndex++)
          DataCell(Text(carsData[index][carIndex])),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => keyParams.length;

  @override
  int get selectedRowCount => 0;
}
