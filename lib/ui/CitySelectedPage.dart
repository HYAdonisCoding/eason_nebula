import 'package:eason_nebula/utils/EasonMessenger.dart';
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
  Widget buildContent(BuildContext context) {
    return _CitySelectedPageBody(); // 把页面内容放入 StateLess/Stateful 子组件中更清晰
  }
}

// 页面主体作为 StatefulWidget 抽出来
class _CitySelectedPageBody extends StatefulWidget {
  @override
  State<_CitySelectedPageBody> createState() => _CitySelectedPageState();
}

// 城市选择页面的状态
class _CitySelectedPageState extends State<_CitySelectedPageBody> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> cityData = [];
  final Map<String, GlobalKey> _provinceKeys = {};
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadCityData();
  }

  // 从本地 assets 中加载省市区 JSON 数据
  Future<void> loadCityData() async {
    final jsonStr = await rootBundle.loadString('lib/assets/data/cities.json');
    final data = json.decode(jsonStr);
    setState(() {
      cityData = _groupProvincesByAlphabet(data);
    });
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

  Widget _buildCityList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: cityData.length,
      itemBuilder: (context, groupIndex) {
        final group = cityData[groupIndex];
        final List items = group['items'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                group['group'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ExpansionPanelList.radio(
              elevation: 1,
              expansionCallback: (index, isExpanded) {
                final province = items[index];
                final value = province['code'] ?? province['name'];
                final key = _provinceKeys[value];
                if (key?.currentContext != null) {
                  Scrollable.ensureVisible(
                    key!.currentContext!,
                    duration: Duration(milliseconds: 300),
                    alignment: 0.1,
                    curve: Curves.easeInOut,
                  );
                }
              },
              children: List.generate(items.length, (index) {
                final province = items[index];
                final cities = province['children'] ?? [];
                final provinceValue = province['code'] ?? province['name'];
                final itemKey = _provinceKeys.putIfAbsent(
                  provinceValue,
                  () => GlobalKey(),
                );
                return ExpansionPanelRadio(
                  value: provinceValue,
                  headerBuilder: (context, isExpanded) => Container(
                    key: itemKey,
                    child: ListTile(title: Text(province['name'])),
                  ),
                  body: ListBody(
                    children: cities.map<Widget>((city) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(city['name']),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () => _showDistricts(city, province['name']),
                          ),
                          Divider(height: 1),
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

  void _showDistricts(dynamic city, String provinceName) {
    final districts = city['children'] ?? [];
    final parentContext = context; // 保存外层 context

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Builder(
          builder: (context) => SizedBox(
            height: 400,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: districts.map<Widget>((district) {
                  return ListTile(
                    title: Text(district['name']),
                    onTap: () {
                      Navigator.pop(context);
                      final districtName = district['name'];

                      String matchedProvince = '';
                      String matchedCity = '';
                      String matchedDistrict = districtName;

                      for (var group in cityData) {
                        for (var province in group['items']) {
                          final cities = province['children'] ?? [];
                          for (var c in cities) {
                            final dists = c['children'] ?? [];
                            for (var d in dists) {
                              if (d['name'] == districtName) {
                                matchedProvince = province['name'];
                                matchedCity = c['name'];
                                break;
                              }
                            }
                            if (matchedCity.isNotEmpty) break;
                          }
                          if (matchedProvince.isNotEmpty) break;
                        }
                        if (matchedProvince.isNotEmpty) break;
                      }

                      print(
                        'Selected path: $matchedProvince - $matchedCity - $matchedDistrict',
                      );

                      EasonMessenger.showSuccess(
                        context,
                        message:
                            '你选择了 $matchedProvince - $matchedCity - $matchedDistrict',
                        onComplete: () {
                          Navigator.pop(parentContext, {
                            'province': matchedProvince,
                            'city': matchedCity,
                            'district': matchedDistrict,
                          });
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  // 页面构建入口，显示加载中或城市列表
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cityData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildCityList(),
    );
  }
}
