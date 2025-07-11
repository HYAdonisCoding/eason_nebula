import 'dart:async';
import 'dart:convert';

import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HotPhonePage extends EasonBasePage {
  const HotPhonePage({Key? key}) : super(key: key);

  @override
  String get title => 'HotPhone';

  @override
  State<HotPhonePage> createState() => _HotPhonePageState();
}

class _HotPhonePageState extends BasePageState<HotPhonePage> {
  List hotPhones = [];
  @override
  void initState() {
    super.initState();
    // 在这里可以加载数据或执行其他初始化操作
    loadPhoneData()
        .then((data) {
          // 处理加载的数据
          debugPrint('加载成功: ${data.length} 条数据');
          setState(() {
            hotPhones = data;
          });
        })
        .catchError((error) {
          debugPrint('加载失败: $error');
          setState(() {
            hotPhones = [];
          });
        });
  }

  /// 异步加载手机数据
  Future<List> loadPhoneData() async {
    try {
      final jsonStr = await rootBundle
          .loadString('lib/assets/data/hotPhone.json')
          .timeout(const Duration(seconds: 10));
      final data = json.decode(jsonStr) as List<dynamic>;
      return data;
    } on TimeoutException catch (_) {
      throw Exception('加载超时，请稍后重试');
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    if (hotPhones.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hotPhones.length,
      itemBuilder: (context, index) {
        return PhoneListItem(phone: hotPhones[index]);
      },
    );
  }
}

class PhoneListItem extends StatelessWidget {
  final Map<String, dynamic> phone;

  const PhoneListItem({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                phone['img'] ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phone['name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '价格：¥${phone['price'] ?? ''}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('评价：${phone['commit'] ?? ''}'),
                  const SizedBox(height: 6),
                  Text('属性：${phone['attribute'] ?? ''}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
