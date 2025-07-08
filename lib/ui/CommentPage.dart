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
              'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
          'Referer': 'https://www.xiaohongshu.com/',
          'Origin': 'https://www.xiaohongshu.com',
          'Cookie':
              'abRequestId=6a612ccd-8dd1-5d96-b068-f995c47883ed; webBuild=4.72.0; a1=197e7dfb5505afoh7k37royn5a1imecpv6rvgvsdq30000416866; webId=bec44738d495873c31bc07cf63b3f9dc; web_session=030037af5fd776122d784fc5142f4a90de8783; gid=yjWdWfifS4hJyjWdWfiD2KhM2820ilxWTqWFFfAlvI20yhq836dSUk8884yKYKK8qJ2ffY8j; xsecappid=xhs-pc-web; unread={%22ub%22:%226865c86e000000000b02e1f5%22%2C%22ue%22:%22684d630f000000000303d32f%22%2C%22uc%22:30}; loadts=1751944226570; websectiga=634d3ad75ffb42a2ade2c5e1705a73c845837578aeb31ba0e442d75c648da36a; acw_tc=0a0bb37217519564009478707e26c3e1fceffddfeeeba3681ad194b67c542a', // 如果你用到了该请求头，可补上
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
