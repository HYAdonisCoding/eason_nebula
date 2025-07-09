import 'dart:convert';
import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eason_nebula/utils/EasonEmoji.dart'; // 确保你有这个文件，里面包含了表情代码和对应的图片 URL

class CommentPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const CommentPage({Key? key, required this.item}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<dynamic> _comments = [];
  bool _isLoading = false;

  late Future<Map<String, String>> _emojiMapFuture;

  // 解析评论内容，将表情代码替换为图片
  Future<List<InlineSpan>> parseContentWithEmojis(
    String content,
    Map<String, String> emojiMap,
  ) async {
    if (content.isEmpty) return [TextSpan(text: content)];
    final regex = RegExp(r'\[[^\[\]]+\]');
    final matches = regex.allMatches(content);
    if (matches.isEmpty) return [TextSpan(text: content)];

    List<InlineSpan> spans = [];
    int lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: content.substring(lastEnd, match.start)));
      }

      final key = match.group(0)!;
      final emojiUrl = emojiMap[key];

      if (emojiUrl != null) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Image.network(emojiUrl, width: 20, height: 20),
          ),
        );
      } else {
        spans.add(TextSpan(text: key));
      }

      lastEnd = match.end;
    }

    if (lastEnd < content.length) {
      spans.add(TextSpan(text: content.substring(lastEnd)));
    }

    return spans;
  }

  @override
  void initState() {
    super.initState();
    _emojiMapFuture = EasonEmoji.loadEmojiMap();
    fetchComments();
  }

  Future<void> fetchComments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final item = widget.item;
      print('加载评论: ${item['note_card']['display_title']}');
      // 这里使用了一个示例 URL，请根据实际情况替换
      String url =
          'https://edith.xiaohongshu.com/api/sns/web/v2/comment/page?note_id=${item['id']}&cursor=&top_comment_id=&image_formats=jpg,webp,avif&xsec_token=${item['xsec_token']}';
      print('请求 URL: $url');
      // 使用网络请求获取评论数据
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36',
          'Referer': 'https://www.xiaohongshu.com/',
          'Origin': 'https://www.xiaohongshu.com',
          'Cookie':
              'abRequestId=d56346ab-b128-53f8-90ae-02df68a79a68; webBuild=4.72.0; a1=197ecc73b2856s3u00rp2wazu32g4e17hcpphxwwg30000136672; webId=ad7987f65042c5036d4ff529eea08fdd; gid=yjWdSSW4YYxKyjWdSSWqDSCEJY2KMq788FUJUEkE0u7qJUq8k4dyWx888yqKKWJ84Ji0WY4q; unread={%22ub%22:%22684aacd50000000021001688%22%2C%22ue%22:%2268626516000000002201ebb2%22%2C%22uc%22:28}; web_session=040069b234715130a9c6f781583a4b924a0f4f; customer-sso-sid=68c517524892465105587085leya9gmbsqjsixiq; x-user-id-creator.xiaohongshu.com=63403219000000001802f990; customerClientId=783964759566655; access-token-creator.xiaohongshu.com=customer.creator.AT-68c517524892465105587086bht4muukufw7kuzn; galaxy_creator_session_id=nvs56xaFtWMTKOxgSoVOrMbbsa7fDCdqSwzQ; galaxy.creator.beaker.session.id=1752025556325091492911; loadts=1752030047500; acw_tc=0ad585a917520300478796746e70204a62739238767b7fad7045862d63e401; xsecappid=ugc; websectiga=10f9a40ba454a07755a08f27ef8194c53637eba4551cf9751c009d9afb564467; sec_poison_id=3e4cba17-abfb-4045-9d3a-9afab5d31404', // 如果你用到了该请求头，可补上
          // 你也可以加上 Cookie/X-Sec-Token/X-Timestamp 等字段（如果服务端验证）
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // 取data中的comments字段
          _comments = data['data']['comments'] ?? [];
          // print('加载评论成功: ${_comments} ');
          if (_comments.isEmpty) {
            debugPrint('没有评论数据');
          } else {
            debugPrint('加载评论成功: ${_comments.length} 条');
          }
        });
      } else {
        debugPrint('加载失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('请求异常: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasonAppBar(
        title: widget.item['note_card']['display_title'] ?? '评论',
        showBack: true,
        menuItems: [
          EasonMenuItem(
            title: '刷新',
            icon: Icons.refresh,
            iconColor: Colors.blueAccent,
            onTap: () {
              fetchComments();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchComments,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(
                              comment['user_info']?['image'] ?? '',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment['user_info']?['nickname'] ?? '匿名用户',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 6),
                                FutureBuilder<Map<String, String>>(
                                  future: _emojiMapFuture,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text(comment['content'] ?? '');
                                    }
                                    return FutureBuilder<List<InlineSpan>>(
                                      future: parseContentWithEmojis(
                                        comment['content'] ?? '',
                                        snapshot.data!,
                                      ),
                                      builder: (context, emojiSnapshot) {
                                        if (!emojiSnapshot.hasData) {
                                          return Text(comment['content'] ?? '');
                                        }
                                        return RichText(
                                          text: TextSpan(
                                            children: emojiSnapshot.data!,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              height: 1.4,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.thumb_up_alt_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${comment['like_count'] ?? 0}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
