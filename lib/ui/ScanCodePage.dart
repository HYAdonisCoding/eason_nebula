import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/utils/EasonMessenger.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';

class ScanCodePage extends EasonBasePage {
  const ScanCodePage({Key? key}) : super(key: key);

  @override
  String get title => 'ScanCodePage';

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends BasePageState<ScanCodePage> {
  final MobileScannerController _controller = MobileScannerController();
  @override
  Widget buildContent(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: (BarcodeCapture barcodes) {
            for (final barcode in barcodes.barcodes) {
              final rawValue = barcode.rawValue;
              if (rawValue != null) {
                debugPrint('扫描结果: $rawValue');
                _controller.stop();
                Vibration.vibrate();
                EasonMessenger.showSuccess(
                  context,
                  message: '扫描成功: $rawValue',
                  onComplete: () {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                );
                break;
              }
            }
          },
        ),
        // 中间扫描框和遮罩层
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
        // 半透明遮罩：四个方向的遮罩层
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _ScannerOverlayPainter()),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '请对准二维码进行扫描',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);
    final scanRectSize = 250.0;
    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanRectSize,
      height: scanRectSize,
    );

    // Draw the whole semi-transparent layer
    final outerRect = Offset.zero & size;
    // Clear center rectangle
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(outerRect),
        Path()..addRect(scanRect),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
