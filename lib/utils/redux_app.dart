import 'package:flutter_redux/flutter_redux.dart';
// ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// 定义State实体对象，内含属性和构造方法
class AppState {
  int counter;
  String fontFamily;
  double fontSize;

  AppState({
    required this.counter,
    required this.fontFamily,
    required this.fontSize,
  });

  AppState copyWith({
    int? counter,
    String? fontFamily,
    double? fontSize,
  }) {
    return AppState(
      counter: counter ?? this.counter,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

// 定义actions
enum Actions { Increment, Decrement }

class UpdateFontFamilyAction {
  final String fontFamily;
  UpdateFontFamilyAction(this.fontFamily);
}

class UpdateFontSizeAction {
  final double fontSize;
  UpdateFontSizeAction(this.fontSize);
}

// 定义Reducer中间件reducer函数，关联Actions和AppState
AppState reducer(AppState state, dynamic action) {
  switch (action) {
    case Actions.Increment:
      return state.copyWith(counter: state.counter + 1);
    case Actions.Decrement:
      return state.copyWith(counter: state.counter - 1);
    default:
      if (action is UpdateFontFamilyAction) {
        return state.copyWith(fontFamily: action.fontFamily);
      } else if (action is UpdateFontSizeAction) {
        return state.copyWith(fontSize: action.fontSize);
      }
      return state;
  }
}

// 构建Store，初始化实体对象并赋值
final store = Store<AppState>(
  reducer,
  initialState: AppState(counter: 0, fontFamily: 'Roboto', fontSize: 16.0),
);
