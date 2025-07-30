import 'dart:convert';
import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/utils/CookieUtils.dart';
import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eason_nebula/utils/EasonEmoji.dart'; // 确保你有这个文件，里面包含了表情代码和对应的图片 URL

class CommentPage extends EasonBasePage {
  final Map<String, dynamic> item;
  CommentPage({Key? key, required this.item}) : super(key: key);

  _CommentPageState? _state;

  @override
  String get title => item['note_card']['display_title'] ?? '评论';

  @override
  List<EasonMenuItem> menuItems(BuildContext context) => [
    EasonMenuItem(
      title: '刷新',
      icon: Icons.refresh,
      iconColor: Colors.blueAccent,
      onTap: () => _state?.fetchComments(),
    ),
  ];

  @override
  State<CommentPage> createState() => _CommentPageState();

  @override
  Widget buildContent(BuildContext context) {
    return _CommentPageBody(item: item);
  }
}

class _CommentPageState extends BasePageState<CommentPage> {
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
      debugPrint('加载评论: ${item['note_card']['display_title']}');
      // 这里使用了一个示例 URL，请根据实际情况替换
      String url =
          'https://edith.xiaohongshu.com/api/sns/web/v2/comment/page?note_id=${item['id']}&cursor=&top_comment_id=&image_formats=jpg,webp,avif&xsec_token=${item['xsec_token']}';
      debugPrint('请求 URL: $url');
      // 使用网络请求获取评论数据
      final cookie = await CookieUtils.loadAndGetCookie();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36',
          'Referer': 'https://www.xiaohongshu.com/',
          'Origin': 'https://www.xiaohongshu.com',
          'Cookie': cookie,
          // 你也可以加上 Cookie/X-Sec-Token/X-Timestamp 等字段（如果服务端验证）
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // 取data中的comments字段
          _comments = data['data']['comments'] ?? [];
          debugPrint('返回报文 data: $data');
          // debugPrint('加载评论成功: ${_comments} ');
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
  Widget buildContent(BuildContext context) {
    return RefreshIndicator(
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
    );
  }
}

class _CommentPageBody extends StatelessWidget {
  final Map<String, dynamic> item;
  const _CommentPageBody({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 纯展示控件，由 _CommentPageState 负责状态管理和构建内容
    // 这里可以返回一个空容器或简单的占位符
    return Container();
  }
}
