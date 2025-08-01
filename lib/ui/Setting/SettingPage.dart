import 'package:eason_nebula/ui/Setting/SettingThemePage.dart';
import 'package:eason_nebula/utils/global_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:eason_nebula/ui/Base/EasonBasePage.dart';

class SettingPage extends EasonBasePage {
  const SettingPage({Key? key}) : super(key: key);

  @override
  String get title => '设置';

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends BasePageState<SettingPage> {
  @override
  Widget buildContent(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(24),
      children: [
        // 个人信息
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text('Eason'),
            subtitle: Text('点击查看个人资料'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        SizedBox(height: 24),
        // 通用设置
        Text('通用', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        _SettingTile(
          icon: Icons.palette,
          iconColor: Colors.purple,
          title: '主题风格',
          // subtitle: 根据当前主题状态动态显示
          subtitle: () {
            final mode = themeModeNotifier.value;
            switch (mode) {
              case ThemeMode.light:
                return '浅色模式';
              case ThemeMode.dark:
                return '深色模式';
              case ThemeMode.system:
              default:
                return '跟随系统';
            }
          }(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingThemePage()),
            );
          },
        ),
        _SettingTile(
          icon: Icons.notifications,
          iconColor: Colors.orange,
          title: '消息通知',
          subtitle: '推送、声音、振动',
          onTap: () {},
        ),
        _SettingTile(
          icon: Icons.language,
          iconColor: Colors.blue,
          title: '语言',
          subtitle: '简体中文',
          onTap: () {},
        ),
        SizedBox(height: 24),
        // 安全设置
        Text('安全', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        _SettingTile(
          icon: Icons.lock,
          iconColor: Colors.teal,
          title: '修改密码',
          onTap: () {},
        ),
        _SettingTile(
          icon: Icons.fingerprint,
          iconColor: Colors.indigo,
          title: '指纹/面容解锁',
          onTap: () {},
        ),
        SizedBox(height: 24),
        // 关于
        Text('关于', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        _SettingTile(
          icon: Icons.info,
          iconColor: Colors.grey,
          title: '关于我们',
          onTap: () {},
        ),
        _SettingTile(
          icon: Icons.verified,
          iconColor: Colors.green,
          title: '检查更新',
          subtitle: '当前已是最新版',
          onTap: () {},
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

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.13),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
