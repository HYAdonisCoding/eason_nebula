import 'package:flutter/material.dart';
import 'SettingPage.dart';

class ProfilePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(24),
      children: [
        // 头像和昵称
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white, size: 54),
              ),
              SizedBox(height: 12),
              Text(
                'Eason',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.purpleAccent, size: 16),
                    SizedBox(width: 4),
                    Text('Lv.5', style: TextStyle(color: Colors.purpleAccent)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 28),
        // 操作入口
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ProfileAction(icon: Icons.favorite, label: '收藏'),
            _ProfileAction(icon: Icons.history, label: '历史'),
            _ProfileAction(icon: Icons.wallet, label: '钱包'),
            _ProfileAction(
              icon: Icons.settings,
              label: '设置',
              onTap: () {
                // 跳转到设置页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingPage()),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 32),
        // 个人信息卡片
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.verified_user, color: Colors.blue),
                title: Text('实名认证'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.phone_android, color: Colors.green),
                title: Text('绑定手机'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.lock, color: Colors.orange),
                title: Text('修改密码'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        SizedBox(height: 32),
        // 退出登录
        Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            icon: Icon(Icons.logout),
            label: Text('退出登录', style: TextStyle(fontSize: 16)),
            onPressed: () {
              // 退出登录逻辑
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('已退出登录')));
            },
          ),
        ),
      ],
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // 新增
  const _ProfileAction({required this.icon, required this.label, this.onTap});
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
