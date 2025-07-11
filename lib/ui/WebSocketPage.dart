import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketPage extends EasonBasePage {
  const WebSocketPage({Key? key}) : super(key: key);

  @override
  String get title => 'WebSocketPage';

  @override
  State<WebSocketPage> createState() => _WebSocketPageState();
}

class _WebSocketPageState extends BasePageState<WebSocketPage> {
  late final WebSocketChannel _channel;
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    // 创建连接（这里用一个 echo 测试服务器）
    _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));

    // 监听接收消息
    _channel.stream.listen(
      (message) {
        setState(() {
          _messages.add('收到: $message');
        });
      },
      onError: (error) {
        setState(() {
          _messages.add('错误: $error');
        });
      },
      onDone: () {
        setState(() {
          _messages.add('连接关闭');
        });
      },
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  /// 构建页面内容
  @override
  Widget buildContent(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: _messages.map((msg) => Text(msg)).toList(),
              ),
            ),
          ),
          Material(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '输入要发送的消息',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      _channel.sink.add(_controller.text.trim());
      setState(() {
        _messages.add('发送: ${_controller.text.trim()}');
      });
      _controller.clear();
    }
  }
}
