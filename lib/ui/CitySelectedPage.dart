import 'dart:async';

import 'package:eason_nebula/utils/EasonMessenger.dart';
import 'package:flutter/cupertino.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:eason_nebula/ui/Base/EasonBasePage.dart';

// 城市选择页面，支持省 -> 市 -> 区三级展开展示
class CitySelectedPage extends EasonBasePage {
  const CitySelectedPage({Key? key}) : super(key: key);

  @override
  String get title => '选择';

  @override
  State<CitySelectedPage> createState() => _CitySelectedPageState();
}

class _CitySelectedPageState extends BasePageState<CitySelectedPage> {
  final ScrollController _scrollController = ScrollController();
  String? _expandedProvince;

  // 从本地 assets 中加载省市区 JSON 数据
  Future<List<Map<String, dynamic>>> loadCityData() async {
    try {
      final jsonStr = await rootBundle
          .loadString('lib/assets/data/cities.json')
          .timeout(const Duration(seconds: 10));
      final data = json.decode(jsonStr) as List<dynamic>;
      return _groupProvincesByAlphabet(data);
    } on TimeoutException catch (_) {
      throw Exception('加载超时，请稍后重试');
    }
  }

  List<Map<String, dynamic>> _groupProvincesByAlphabet(List<dynamic> data) {
    final Map<String, List<dynamic>> grouped = {};
    for (var province in data) {
      final name = province['name'] as String;
      final letter = PinyinHelper.getFirstWordPinyin(
        name,
      ).substring(0, 1).toUpperCase();
      grouped.putIfAbsent(letter, () => []).add(province);
    }
    final sortedKeys = grouped.keys.toList()..sort();
    return sortedKeys
        .map(
          (key) => {
            'group': key,
            'items': grouped[key]!
              ..sort((a, b) => (a['name'] as String).compareTo(b['name'])),
          },
        )
        .toList();
  }

  /// 根据区名称查找完整路径，返回格式：省 - 市 - 区
  String findFullDistrictPath(
    List<Map<String, dynamic>> cityData,
    String districtName,
  ) {
    for (var group in cityData) {
      for (var province in group['items']) {
        final cities = province['children'] ?? [];
        for (var city in cities) {
          final districts = city['children'] ?? [];
          for (var district in districts) {
            if (district['name'] == districtName) {
              return '${province['name']} - ${city['name']} - $districtName';
            }
          }
        }
      }
    }
    return districtName; // 未找到完整路径时返回区名
  }

  Widget _buildCityList(List<Map<String, dynamic>> cityData) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: cityData.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, groupIndex) {
        final group = cityData[groupIndex];
        final List items = group['items'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                group['group'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ExpansionPanelList.radio(
              elevation: 1,
              expandedHeaderPadding: EdgeInsets.zero,
              initialOpenPanelValue: _expandedProvince,
              children: List.generate(items.length, (index) {
                final province = items[index];
                final cities = province['children'] ?? [];
                final provinceValue = '${province['code'] ?? province['name']}';
                return ExpansionPanelRadio(
                  value: provinceValue,
                  headerBuilder: (context, isExpanded) =>
                      ListTile(title: Text(province['name'])),
                  body: ListBody(
                    children: cities.map<Widget>((city) {
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            title: Text(city['name']),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _showDistricts(
                              city,
                              province['name'],
                              cityData,
                            ),
                          ),
                          const Divider(height: 1),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  void _showDistricts(
    dynamic city,
    String provinceName,
    List<Map<String, dynamic>> cityData,
  ) {
    final districts = city['children'] ?? [];
    final parentContext = context; // 保存外层 context

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            itemCount: districts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final district = districts[index];
              final districtName = district['name'];
              return ListTile(
                title: Text(districtName),
                onTap: () {
                  Navigator.pop(context);
                  _showDistrictDialog(districtName, cityData, parentContext);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showDistrictDialog(
    String districtName,
    List<Map<String, dynamic>> cityData,
    BuildContext parentContext,
  ) {
    final fullPath = findFullDistrictPath(cityData, districtName);
    final parts = fullPath.split(' - ');
    final matchedProvince = parts.length > 0 ? parts[0] : '';
    final matchedCity = parts.length > 1 ? parts[1] : '';
    final matchedDistrict = parts.length > 2 ? parts[2] : districtName;

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('选择结果'),
          content: Text(
            '你选择了 $matchedProvince - $matchedCity - $matchedDistrict',
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
                Navigator.pop(parentContext, {
                  'province': matchedProvince,
                  'city': matchedCity,
                  'district': matchedDistrict,
                });
              },
            ),
            CupertinoDialogAction(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: loadCityData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('加载数据失败: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                '暂无数据',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        } else {
          final cityData = snapshot.data!;
          return Scaffold(body: _buildCityList(cityData));
        }
      },
    );
  }
}
