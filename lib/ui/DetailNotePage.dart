import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/ui/CommentPage.dart';
import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:eason_nebula/utils/EasonGlobal.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  Widget buildContent(BuildContext context) {
    return _DetailNoteContent(item: item);
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
              'abRequestId=d56346ab-b128-53f8-90ae-02df68a79a68; webBuild=4.72.0; a1=197ecc73b2856s3u00rp2wazu32g4e17hcpphxwwg30000136672; webId=ad7987f65042c5036d4ff529eea08fdd; gid=yjWdSSW4YYxKyjWdSSWqDSCEJY2KMq788FUJUEkE0u7qJUq8k4dyWx888yqKKWJ84Ji0WY4q; unread={%22ub%22:%22684aacd50000000021001688%22%2C%22ue%22:%2268626516000000002201ebb2%22%2C%22uc%22:28}; web_session=040069b234715130a9c6f781583a4b924a0f4f; customer-sso-sid=68c517524892465105587085leya9gmbsqjsixiq; x-user-id-creator.xiaohongshu.com=63403219000000001802f990; customerClientId=783964759566655; access-token-creator.xiaohongshu.com=customer.creator.AT-68c517524892465105587086bht4muukufw7kuzn; galaxy_creator_session_id=nvs56xaFtWMTKOxgSoVOrMbbsa7fDCdqSwzQ; galaxy.creator.beaker.session.id=1752025556325091492911; loadts=1752030047500; acw_tc=0ad585a917520300478796746e70204a62739238767b7fad7045862d63e401; xsecappid=ugc; websectiga=10f9a40ba454a07755a08f27ef8194c53637eba4551cf9751c009d9afb564467; sec_poison_id=3e4cba17-abfb-4045-9d3a-9afab5d31404',
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
