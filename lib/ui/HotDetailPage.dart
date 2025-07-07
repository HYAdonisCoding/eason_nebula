import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HotDetailPage extends StatefulWidget {
  final String title;
  final String heatScore;
  final String linkUrl;

  const HotDetailPage({
    required this.title,
    required this.heatScore,
    required this.linkUrl,
    super.key,
  });

  @override
  State<HotDetailPage> createState() => _HotDetailPageState();
}

class _HotDetailPageState extends State<HotDetailPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    String decodedUrl = Uri.decodeFull(widget.linkUrl);
    // 替换主域名
    decodedUrl = decodedUrl.replaceFirst(
      'https://www.baidu.com',
      'https://wap.baidu.com',
    );
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(decodedUrl));
    _controller.setUserAgent(
      'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1',
    );

    print('加载热搜详情: ${widget.title}, 热度: ${widget.heatScore}, 链接: $decodedUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasonAppBar(
        title: widget.title,
        showBack: true,
        onBack: () async {
          // 如果 WebView 可以后退，则后退，否则返回上一页
          // 这里使用了 async/await 来确保可以正确处理异步操作
          // 注意：如果 WebView 没有后退历史，则会直接返回上一页
          // 这可以避免在 WebView 中后退时出现问题
          // 例如，如果用户在 WebView 中浏览了多个页面，点击返回时会
          // 先尝试后退到上一个页面，如果没有后退历史，则返回
          // 上一页的 Flutter 页面
          // 这样可以确保用户体验的一致性
          if (await _controller.canGoBack()) {
            _controller.goBack();
          } else {
            Navigator.of(context).pop();
          }
        },
        menuItems: [
          EasonMenuItem(
            title: '刷新',
            icon: Icons.refresh,
            iconColor: Colors.blueAccent,
            onTap: () {
              _controller.reload();
            },
          ),
          EasonMenuItem(
            title: '分享',
            icon: Icons.share,
            iconColor: Colors.green,
            onTap: () {
              // 这里可以实现分享功能
              // 例如使用 url_launcher 打开分享界面
              // 或者使用其他分享插件
              print('分享链接: ${widget.linkUrl}');
            },
          ),
          EasonMenuItem(
            title: '回到首页',
            icon: Icons.home,
            iconColor: Colors.blue,
            onTap: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              '热度：${widget.heatScore}',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: WebViewWidget(controller: _controller),
            ),
          ),
        ],
      ),
    );
  }
}
