import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/ui/CommentPage.dart';
import 'package:eason_nebula/utils/CookieUtils.dart';
import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:eason_nebula/utils/EasonGlobal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class DetailNotePage extends EasonBasePage {
  const DetailNotePage({Key? key, required this.item}) : super(key: key);

  final Map<String, dynamic> item;

  @override
  String get title => '笔记详情';

  @override
  List<EasonMenuItem> menuItems(BuildContext context) => [
    EasonMenuItem(
      title: '评论',
      icon: Icons.comment,
      iconColor: Colors.blueAccent,
      onTap: () {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => CommentPage(item: item)),
        );
      },
    ),
  ];

  @override
  State<DetailNotePage> createState() => _DetailNotePageState();
}

class _DetailNotePageState extends BasePageState<DetailNotePage> {
  @override
  Widget buildContent(BuildContext context) {
    return _DetailNoteContent(item: widget.item);
  }
}

class _DetailNoteContent extends StatefulWidget {
  final Map<String, dynamic> item;
  const _DetailNoteContent({required this.item});

  @override
  State<_DetailNoteContent> createState() => _DetailNoteContentState();
}

class _DetailNoteContentState extends State<_DetailNoteContent> {
  bool isLoading = true;
  late InAppWebViewController _webViewController;
  String? cookie;
  String? url;

  int progress = 0;

  Timer? _timeoutTimer;
  final int pageLoadTimeout = 15; // 超时时间，单位秒

  int retryCount = 0;
  final int maxRetry = 2;

  @override
  void initState() {
    super.initState();
    CookieUtils.loadAndGetCookie().then((value) {
      cookie = value;
      _loadWebViewWithCookie(cookie!);
    });
  }

  void _loadWebViewWithCookie(String cookieToUse) {
    final item = widget.item;
    url =
        'https://www.xiaohongshu.com/explore/${item['id']}?xsec_token=${item['xsec_token']}&xsec_source=pc_feed&source=404';
    print('请求 URL: $url');
    setState(() {});
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Stack(
        children: [
          if (!isLoading)
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(url!),
                headers: {'Cookie': cookie ?? ''},
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                userAgent:
                    'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1',
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, uri) {
                print('[WebView] 开始加载: $uri');
                _timeoutTimer?.cancel();
                _timeoutTimer = Timer(Duration(seconds: pageLoadTimeout), () {
                  print('[WebView] 加载超时: $uri');

                  if (!mounted) return;

                  setState(() {
                    isLoading = false;
                  });

                  if (retryCount < maxRetry) {
                    retryCount++;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('页面加载超时，正在重试...')),
                    );
                    _webViewController.reload();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('页面加载失败，请检查网络')),
                    );
                  }
                });
              },
              onLoadStop: (controller, uri) async {
                print('[WebView] 页面加载完成: $uri');
                _timeoutTimer?.cancel();
                setState(() {
                  isLoading = false;
                });
                retryCount = 0;
                final cookieManager = CookieManager.instance();
                final cookies = await cookieManager.getCookies(
                  url: WebUri(url!),
                );
                final cookieString = cookies
                    .map((c) => '${c.name}=${c.value}')
                    .join('; ');
                await CookieUtils.setCookie(cookieString);
              },
              onLoadError: (controller, uri, code, message) {
                print('[WebView] 加载失败: $uri, code=$code, message=$message');
              },
              onConsoleMessage: (controller, message) {
                print('[WebView] 控制台消息: ${message.message}');
              },
              onProgressChanged: (controller, newProgress) {
                setState(() {
                  progress = newProgress;
                });
              },
            ),
          if (isLoading) Center(child: CircularProgressIndicator()),
          if (progress < 100)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: progress / 100.0,
                minHeight: 2,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ),
        ],
      ),
    );
  }
}
