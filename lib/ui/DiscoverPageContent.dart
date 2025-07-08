import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class DiscoverPageContent extends StatefulWidget {
  @override
  _DiscoverPageContentState createState() => _DiscoverPageContentState();
}

class _DiscoverPageContentState extends State<DiscoverPageContent> {
  List<dynamic> _hotList = [];

  @override
  void initState() {
    super.initState();
    _loadRedNote(); // 调用加载方法
  }

  /// 加载热搜数据
  /// 这里假设热搜数据存储在 lib/assets/rednote.json 中
  Future<void> _loadRedNote() async {
    try {
      final String jsonStr = await rootBundle.loadString(
        'lib/assets/rednote.json',
      );
      final Map<String, dynamic> decoded = json.decode(jsonStr);
      final List<dynamic> rawList = decoded['data']?['items'] ?? [];
      print('共加载 ${rawList.length} 条记录');
      // 过滤非法项并确保 index 可比较
      final List<dynamic> filteredList = rawList.where((item) {
        final noteCard = item['note_card'];
        return noteCard != null && noteCard['display_title'] != null;
      }).toList();

      setState(() {
        _hotList = filteredList;
        // 若需调试，可用 debugPrint('共加载 ${filteredList.length} 条记录');
        print('共加载 ${filteredList.length} 条记录');
      });
    } catch (e) {
      debugPrint('加载热搜失败: $e');
      setState(() {
        _hotList = [];
      });
    }
  }

  Widget _buildRecommendationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '为你推荐',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
          children: _hotList.map((item) => DiscoverGridItemCard(item)).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadRedNote,
      child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text(
            '发现',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(Icons.search, color: Colors.deepPurple, size: 32),
              title: Text('全网热搜'),
              subtitle: Text('看看大家都在关注什么'),
              trailing: Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {},
            ),
          ),
          SizedBox(height: 24),

          Text(
            '热门话题',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              6,
              (i) => Chip(
                label: Text('话题 ${i + 1}'),
                backgroundColor: Colors.purpleAccent.withOpacity(0.1),
                avatar: Icon(
                  Icons.local_fire_department,
                  color: Colors.purpleAccent,
                  size: 18,
                ),
              ),
            ),
          ),
          SizedBox(height: 32),

          _buildRecommendationSection(),
        ],
      ),
    );
  }
}

class DiscoverGridItemCard extends StatelessWidget {
  final dynamic item;
  const DiscoverGridItemCard(this.item);

  @override
  Widget build(BuildContext context) {
    final note = item['note_card'];
    final title = note['display_title'] ?? '';
    final author = note['user']['nickname'] ?? '';
    final avatarUrl = note['user']['avatar'] ?? '';
    final coverUrl = note['cover']['url_default'] ?? '';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: InkWell(
          onTap: () {
            print('点击了：$title');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: Colors.grey[200],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: coverUrl.isNotEmpty
                      ? FadeInImage.assetNetwork(
                          placeholder: 'lib/assets/images/placeholder.png',
                          image: coverUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Container(color: Colors.grey[300]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl),
                          radius: 10,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
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
      ),
    );
  }
}
