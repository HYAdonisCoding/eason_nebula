import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingLocalizationPage extends EasonBasePage {
  const SettingLocalizationPage({Key? key}) : super(key: key);

  @override
  String get title => 'SettingLocalizationPage';

  @override
  State<SettingLocalizationPage> createState() => _SettingLocalizationPageState();
}

class _SettingLocalizationPageState extends BasePageState<SettingLocalizationPage> {
  @override
  Widget buildContent(BuildContext context) {
    final currentLocale = context.locale;
    final deviceLocale = context.deviceLocale;

    final bool isSystemLocale = currentLocale == deviceLocale;
    Locale? selected = isSystemLocale ? null : currentLocale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'languageSetting'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        RadioListTile<Locale?>(
          title: const Text('跟随系统'),
          value: null,
          groupValue: selected,
          onChanged: (value) {
            context.setLocale(deviceLocale);
          },
        ),
        RadioListTile<Locale?>(
          title: const Text('简体中文'),
          value: const Locale('zh', 'CN'),
          groupValue: selected,
          onChanged: (value) {
            context.setLocale(value!);
          },
        ),
        RadioListTile<Locale?>(
          title: const Text('English'),
          value: const Locale('en', 'US'),
          groupValue: selected,
          onChanged: (value) {
            context.setLocale(value!);
          },
        ),
        RadioListTile<Locale?>(
          title: const Text('Français'),
          value: const Locale('fr', 'FR'),
          groupValue: selected,
          onChanged: (value) {
            context.setLocale(value!);
          },
        ),
        RadioListTile<Locale?>(
          title: const Text('한국어'),
          value: const Locale('ko', 'KR'),
          groupValue: selected,
          onChanged: (value) {
            context.setLocale(value!);
          },
        ),
        RadioListTile<Locale?>(
          title: const Text('繁體中文'),
          value: const Locale('zh', 'Hant'),
          groupValue: selected,
          onChanged: (value) {
            context.setLocale(value!);
          },
        ),
      ],
    );
  }
}