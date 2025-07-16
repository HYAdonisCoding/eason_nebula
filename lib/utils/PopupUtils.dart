import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:flutter/material.dart';

class PopupUtils {
  static OverlayEntry? _popupEntry;

  static void showCustomPopup(
    BuildContext context, {
    required GlobalKey anchorKey,
    required List<EasonMenuItem> items,
  }) {
    if (_popupEntry != null) {
      _popupEntry!.remove();
      _popupEntry = null;
    }
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final renderBox = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final size = renderBox.size;

    // 计算弹窗位置
    final double screenWidth = overlay.size.width;
    double left = offset.dx + size.width / 2 - 90; // 弹窗宽度 180
    if (left < 10) left = 10;
    if (left + 180 > screenWidth - 10) left = screenWidth - 190;

    final double top = offset.dy + size.height + 5; // 距离按钮底部5px
    final double arrowLeft =
        offset.dx + size.width / 2 - left - 7; // 箭头宽14，居中按钮

    _popupEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _popupEntry?.remove();
          _popupEntry = null;
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            Positioned(
              left: left,
              top: top,
              width: 180,
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 箭头
                    Positioned(
                      top: -7,
                      left: arrowLeft,
                      child: CustomPaint(
                        size: const Size(14, 7),
                        painter: _TrianglePainter(color: Colors.white),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: items.asMap().entries.expand((entry) {
                          int idx = entry.key;
                          var item = entry.value;
                          return [
                            ListTile(
                              leading: Icon(item.icon, color: item.iconColor),
                              title: Text(item.title),
                              onTap: () {
                                _popupEntry?.remove();
                                _popupEntry = null;
                                item.onTap?.call();
                              },
                            ),
                            if (idx != items.length - 1)
                              const Divider(height: 1, thickness: 1),
                          ];
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_popupEntry!);
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
