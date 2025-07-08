import 'package:flutter/material.dart';

class EasonMenuItem {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onTap;

  EasonMenuItem({
    required this.title,
    this.icon,
    this.iconColor,
    required this.onTap,
  });
}

class EasonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Color>? gradientColors;

  final List<EasonMenuItem>? menuItems;
  final List<EasonMenuItem>? leadingMenuItems;
  EasonAppBar({
    Key? key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.gradientColors,
    this.menuItems,
    this.leadingMenuItems,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56);

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
              else if (leadingMenuItems != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: leadingMenuItems!.map((item) {
                    return IconButton(
                      icon: item.icon != null
                          ? Icon(item.icon, color: item.iconColor, size: 22)
                          : Text(item.title, style: TextStyle(color: Colors.white)),
                      onPressed: item.onTap,
                      splashRadius: 22,
                    );
                  }).toList(),
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
                  icon: menuItems != null && menuItems!.isNotEmpty
                      ? (menuItems!.first.icon != null
                          ? Icon(
                              menuItems!.first.icon,
                              color: menuItems!.first.iconColor,
                              size: 26,
                            )
                          : Text(menuItems!.first.title, style: TextStyle(color: Colors.white)))
                      : const Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                          size: 26,
                        ),
                  onPressed: () {
                    if (menuItems != null && menuItems!.isNotEmpty) {
                      menuItems!.first.onTap();
                    }
                  },
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
