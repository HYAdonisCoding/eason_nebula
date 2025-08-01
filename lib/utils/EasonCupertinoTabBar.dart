import 'package:flutter/material.dart';
import 'dart:ui';

class EasonCupertinoTabBarItem {
  final String label;
  final IconData icon;
  final Widget? customIcon;

  EasonCupertinoTabBarItem({
    required this.label,
    required this.icon,
    this.customIcon,
  });
}

class EasonCupertinoTabBar extends StatelessWidget {
  final List<EasonCupertinoTabBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final double height;
  final double indicatorHeight;
  final List<Color>? indicatorGradient;

  const EasonCupertinoTabBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.height = 56,
    this.indicatorHeight = 4,
    this.indicatorGradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double width = MediaQuery.of(context).size.width;

    final Color resolvedActiveColor = activeColor ??
        (isDark ? Colors.tealAccent.shade200 : Colors.blueAccent);
    final Color resolvedInactiveColor = inactiveColor ??
        (isDark ? Colors.grey.shade400 : Colors.grey);

    final List<Color> resolvedIndicatorGradient = indicatorGradient ??
        (isDark
            ? [Colors.tealAccent.shade200, Colors.cyanAccent.shade100]
            : [Colors.blueAccent, Colors.purpleAccent, Colors.cyan]);

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          color: isDark
              ? Colors.black.withOpacity(0.7)
              : Colors.white.withOpacity(0.82),
          child: SizedBox(
            height: height + indicatorHeight,
            child: Stack(
              children: [
                Row(
                  children: List.generate(items.length, (index) {
                    final selected = index == currentIndex;
                    return Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => onTap(index),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: selected
                                ? resolvedActiveColor.withOpacity(0.10)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              items[index].customIcon ??
                                  Icon(
                                    items[index].icon,
                                    color: selected
                                        ? resolvedActiveColor
                                        : resolvedInactiveColor,
                                    size: 24,
                                  ),
                              SizedBox(height: 2),
                              AnimatedDefaultTextStyle(
                                duration: Duration(milliseconds: 300),
                                style: TextStyle(
                                  color: selected
                                      ? resolvedActiveColor
                                      : resolvedInactiveColor,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                  shadows: selected
                                      ? [
                                          Shadow(
                                            color: resolvedActiveColor.withOpacity(0.18),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  items[index].label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                // 酷炫渐变指示器
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.elasticOut,
                  left: currentIndex * (width / items.length),
                  bottom: 0,
                  width: width / items.length,
                  height: indicatorHeight,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: resolvedIndicatorGradient,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: resolvedIndicatorGradient.first.withOpacity(0.18),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}