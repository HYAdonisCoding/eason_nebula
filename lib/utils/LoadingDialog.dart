import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  final String? message;

  const LoadingDialog({Key? key, this.message}) : super(key: key);

  static bool _isShowing = false;
  static Timer? _timer;

  /// 显示 LoadingDialog
  static void show(
    BuildContext context, {
    String? message,
    double? duration,
    VoidCallback? onDismiss,
  }) {
    if (_isShowing) return;
    _isShowing = true;

    final autoSeconds = () {
      if (message != null && message.isNotEmpty) {
        return (message.length * 0.2).clamp(2, 15);
      } else {
        return 3.0;
      }
    }();
    final delay = Duration(
      milliseconds: ((duration ?? autoSeconds) * 1000).toInt(),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoadingDialog(message: message),
    ).then((_) {
      _isShowing = false;
      _timer?.cancel();
      _timer = null;
      onDismiss?.call();
    });

    Future.delayed(delay, () {
      if (_isShowing) {
        hide(context);
      }
    });
  }

  /// 隐藏 LoadingDialog
  static void hide(BuildContext context) {
    if (_isShowing) {
      _isShowing = false;
      _timer?.cancel();
      _timer = null;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  int dotCount = 1;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (widget.message != null && widget.message!.isNotEmpty) {
      timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          dotCount = (dotCount % 3) + 1;
        });
      });
      LoadingDialog._timer = timer; // 方便静态管理
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    if (LoadingDialog._timer == timer) {
      LoadingDialog._timer = null;
    }
    super.dispose();
  }

  String get animatedMessage {
    if (widget.message == null || widget.message!.isEmpty) {
      return '';
    }
    return widget.message! + '.' * dotCount;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 150),
        child: SizedBox(
          width: 60,
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                  child: Container(color: Colors.transparent),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      if (widget.message != null &&
                          widget.message!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            animatedMessage,
                            style: const TextStyle(fontSize: 18),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    LoadingDialog.hide(context);
                  },
                  child: const Icon(Icons.close, size: 24, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
