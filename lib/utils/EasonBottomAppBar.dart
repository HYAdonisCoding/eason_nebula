import 'package:flutter/material.dart';

class EasonBottomBarItem {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  EasonBottomBarItem({required this.icon, this.iconColor, required this.onTap});
}

class EasonBottomAppBar extends StatefulWidget {
  final List<EasonBottomBarItem>? leftItems;
  final VoidCallback? onRightAction;
  final Widget? rightWidget;

  const EasonBottomAppBar({
    Key? key,
    this.leftItems,
    this.onRightAction,
    this.rightWidget,
  }) : super(key: key);

  @override
  State<EasonBottomAppBar> createState() => _EasonBottomAppBarState();
}

class _EasonBottomAppBarState extends State<EasonBottomAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dropAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    // 回弹曲线
    _dropAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    // 启动动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? [Color(0xFF311B92), Color(0xFF00B8D4)] // 酷炫紫蓝
        : [Colors.purpleAccent, Colors.blueAccent, Colors.cyan];

    final items =
        widget.leftItems ??
        [
          EasonBottomBarItem(
            icon: Icons.home_rounded,
            iconColor: Colors.blue,
            onTap: () => print('主页'),
          ),
          EasonBottomBarItem(
            icon: Icons.settings_rounded,
            iconColor: Colors.deepPurple,
            onTap: () => print('设置'),
          ),
        ];

    // 按钮尺寸
    const double btnSize = 56;
    // 按钮底部与bar的间隙
    const double gap = 8;
    // 按钮有1/4悬浮在bar上方
    final double overlap = btnSize / 1.25;

    return SizedBox(
      height: kBottomNavigationBarHeight + overlap + gap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 背景撑满底部
          Positioned.fill(
            top: overlap,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF000000) : Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black54
                        : Colors.purpleAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
            ),
          ),
          // 内容在安全区域内
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: overlap,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: item.onTap,
                          child: Icon(
                            item.icon,
                            color: item.iconColor ??
                                (isDark ? Color(0xFFEEEEEE) : Theme.of(context).iconTheme.color),
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    SizedBox(width: btnSize / 2 + 8), // 预留右侧按钮空间
                  ],
                ),
              ),
            ),
          ),
          // 右侧悬浮加号按钮动画
          Positioned(
            right: 24,
            bottom: kBottomNavigationBarHeight - overlap + gap,
            child: AnimatedBuilder(
              animation: _dropAnim,
              builder: (context, child) {
                // 动画：从上方掉下
                final double dy = -80 * (1 - _dropAnim.value);
                return Transform.translate(offset: Offset(0, dy), child: child);
              },
              child:
                  widget.rightWidget ??
                  GestureDetector(
                    onTap: widget.onRightAction ?? () => print('右侧操作'),
                    child: Container(
                      width: btnSize,
                      height: btnSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Color(0xFF1A1A1A) : null,
                        gradient: isDark ? null : LinearGradient(colors: gradientColors),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black54
                                : Colors.purpleAccent.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 32),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
