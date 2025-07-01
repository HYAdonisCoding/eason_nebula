import 'package:flutter/material.dart';

import 'SettingPage.dart';

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(24),
      children: [
        Text(
          '欢迎回来！',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text('你好，Eason'),
            subtitle: Text('今天也要元气满满哦！'),
            trailing: Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {},
          ),
        ),
        SizedBox(height: 24),
        Text(
          '快捷功能',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _QuickAction(icon: Icons.qr_code_scanner, label: '扫一扫'),
            _QuickAction(icon: Icons.message, label: '消息'),
            _QuickAction(
              icon: Icons.settings,
              label: '设置',
              onTap: () {
                print('点击设置');
                // 这里可以添加跳转到设置页面的逻辑
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingPage()),
                );
              },
            ),
            _QuickAction(icon: Icons.star, label: '收藏'),
          ],
        ),
        SizedBox(height: 32),
        Text('推荐', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        ...List.generate(
          3,
          (i) => Card(
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.trending_up, color: Colors.purple),
              title: Text('推荐内容 ${i + 1}'),
              subtitle: Text('这里是一些你可能感兴趣的内容。'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // 新增
  const _QuickAction({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.15),
            child: Icon(icon, color: Colors.blueAccent),
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
