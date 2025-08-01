import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class StaggeredAnimation extends EasonBasePage {
  final String tag;

  const StaggeredAnimation({Key? key, required this.tag}) : super(key: key);

  @override
  String get title => 'StaggeredAnimation';

  @override
  State<StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends BasePageState<StaggeredAnimation>
    with TickerProviderStateMixin {
  // 创建一个AnimationController和Animation对象
  late AnimationController _controller;
  late Animation<double> _animation;

  // 根据需要创建不同效果的Animation对象
  Animation<double>? _opacityAnimation;
  Animation<double>? _widthAnimation;
  Animation<Color?>? _colorAnimation;
  Animation<double>? _scaleAnimation;
  Animation<double>? _rotateAnimation;
  Animation<Offset>? _slideAnimation;
  Animation<Size>? _sizeAnimation;

  // 初始化动画控制器和动画对象
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    // 实例化动画效果 组合起来
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animation)
      ..addListener(() {
        setState(() {}); // 更新状态以重绘
      });
    _widthAnimation = Tween<double>(begin: 50.0, end: 200.0).animate(_animation)
      ..addListener(() {
        setState(() {}); // 更新状态以重绘
      });
    _colorAnimation =
        ColorTween(begin: Colors.red, end: Colors.blue).animate(_animation)
          ..addListener(() {
            setState(() {}); // 更新状态以重绘
          });
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_animation);
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animation);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(_animation);
    _sizeAnimation =
        Tween<Size>(
          begin: const Size(50.0, 50.0),
          end: const Size(100.0, 100.0),
        ).animate(_animation)..addListener(() {
          setState(() {});
        });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });
  }

  // 控制动画的播放
  Future<void> _startAnimation() async {
    try {
      await _controller.forward();
      await _controller.reverse();
    } on TickerCanceled {
      // 处理Ticker取消的情况
      debugPrint('Ticker was canceled');
    } finally {
      // _controller.dispose(); // 确保在不需要时释放资源
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 10),
          // 使用Row包裹Hero和ElevatedButton，并添加间距
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: widget.tag,
                child: Icon(Icons.straighten, color: Colors.teal, size: 60),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _startAnimation,
                child: const Text('开始动画'),
              ),
            ],
          ),
          // 页面组件可借助Animation效果值进行变换
          Container(
            width: 300,
            height: 600,
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: _opacityAnimation?.value ?? 1.0,
                    child: Container(
                      width: _widthAnimation?.value ?? 100.0,
                      height: 100.0,
                      color: _colorAnimation?.value ?? Colors.red,
                      child: const Center(child: Text('交错动画示例')),
                    ),
                  ),
                  SizedBox(height: 20),
                  Transform.scale(
                    scale: _scaleAnimation?.value ?? 1.0,
                    child: Transform.rotate(
                      angle: (_rotateAnimation?.value ?? 0.0) * 3.14, // 转换为弧度
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.green,
                        child: const Center(child: Text('缩放和旋转')),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SlideTransition(
                      position:
                          _slideAnimation ??
                          AlwaysStoppedAnimation(Offset.zero),
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.orange,
                        child: const Center(child: Text('滑动动画')),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  AnimatedBuilder(
                    animation:
                        _sizeAnimation ??
                        AlwaysStoppedAnimation(const Size(100, 100)),
                    builder: (context, child) {
                      return Container(
                        width: _sizeAnimation!.value.width,
                        height: _sizeAnimation!.value.height,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            '尺寸动画',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
