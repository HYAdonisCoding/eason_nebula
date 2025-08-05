import 'package:eason_nebula/utils/redux_app.dart';
import 'package:flutter_redux/flutter_redux.dart';
// ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class FontPage extends EasonBasePage {
  const FontPage({Key? key}) : super(key: key);

  @override
  String get title => 'FontPage';

  @override
  State<FontPage> createState() => _FontPageState();
}

class _FontPageState extends BasePageState<FontPage> {
  @override
  Widget buildContent(BuildContext context) {
    return StoreConnector<AppState, _FontSettingsViewModel>(
      converter: (store) => _FontSettingsViewModel.fromStore(store),
      builder: (context, vm) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: vm.fontFamily,
                items:
                    [
                      'Roboto',
                      'Arial',
                      'Times New Roman',
                      'Courier New',
                      '宋体',
                      '黑体',
                    ].map((font) {
                      return DropdownMenuItem(value: font, child: Text(font));
                    }).toList(),
                onChanged: vm.onFontFamilyChanged,
                hint: const Text('选择字体'),
              ),
              const SizedBox(height: 20),
              Slider(
                value: vm.fontSize,
                min: 12,
                max: 48,
                divisions: 12,
                label: vm.fontSize.toStringAsFixed(0),
                onChanged: vm.onFontSizeChanged,
              ),
              const SizedBox(height: 20),
              Text(
                '示例文本StoreConnector',
                style: TextStyle(
                  fontSize: vm.fontSize,
                  fontFamily: vm.fontFamily,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FontSettingsViewModel {
  final String fontFamily;
  final double fontSize;
  final void Function(String?) onFontFamilyChanged;
  final void Function(double) onFontSizeChanged;

  _FontSettingsViewModel({
    required this.fontFamily,
    required this.fontSize,
    required this.onFontFamilyChanged,
    required this.onFontSizeChanged,
  });

  static _FontSettingsViewModel fromStore(Store<AppState> store) {
    return _FontSettingsViewModel(
      fontFamily: store.state.fontFamily,
      fontSize: store.state.fontSize,
      onFontFamilyChanged: (font) {
        if (font != null) {
          store.dispatch(UpdateFontFamilyAction(font));
        }
      },
      onFontSizeChanged: (size) {
        store.dispatch(UpdateFontSizeAction(size));
      },
    );
  }
}
