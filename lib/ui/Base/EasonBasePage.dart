import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:flutter/material.dart';

abstract class EasonBasePage extends StatefulWidget {
  const EasonBasePage({Key? key}) : super(key: key);

  String get title;

  /// 可选：定义右侧菜单按钮列表，默认返回 null。
  /// 子类如需展示 AppBar 右侧按钮，可重写此方法返回按钮列表。
  List<EasonMenuItem>? menuItems(BuildContext context) => null;

  /// 可选：定义左侧菜单按钮列表，默认返回 null。
  /// 子类如需展示返回按钮或其他按钮，可重写此方法。
  List<EasonMenuItem>? leadingMenuItems(BuildContext context) => null;

  @override
  State<EasonBasePage> createState() => _EasonBasePageState();

  Widget buildContent(BuildContext context);
}

class _EasonBasePageState extends State<EasonBasePage> {
  @override
  void initState() {
    super.initState();
    debugPrint('【生命周期】${widget.title} 页面 initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('【生命周期】${widget.runtimeType} 页面 didChangeDependencies');
  }

  @override
  void didUpdateWidget(covariant EasonBasePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('【生命周期】${widget.runtimeType} 页面 didUpdateWidget');
  }

  @override
  void deactivate() {
    super.deactivate();
    debugPrint('【生命周期】${widget.runtimeType} 页面 deactivate');
  }

  @override
  void reassemble() {
    super.reassemble();
    debugPrint('【生命周期】${widget.runtimeType} 页面 reassemble（热重载）');
  }

  @override
  void dispose() {
    debugPrint('【生命周期】${widget.title} 页面 dispose');
    super.dispose();
  }

  @override
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Build the page widget.
  ///
  /// This method should not be overridden. To build the page content, override
  /// [buildContent] instead.
  ///
  /// The returned widget is a [Scaffold] with an app bar and the page content.
  /// The app bar's title is set to [title] and its menu items are set to
  /// [menuItems].
  ///
  /// The page content is built by calling [buildContent] with the given
  /// [BuildContext].
  /*******  e25797b7-f250-4886-b2f1-e1d0382bd127  *******/
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasonAppBar(
        title: widget.title,
        menuItems: widget.menuItems(context),
        leadingMenuItems: widget.leadingMenuItems(context),
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: widget.buildContent(context),
    );
  }
}
