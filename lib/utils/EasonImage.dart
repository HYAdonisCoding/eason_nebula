import 'package:flutter/material.dart';

class EasonImage extends StatelessWidget {
  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final String? placeholder;
  final Widget? placeholderWidget;
  final Widget? errorWidget;
  final void Function(String src)? onTap; // 修改这里

  const EasonImage({
    Key? key,
    required this.src,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius = 0,
    this.placeholder,
    this.placeholderWidget,
    this.errorWidget,
    this.onTap,
  }) : super(key: key);

  bool get _isNetwork => src.startsWith('http');

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (_isNetwork) {
      imageWidget = Image.network(
        src,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          if (placeholderWidget != null) return placeholderWidget!;
          if (placeholder != null) {
            return Image.asset(
              placeholder!,
              width: width,
              height: height,
              fit: fit,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          if (errorWidget != null) return errorWidget!;
          if (placeholder != null) {
            return Image.asset(
              placeholder!,
              width: width,
              height: height,
              fit: fit,
            );
          }
          return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
        },
      );
    } else {
      imageWidget = Image.asset(src, width: width, height: height, fit: fit);
    }

    if (borderRadius > 0) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageWidget,
      );
    }

    if (onTap != null) {
      imageWidget = GestureDetector(
        onTap: () => onTap!(src), // 传递src参数
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}