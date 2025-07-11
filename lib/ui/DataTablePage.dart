import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class DataTablePage extends EasonBasePage {
  DataTablePage({Key? key}) : super(key: key);

  @override
  String get title => 'DataTable';

  final List<List<String>> data = [
    ['曹伟席', '18', '324'],
    ['陈紫凝', '17', '306'],
    ['董涵宇', '18', '324'],
    ['高伟宸', '18', '324'],
    ['关开', '18', '324'],
    ['侯景桐', '18', '324'],
    ['侯懿轩', '18', '324'],
    ['黄奕萱', '18', '324'],
    ['李佳荷', '18', '324'],
    ['刘梦恬', '18', '324'],
    ['刘梓轩', '18', '324'],
    ['孟维矜', '18', '324'],
    ['潘彦溪', '18', '324'],
    ['平实', '18', '324'],
    ['强雅茗', '18', '324'],
    ['任亦初', '18', '324'],
    ['宋昱佶', '16', '288'],
    ['田信诚', '18', '324'],
    ['王怡然', '18', '324'],
    ['王依依', '16', '288'],
    ['王梓屹', '18', '324'],
    ['王子彧', '18', '324'],
    ['王子瞻', '18', '324'],
    ['徐晨玮', '17', '306'],
    ['许娜嘉', '18', '324'],
    ['严子淳', '7', '126'],
    ['严子淇', '9', '162'],
    ['尹梓钰', '18', '324'],
    ['于沐歆', '18', '324'],
    ['张桉洋', '18', '324'],
    ['张婉玥', '18', '324'],
    ['占正权', '18', '324'],
    ['赵子都', '18', '324'],
    ['郑清瑶', '18', '324'],
  ];

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.blueGrey.shade100),
          columns: const [
            DataColumn(label: Text('姓名')),
            DataColumn(label: Text('用餐天数')),
            DataColumn(label: Text('餐费')),
          ],
          rows: data.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            final bool isOdd = index % 2 == 1;
            return DataRow(
              color: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return isOdd ? Colors.grey.shade50 : Colors.white;
                },
              ),
              cells: row.map((cell) {
                return DataCell(
                  Text(
                    cell,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends BasePageState<DataTablePage> {
  @override
  Widget buildContent(BuildContext context) {
    return widget.buildContent(context);
  }
}
