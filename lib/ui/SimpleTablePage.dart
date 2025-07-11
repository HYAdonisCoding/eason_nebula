import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/ui/TableHeaderCell.dart';
import 'package:flutter/material.dart';

class SimpleTablePage extends EasonBasePage {
  SimpleTablePage({super.key});

  @override
  String get title => '信息';

  @override
  State<SimpleTablePage> createState() => _SimpleTablePageState();
}

class _SimpleTablePageState extends BasePageState<SimpleTablePage> {
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
    final double space = 10;
    final screenWidth = MediaQuery.of(context).size.width;
    final columnCount = 3;
    final double minColumnWidth = 80;
    final double columnWidth = (screenWidth - space * 2) / columnCount;
    final double fixedColumnWidth = columnWidth < minColumnWidth
        ? minColumnWidth
        : columnWidth;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: screenWidth),
          child: Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            defaultColumnWidth: FixedColumnWidth(fixedColumnWidth),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.blueGrey.shade100),
                children: const [
                  TableHeaderCell(text: '姓名'),
                  TableHeaderCell(text: '用餐天数'),
                  TableHeaderCell(text: '餐费'),
                ],
              ),
              ...data.asMap().entries.map((entry) {
                final index = entry.key;
                final row = entry.value;
                final bool isOdd = index % 2 == 1;

                return TableRow(
                  decoration: BoxDecoration(
                    color: isOdd ? Colors.grey.shade50 : Colors.white,
                  ),
                  children: row.map((cell) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Text(
                        cell,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
