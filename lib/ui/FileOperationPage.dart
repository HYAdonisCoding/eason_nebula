import 'dart:io';

import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileOperationPage extends EasonBasePage {
  const FileOperationPage({Key? key}) : super(key: key);

  @override
  String get title => 'FileOperationPage';

  @override
  State<FileOperationPage> createState() => _FileOperationPageState();
}

class _FileOperationPageState extends BasePageState<FileOperationPage> {
  @override
  Widget buildContent(BuildContext context) {
    final Map<String, VoidCallback> operations = {
      '创建文件夹: Directory(path).create()': () async {
        debugPrint('执行创建文件夹');
        final dir = await getApplicationDocumentsDirectory();
        final dictionary = Directory('${dir.path}/temp1');
        dictionary
            .create()
            .then((_) {
              debugPrint('文件夹创建成功 ${dictionary.path}');
            })
            .catchError((error) {
              debugPrint('创建文件夹失败: $error');
            });
      },
      '通过递归创建文件夹: Directory(path).create(recursive: true)': () async {
        debugPrint('执行递归创建文件夹');
        final dir = await getApplicationDocumentsDirectory();
        Directory('${dir.path}/temp2')
            .create(recursive: true)
            .then((value) {
              debugPrint('递归创建文件夹成功: ${value.path}');
            })
            .catchError((error) {
              debugPrint('递归创建文件夹失败: $error');
            });
      },
      '获取文件夹列表: Directory(path).list()': () async {
        debugPrint('执行获取文件夹列表');
        final dir = await getApplicationDocumentsDirectory();
        dir.list().forEach((entity) {
          if (entity is Directory) {
            debugPrint('文件夹: ${entity.path}');
          } else if (entity is File) {
            debugPrint('文件: ${entity.path}');
          }
        });
      },
      '判断文件夹是否存在: Directory(path).exists()': () async {
        debugPrint('执行判断文件夹是否存在');
        final dir = await getApplicationDocumentsDirectory();
        Directory('${dir.path}/temp3').exists().then((value) {
          debugPrint('文件夹是否存在: $value');
        });
      },
      '文件夹重命名: Directory(path).rename(newPath)': () async {
        debugPrint('执行文件夹重命名');
        final dir = await getApplicationDocumentsDirectory();
        Directory('${dir.path}/temp2').rename('${dir.path}/temp3').then((
          value,
        ) {
          debugPrint('文件夹重命名成功: ${value.path}');
        });
      },
      '判断文件是否存在: File(path).exists()': () async {
        debugPrint('执行判断文件是否存在');
        final dir = await getApplicationDocumentsDirectory();
        File('${dir.path}/tempfile1').exists().then((value) {
          debugPrint('文件是否存在: $value');
        });
      },
      '创建文件: File(path).create()': () async {
        debugPrint('执行创建文件');
        final dir = await getApplicationDocumentsDirectory();
        File('${dir.path}/tempfile1').create().then((value) {
          debugPrint('文件创建成功: ${value.path}');
        });
      },
      '最强大的读取文件方式：Stream: File(path).openRead()': () async {
        debugPrint('执行Stream读取文件');
        final dir = await getApplicationDocumentsDirectory();
        File file = File('${dir.path}/tempfile1');
        file.openRead().listen(
          (List<int> data) {
            debugPrint('读取到数据: ${data.length} bytes');
          },
          onDone: () {
            debugPrint('文件读取完成');
          },
          onError: (error) {
            debugPrint('文件读取失败: $error');
          },
        );
      },
      '向文件写入内容方式1：writeAsString:': () async {
        debugPrint('执行writeAsString写入');
        final dir = await getApplicationDocumentsDirectory();
        File('${dir.path}/tempfile1')
            .writeAsString('Hello, Eason Nebula!')
            .then((_) {
              debugPrint('写入内容成功');
            })
            .catchError((error) {
              debugPrint('写入内容失败: $error');
            });
      },
      '向文件写入内容方式2：writeAsBytes: ': () async {
        debugPrint('执行writeAsBytes写入');
        final dir = await getApplicationDocumentsDirectory();
        File('${dir.path}/tempfile1')
            .writeAsBytes([72, 101, 108, 108, 111])
            .then((_) {
              debugPrint('写入字节内容成功');
            })
            .catchError((error) {
              debugPrint('写入字节内容失败: $error');
            });
      },

      '删除文件夹: Directory(path).delete()': () async {
        debugPrint('执行删除文件夹');
        final dir = await getApplicationDocumentsDirectory();
        Directory('${dir.path}/temp1')
            .delete(recursive: true)
            .then((_) {
              debugPrint('文件夹删除成功');
            })
            .catchError((error) {
              debugPrint('删除文件夹失败: $error');
            });
      },

      '读取文件的长度信息: File(path).length()': () async {
        debugPrint('执行读取文件长度信息');
        final dir = await getApplicationDocumentsDirectory();
        File('${dir.path}/tempfile1')
            .length()
            .then((length) {
              debugPrint('文件长度: $length bytes');
            })
            .catchError((error) {
              debugPrint('读取文件长度失败: $error');
            });
      },
      '获取缓存目录': () async {
        debugPrint('获取缓存目录');
        getTemporaryDirectory()
            .then((tempDir) {
              debugPrint('缓存目录: ${tempDir.path}');
              // 这里可以进行其他操作，比如列出缓存目录下的文件
              tempDir.list().forEach((entity) {
                if (entity is File) {
                  debugPrint('缓存文件: ${entity.path}');
                } else if (entity is Directory) {
                  debugPrint('缓存目录: ${entity.path}');
                }
              });
            })
            .catchError((error) {
              debugPrint('获取缓存目录失败: $error');
            });
      },
      '获取应用程序的文档目录': () async {
        debugPrint('获取应用程序的文档目录');
        getApplicationDocumentsDirectory()
            .then((appDocDir) {
              debugPrint('应用程序文档目录: ${appDocDir.path}');
              // 这里可以进行其他操作，比如列出文档目录下的文件
              appDocDir.list().forEach((entity) {
                if (entity is File) {
                  debugPrint('文档文件: ${entity.path}');
                } else if (entity is Directory) {
                  debugPrint('文档目录: ${entity.path}');
                }
              });
            })
            .catchError((error) {
              debugPrint('获取应用程序文档目录失败: $error');
            });
      },
      '获取外部存储目录': () async {
        debugPrint('获取外部存储目录');
        getExternalStorageDirectory()
            .then((externalDir) {
              debugPrint('外部存储目录: ${externalDir?.path}');
              // 这里可以进行其他操作，比如列出外部存储目录下的文件
              externalDir?.list().forEach((entity) {
                if (entity is File) {
                  debugPrint('外部存储文件: ${entity.path}');
                } else if (entity is Directory) {
                  debugPrint('外部存储目录: ${entity.path}');
                }
              });
            })
            .catchError((error) {
              debugPrint('获取外部存储目录失败: $error');
            });
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
            leading: Icon(Icons.folder, color: Colors.blueAccent),
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
