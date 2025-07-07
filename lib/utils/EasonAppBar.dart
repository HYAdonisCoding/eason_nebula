import 'package:flutter/material.dart';

class EasonMenuItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  EasonMenuItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });
}

class EasonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Color>? gradientColors;

  final List<EasonMenuItem>? menuItems;
  EasonAppBar({
    Key? key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.gradientColors,
    this.menuItems,
  }) : super(key: key);

  final GlobalKey _menuKey = GlobalKey();

  @override
  Size get preferredSize => Size.fromHeight(56);

  void _showCustomPopup(BuildContext context) {
    final RenderBox button =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    const double popupWidth = 180;
    const double arrowWidth = 24;
    const double arrowHeight = 12;
    final double screenWidth = overlay.size.width;

    // 让弹框水平居中于按钮
    double left = position.dx + button.size.width / 2 - popupWidth / 2;
    // 边界修正
    if (left < 8) left = 8;
    if (left + popupWidth > screenWidth - 8)
      left = screenWidth - popupWidth - 8;

    final double top = position.dy + button.size.height + 8;

    // 箭头相对弹框的left
    double arrowLeft =
        position.dx + button.size.width / 2 - arrowWidth / 2 - left;
    // 箭头也做边界修正
    if (arrowLeft < 8) arrowLeft = 8;
    if (arrowLeft + arrowWidth > popupWidth - 8)
      arrowLeft = popupWidth - arrowWidth - 8;

    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) {
        final items =
            menuItems ??
            [
              EasonMenuItem(
                title: '回到首页',
                icon: Icons.home,
                iconColor: Colors.blue,
                onTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).popUntil((route) => route.isFirst);
                  entry?.remove();
                },
              ),
              EasonMenuItem(
                title: '联系客服',
                icon: Icons.support_agent,
                iconColor: Colors.green,
                onTap: () {
                  entry?.remove();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('联系客服功能待实现')));
                },
              ),
            ];
        return Stack(
          children: [
            // 点击遮罩关闭弹框
            GestureDetector(
              onTap: () => entry?.remove(),
              child: Container(
                color: Colors.transparent,
                width: overlay.size.width,
                height: overlay.size.height,
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 箭头
                    Padding(
                      padding: EdgeInsets.only(left: arrowLeft),
                      child: CustomPaint(
                        size: Size(arrowWidth, arrowHeight),
                        painter: _TrianglePainter(color: Colors.white),
                      ),
                    ),
                    // 弹框内容
                    Container(
                      width: popupWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: items.asMap().entries.map((entryItem) {
                          final idx = entryItem.key;
                          final item = entryItem.value;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(item.icon, color: item.iconColor),
                                title: Text(
                                  item.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  entry?.remove(); // 先关闭弹框
                                  item.onTap(); // 再执行用户回调
                                },
                              ),
                              if (idx != items.length - 1) Divider(height: 1),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
    Overlay.of(context).insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              gradientColors ??
              [Colors.blue.shade800, Colors.blueAccent, Colors.cyan],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBack)
                SizedBox(
                  width: 56, // 给返回按钮固定宽度，方便对齐
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                    splashRadius: 22,
                  ),
                )
              else
                SizedBox(width: 56), // 左侧预留空白，保持居中
              // 标题部分
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // 右侧按钮
              SizedBox(
                width: 56,
                child: IconButton(
                  key: _menuKey,
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: () => _showCustomPopup(context),
                  splashRadius: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 小箭头Painter
class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
