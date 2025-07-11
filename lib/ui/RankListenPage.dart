import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RankListenPage extends EasonBasePage {
  const RankListenPage({Key? key}) : super(key: key);

  @override
  String get title => '排行榜';

  @override
  State<RankListenPage> createState() => _RankListenPageState();
}

class _RankListenPageState extends BasePageState<RankListenPage> {
  List rankList = []; // 排行榜数据
  int _selectedIndex = 0; // 当前选中的榜单索引

  @override
  void initState() {
    super.initState();
    loadData()
        .then((data) {
          debugPrint('加载成功: ${data.length} 条排行榜数据');
          setState(() {
            rankList = data;
          });
        })
        .catchError((error) {
          debugPrint('加载失败: $error');
          setState(() {
            rankList = [];
          });
        });
  }

  /// 异步加载排行榜数据
  Future<List> loadData() async {
    try {
      final response = await http
          .post(
            Uri.parse(
              'https://mock.mengxuegu.com/mock/684fd50e1fd2b25100380d96/v1.0/rank.do',
            ),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded['data'];
        if (data == null || data['rankList'] == null) {
          throw Exception('返回数据不完整');
        }
        final rankList = data['rankList'] as List<dynamic>;
        return rankList;
      } else {
        throw Exception('网络请求失败，状态码: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      throw Exception('加载超时，请稍后重试');
    } catch (e) {
      throw Exception('加载数据失败: $e');
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    if (rankList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final albums = (rankList[_selectedIndex]['albums'] ?? []) as List<dynamic>;

    return Column(
      children: [
        _buildSegmentButtons(),
        const SizedBox(height: 12),
        Expanded(child: _buildAlbumList(albums)),
      ],
    );
  }

  /// 构建顶部分段按钮，根据 rankList 中的 title
  Widget _buildSegmentButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(rankList.length, (index) {
          final title = rankList[index]['title'] ?? '';
          final isSelected = index == _selectedIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(title),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }

  /// 构建专辑列表
  Widget _buildAlbumList(List albums) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        final coverUrl = 'https://imagev2.xmcdn.com/${album['cover']}';
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: coverUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        album['albumTitle'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text('主播：${album['anchorName'] ?? ''}'),
                      const SizedBox(height: 6),
                      Text(
                        '更新：${album['lastUpdateTrack'] ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        album['description'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
