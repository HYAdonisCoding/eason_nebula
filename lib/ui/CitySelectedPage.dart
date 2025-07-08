import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CitySelectedPage extends StatefulWidget {
  @override
  _CitySelectedPageState createState() => _CitySelectedPageState();
}

class _CitySelectedPageState extends State<CitySelectedPage> {
  List<dynamic> cityData = [];
  bool isCityExpanded = false; // 添加这个作为状态（或用 ExpansionTile + UniqueKey）

  @override
  void initState() {
    super.initState();
    loadCityData();
  }

  Future<void> loadCityData() async {
    final jsonStr = await rootBundle.loadString('lib/assets/data/cities.json');
    final data = json.decode(jsonStr);
    setState(() {
      cityData = data;
    });
  }

  Widget _buildCityList() {
    return ListView.builder(
      itemCount: cityData.length,
      itemBuilder: (context, provinceIndex) {
        final province = cityData[provinceIndex];
        final cities = province['children'] ?? [];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ExpansionTile(
              title: Text(
                province['name'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: cities
                  .map<Widget>((city) => _buildCityTile(city, province['name']))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCityTile(dynamic city, String provinceName) {
    final districts = city['children'] ?? [];
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Card(
        color: Colors.grey.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ExpansionTile(
          title: Text(
            city['name'],
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          children: districts
              .map<Widget>(
                (d) => _buildDistrictTile(d, city['name'], provinceName),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildDistrictTile(
    dynamic district,
    String cityName,
    String provinceName,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 24.0, right: 12.0),
      title: Text(district['name'], style: TextStyle(fontSize: 14)),
      trailing: Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '你选择了 $provinceName - $cityName - ${district['name']}',
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasonAppBar(title: '省市区选择'),
      body: cityData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildCityList(),
    );
  }
}
