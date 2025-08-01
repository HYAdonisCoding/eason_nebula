import 'package:eason_nebula/ui/Model/PersonalModel.dart';
import 'package:eason_nebula/ui/PersonalInfoInput.dart';
import 'package:eason_nebula/ui/Setting/SettingLocalizationPage.dart';
import 'package:eason_nebula/ui/Setting/SettingThemePage.dart';
import 'package:eason_nebula/utils/global_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingPage extends EasonBasePage {
  const SettingPage({Key? key}) : super(key: key);

  @override
  String get title => 'settings'.tr();

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends BasePageState<SettingPage> {
  @override
  Widget buildContent(BuildContext context) {
    return ScopedModelDescendant<Personalmodel>(
      builder: (context, child, model) {
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
                title: Text(model.name),
                subtitle: Text('clickToViewProfile').tr(),
                trailing: Icon(Icons.chevron_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PersonalInfoInputPage()),
                  );
                  setState(() {}); // 触发重建以读取最新 model.name
                },
              ),
            ),
            SizedBox(height: 24),
            // 通用设置
            Text(
              'general'.tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _SettingTile(
              icon: Icons.palette,
              iconColor: Colors.purple,
              title: 'themeStyle'.tr(),
              // subtitle: 根据当前主题状态动态显示
              subtitle: () {
                final mode = themeModeNotifier.value;
                switch (mode) {
                  case ThemeMode.light:
                    return 'lightMode'.tr();
                  case ThemeMode.dark:
                    return 'darkMode'.tr();
                  case ThemeMode.system:
                  default:
                    return 'followSystem'.tr();
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
              title: 'notifications'.tr(),
              subtitle: 'pushSoundVibrate'.tr(),
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.language,
              iconColor: Colors.blue,
              title: 'languageSetting'.tr(),
              subtitle: () {
                final locale = context.locale;
                final deviceLocale = context.deviceLocale;

                if (locale == deviceLocale) return 'followSystem'.tr();
                if (locale.languageCode == 'zh')
                  return 'simplifiedChinese'.tr();
                if (locale.languageCode == 'en') return 'english'.tr();
                return locale.toString();
              }(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingLocalizationPage()),
                );
              },
            ),
            SizedBox(height: 24),
            // 安全设置
            Text(
              'security'.tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _SettingTile(
              icon: Icons.lock,
              iconColor: Colors.teal,
              title: 'changePassword'.tr(),
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.fingerprint,
              iconColor: Colors.indigo,
              title: 'fingerprintUnlock'.tr(),
              onTap: () {},
            ),
            SizedBox(height: 24),
            // 关于
            Text(
              'about'.tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _SettingTile(
              icon: Icons.info,
              iconColor: Colors.grey,
              title: 'aboutUs'.tr(),
              onTap: () {},
            ),
            _SettingTile(
              icon: Icons.verified,
              iconColor: Colors.green,
              title: 'checkUpdate'.tr(),
              subtitle: 'latestVersion'.tr(),
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
                label: Text('logout'.tr(), style: TextStyle(fontSize: 16)),
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('loggedOut'.tr())));
                },
              ),
            ),
          ],
        );
      },
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
