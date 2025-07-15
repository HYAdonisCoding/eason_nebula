import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:eason_nebula/utils/EasonMessenger.dart';
import 'package:flutter/material.dart';

class GesturePage extends EasonBasePage {
  // 全局 Key，用于访问 _GesturePageState 中的方法
  static final GlobalKey<_GesturePageState> gestureKey =
      GlobalKey<_GesturePageState>();

  GesturePage({Key? key}) : super(key: gestureKey);

  @override
  String get title => 'GesturePage';

  @override
  State<GesturePage> createState() => _GesturePageState();

  @override
  List<EasonMenuItem>? menuItems(BuildContext context) {
    return [
      EasonMenuItem(
        title: '重置',
        icon: Icons.refresh,
        iconColor: Colors.blueAccent,
        // 调用 _GesturePageState 中的 reset 方法
        onTap: () => gestureKey.currentState?.reset(),
      ),
    ];
  }
}

class _GesturePageState extends BasePageState<GesturePage> {
  // 当前缩放比例
  double _scale = 1.0;

  // 当前位移偏移
  Offset _offset = Offset.zero;

  // 缩放开始时的初始缩放比例
  double _previousScale = 1.0;

  // 对外暴露的重置方法
  void reset() {
    setState(() {
      _scale = 1.0;
      _offset = Offset.zero;
      _previousScale = 1.0;
      EasonMessenger.showSuccess(context, message: '重置成功');
    });
  }

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: GestureDetector(
        // 缩放开始：记录当前的缩放比例
        onScaleStart: (details) {
          _previousScale = _scale;
        },
        // 缩放更新：支持双指缩放和单指拖动图片移动
        onScaleUpdate: (details) {
          setState(() {
            // 缩放：如果是双指捏合，details.scale 会变化
            _scale = (_previousScale * details.scale).clamp(0.5, 3.0);
            // 平移：每次直接在现有 offset 上加增量
            _offset += details.focalPointDelta;
          });
        },
        // 缩放结束：保存当前缩放比例
        onScaleEnd: (details) {
          _previousScale = _scale;
        },
        // 双击放大：每次乘以1.5，超过5倍后重置
        onDoubleTap: () {
          setState(() {
            _scale *= 1.5;
            if (_scale > 5.0) {
              _scale = 1.0;
              _offset = Offset.zero;
              _previousScale = 1.0;
              EasonMessenger.showSuccess(context, message: '已超过5倍，自动重置');
            }
          });
        },
        onLongPress: () {
          reset();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
          // 缩放以图片中心为基点进行缩放和平移
          transform: Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            // 平移到图片中心
            ..translate(100.0, 100.0)
            ..scale(_scale)
            // 平移回原位
            ..translate(-100.0, -100.0),
          child: Image.asset(
            'lib/assets/images/feilong_2.jpeg',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Text('图片加载失败', style: TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}
