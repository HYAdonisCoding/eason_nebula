import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/utils/global_theme_controller.dart';
import 'package:flutter/material.dart';

class SettingThemePage extends EasonBasePage {
  const SettingThemePage({Key? key}) : super(key: key);

  @override
  String get title => 'SettingTheme';

  @override
  State<SettingThemePage> createState() => _SettingThemePageState();
}

class _SettingThemePageState extends BasePageState<SettingThemePage> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = themeModeNotifier.value;
  }

  @override
  Widget buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      children: [
        Text(
          '主题模式',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              RadioListTile<ThemeMode>(
                secondary: const Icon(Icons.light_mode_outlined),
                title: const Text('明亮模式'),
                value: ThemeMode.light,
                groupValue: _themeMode,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _themeMode = value;
                      //  更新全局主题状态
                      themeModeNotifier.value = value;
                      saveThemeModeToPrefs(value); // 新增：保存到本地
                    });
                  }
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
              const Divider(height: 1),
              RadioListTile<ThemeMode>(
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text('暗黑模式'),
                value: ThemeMode.dark,
                groupValue: _themeMode,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _themeMode = value;
                      //  更新全局主题状态
                      themeModeNotifier.value = value;
                      saveThemeModeToPrefs(value); // 新增：保存到本地
                    });
                  }
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
              ),
              const Divider(height: 1),
              RadioListTile<ThemeMode>(
                secondary: const Icon(Icons.settings_suggest_outlined),
                title: const Text('跟随系统'),
                value: ThemeMode.system,
                groupValue: _themeMode,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _themeMode = value;
                      //  更新全局主题状态
                      themeModeNotifier.value = value;
                      saveThemeModeToPrefs(value); // 新增：保存到本地
                    });
                  }
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
