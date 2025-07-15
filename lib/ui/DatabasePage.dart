import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/utils/EasonDBHelper.dart';
import 'package:flutter/material.dart';

class DatabasePage extends EasonBasePage {
  const DatabasePage({Key? key}) : super(key: key);

  @override
  String get title => 'DatabasePage';

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends BasePageState<DatabasePage> {
  @override
  Widget buildContent(BuildContext context) {
    final Map<String, VoidCallback> operations = {
      '打开/创建数据库': () {
        debugPrint('执行打开/创建数据库');
        EasonDBHelper.init(
          dbName: 'test.db',
          tableName: 'student',
          createTableSQL: '''
        CREATE TABLE student (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          height REAL,
          age INTEGER
        );
        ''',
        );
      },
      '创建表': () {
        debugPrint('执行创建表');
      },
      '插入数据': () {
        debugPrint('执行插入数据');
        EasonDBHelper.insert({'name': 'Eason', 'height': 1.88, 'age': 20});
      },
      '查询数据': () async {
        debugPrint('执行查询数据');
        final rows = await EasonDBHelper.queryAll();
        debugPrint('查询结果: $rows');
      },
      '更新数据': () {
        debugPrint('执行更新数据');
        EasonDBHelper.update(1, {'name': 'Eason', 'height': 1.88, 'age': 20});
      },
      '删除数据': () {
        debugPrint('执行删除数据');
        EasonDBHelper.delete(1);
      },
      '关闭数据库': () {
        debugPrint('执行关闭数据库');
        EasonDBHelper.close();
      },
    };
    final titles = operations.keys.toList();
    return ListView.separated(
      padding: const EdgeInsets.all(12.0),
      itemCount: titles.length,
      separatorBuilder: (context, index) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final title = titles[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: Icon(
              Icons.dataset_linked_outlined,
              color: const Color.fromARGB(255, 34, 56, 94),
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: operations[title],
          ),
        );
      },
    );
  }
}
