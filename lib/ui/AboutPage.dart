import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class AboutPage extends EasonBasePage {
  const AboutPage({Key? key}) : super(key: key);

  @override
  String get title => '关于我们';

  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/feilong_1.jpeg'),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Eason Nebula',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              '版本 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          SizedBox(height: 30),
          Text(
            '简介',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Eason Nebula 是一款集成多项功能的现代化移动应用，旨在提供高效、美观、实用的用户体验。',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            '开发者',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '开发者：Eason\n邮箱：eason@example.com',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            '开源地址',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'GitHub: https://github.com/HYAdonisCoding/eason_nebula',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
          SizedBox(height: 20),
          Text(
            'Gitee: https://gitee.com/hongyangcao/eason_nebula',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
          SizedBox(height: 20),
          Text(
            '版权信息',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('© 2025 Eason. 保留所有权利。', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
