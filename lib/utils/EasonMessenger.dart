import 'package:flutter/material.dart';
import 'dart:ui';

class EasonMessenger {
  static void showSuccess(
    BuildContext context, {
    required String message,
    VoidCallback? onComplete,
  }) => show(
    context,
    message: message,
    icon: Icons.check_circle_rounded,
    gradientStart: Colors.purpleAccent,
    gradientEnd: Colors.cyan,
    onComplete: () => onComplete?.call(),
  );
  static void showError(
    BuildContext context, {
    required String message,
    VoidCallback? onComplete,
  }) => show(
    context,
    message: message,
    icon: Icons.error_rounded,
    gradientStart: Colors.redAccent,
    gradientEnd: Colors.orangeAccent,
    onComplete: () => onComplete?.call(),
  );
  static void show(
    BuildContext context, {
    required String message,
    Duration? duration,
    IconData icon = Icons.info_rounded,
    Color? gradientStart,
    Color? gradientEnd,
    VoidCallback? onComplete,
  }) {
    // 根据文字长度动态计算显示时间，最长5秒，最短2秒
    int len = message.characters.length;
    final showDuration =
        duration ??
        Duration(milliseconds: (1000 + len * 120).clamp(2000, 5000));

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: _EasonMessengerContent(
            message: message,
            icon: icon,
            gradientStart: gradientStart ?? Colors.deepPurple,
            gradientEnd: gradientEnd ?? Colors.blueAccent,
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(showDuration, () {
      entry.remove();
      if (onComplete != null) onComplete();
    });
  }
}

class _EasonMessengerContent extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color gradientStart;
  final Color gradientEnd;

  const _EasonMessengerContent({
    required this.message,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AnimatedOpacity(
            opacity: 1,
            duration: Duration(milliseconds: 300),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradientStart.withOpacity(0.3),
                    gradientEnd.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: gradientStart.withOpacity(0.18),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 36),
                  SizedBox(width: 18),
                  Flexible(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
