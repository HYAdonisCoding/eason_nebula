import 'package:eason_nebula/ui/CommentPage.dart';
import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailNotePage extends StatefulWidget {
  final Map<String, dynamic> item;
  const DetailNotePage({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailNotePage> createState() => _DetailNotePageState();
}

class _DetailNotePageState extends State<DetailNotePage> {
  bool isLoading = true;
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    // 初始化 WebViewController 并加载笔记详情
    final item = widget.item;
    String url =
        'https://www.xiaohongshu.com/explore/${item['id']}?xsec_token=${item['xsec_token']}&xsec_source=pc_feed&source=404';
    print('请求 URL: $url');
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36',
      )
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse(url),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36',
          'Referer': 'https://www.xiaohongshu.com/',
          'Origin': 'https://www.xiaohongshu.com',
          'Cookie':
              'abRequestId=6a612ccd-8dd1-5d96-b068-f995c47883ed; webBuild=4.72.0; a1=197e7dfb5505afoh7k37royn5a1imecpv6rvgvsdq30000416866; webId=bec44738d495873c31bc07cf63b3f9dc; web_session=030037af5fd776122d784fc5142f4a90de8783; gid=yjWdWfifS4hJyjWdWfiD2KhM2820ilxWTqWFFfAlvI20yhq836dSUk8884yKYKK8qJ2ffY8j; xsecappid=xhs-pc-web; unread={%22ub%22:%226865c86e000000000b02e1f5%22%2C%22ue%22:%22684d630f000000000303d32f%22%2C%22uc%22:30}; acw_tc=0a00d62f17519598653133836e8b94041771512758f84d68bf421e68e89262; loadts=1751959865647; websectiga=f47eda31ec99545da40c2f731f0630efd2b0959e1dd10d5fedac3dce0bd1e04d; sec_poison_id=4949bfc9-a5de-4bd1-821f-953141b81366',
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasonAppBar(
        title: '笔记详情',
        menuItems: [
          EasonMenuItem(
            title: '评论详情',
            icon: Icons.refresh,
            iconColor: Colors.blueAccent,
            onTap: () {
              // 跳转到评论页面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return CommentPage(item: widget.item);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
