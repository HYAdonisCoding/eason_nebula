import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/ui/DetailNotePage.dart';
import 'package:eason_nebula/ui/ScanCodePage.dart';
import 'package:eason_nebula/ui/TemplePage.dart';
import 'package:eason_nebula/utils/CookieUtils.dart';
import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:eason_nebula/utils/EasonGlobal.dart';
import 'package:eason_nebula/utils/EasonToolBar.dart';
import 'package:eason_nebula/utils/PopupUtils.dart';
import 'package:extended_image/extended_image.dart';

import 'CommentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class DiscoverPageContent extends EasonBasePage {
  const DiscoverPageContent({Key? key}) : super(key: key);

  @override
  String get title => '发现';

  @override
  List<EasonMenuItem> menuItems(BuildContext context) => [
    EasonMenuItem(
      title: '热门',
      icon: Icons.local_fire_department,
      iconColor: Colors.orange,
      onTap: () => print('热门'),
    ),
    EasonMenuItem(
      title: '刷新',
      icon: Icons.refresh_sharp,
      iconColor: Colors.orange,
      onTap: () => _loadRedNote(),
    ),
  ];

  @override
  bool get showBack => false;

  @override
  State<DiscoverPageContent> createState() => _DiscoverPageContentState();

  @override
  bool get useCustomAppBar => true;

  /// 加载热搜数据
  Future<void> _loadRedNote() async {
    // This will be overridden in state, but we need this here to satisfy the menuItems callback.
  }
}

class _DiscoverPageContentState extends BasePageState<DiscoverPageContent> {
  List<dynamic> _hotList = [];

  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _cameraKey = GlobalKey();
  String? _cookie;

  @override
  void initState() {
    super.initState();
    _loadRedNote(); // 调用加载方法
    _loadCookie();
  }

  Future<void> _loadCookie() async {
    final c = await CookieUtils.loadAndGetCookie();
    setState(() {
      _cookie = c;
    });
  }

  /// 加载热搜数据
  /// 这里假设热搜数据存储在 lib/assets/rednote.json 中
  Future<void> _loadRedNote() async {
    try {
      final String jsonStr = await rootBundle.loadString(
        'lib/assets/data/rednote.json',
      );
      final Map<String, dynamic> decoded = json.decode(jsonStr);
      final List<dynamic> rawList = decoded['data']?['items'] ?? [];
      // print('共加载 ${rawList.length} 条记录');
      // 过滤非法项并确保 index 可比较
      final List<dynamic> filteredList = rawList.where((item) {
        final noteCard = item['note_card'];
        return noteCard != null && noteCard['display_title'] != null;
      }).toList();

      setState(() {
        _hotList = filteredList;
        // 若需调试，可用 debugPrint('共加载 ${filteredList.length} 条记录');
        // print('共加载 ${filteredList.length} 条记录');
      });
    } catch (e) {
      debugPrint('加载热搜失败: $e');
      setState(() {
        _hotList = [];
      });
    }
  }

  // 热门话题数据
  final List<Map<String, Object>> hotTopics = [
    {
      "title": "汽车",
      "icon": Icons.local_fire_department,
      "color": Colors.redAccent,
      "jump": "CarPage",
    },
    {
      "title": "汽车DataTable",
      "icon": Icons.local_fire_department,
      "color": Colors.redAccent,
      "jump": "CarDataTablePage",
    },
    {
      "title": "旅游",
      "icon": Icons.star,
      "color": Colors.blueAccent,
      "jump": "TravelPage",
    },
    {
      "title": "Paginated",
      "icon": Icons.share,
      "color": Colors.orangeAccent,
      "jump": "PaginatedDataTablePage",
    },
    {
      "title": "DataTable",
      "icon": Icons.notifications,
      "color": Colors.lightBlueAccent,
      "jump": "DataTablePage",
    },
    {
      "title": "关于",
      "icon": Icons.account_balance,
      "color": Colors.tealAccent,
      "jump": "aboutPage",
    },
    {
      "title": "饭费",
      "icon": Icons.comment,
      "color": Colors.purpleAccent,
      "jump": "SimpleTablePage",
    },
    {"title": "话题三", "icon": Icons.thumb_up, "color": Colors.greenAccent},
    {"title": "话题四", "icon": Icons.favorite, "color": Colors.pinkAccent},
  ];

  Widget _buildRecommendationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '为你推荐',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
          children: _hotList
              .map((item) => DiscoverGridItemCard(item, cookie: _cookie))
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        EasonToolBar(
          icons: [Icons.menu_rounded, Icons.camera_enhance_outlined],
          keys: {0: _menuKey, 1: _cameraKey},
          onTap: (index) {
            debugPrint('点击了第 $index 个图标');
            if (index == 0) {
              // 打开侧边栏
              PopupUtils.showCustomPopup(
                context,
                anchorKey: _menuKey,
                items: [
                  EasonMenuItem(
                    icon: Icons.menu_rounded,
                    iconColor: Colors.blue,
                    title: '侧边栏',
                    onTap: () {
                      debugPrint('点击了侧边栏');
                    },
                  ),
                  EasonMenuItem(
                    icon: Icons.camera_enhance_outlined,
                    iconColor: Colors.blue,
                    title: '相机',
                    onTap: () {
                      debugPrint('点击了相机');
                    },
                  ),
                ],
              );
            } else if (index == 1) {
              // 打开相机
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => ScanCodePage()),
              );
            }
          },
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadRedNote,
            child: ListView(
              padding: EdgeInsets.all(24),
              // background color transparent or theme's scaffoldBackgroundColor by default
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: theme.cardColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: theme.brightness == Brightness.dark
                          ? Colors.deepPurpleAccent.shade100
                          : Colors.deepPurple,
                      size: 32,
                    ),
                    title: Text(
                      '全网热搜',
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '看看大家都在关注什么',
                      style: theme.textTheme.bodyMedium,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18, color: theme.iconTheme.color),
                    onTap: () {},
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  '热门话题',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                _HotTopicGridSection(hotTopics: hotTopics),
                SizedBox(height: 32),
                _buildRecommendationSection(context),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DiscoverGridItemCard extends StatelessWidget {
  final dynamic item;
  final String? cookie;
  const DiscoverGridItemCard(this.item, {this.cookie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        color: theme.cardColor,
        child: InkWell(
          onTap: () {
            print('点击了：$title');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return DetailNotePage(item: item);
                },
              ),
            );
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
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[200],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: coverUrl.isNotEmpty && cookie != null
                      ? ExtendedImage.network(
                          coverUrl,
                          headers: {
                            'User-Agent':
                                'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
                            'Referer': 'https://www.xiaohongshu.com/',
                            'Cookie': cookie!,
                          },
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadStateChanged: (state) {
                            switch (state.extendedImageLoadState) {
                              case LoadState.loading:
                                return Center(
                                  child: Image.asset(
                                    'lib/assets/images/loading_64.png',
                                    fit: BoxFit.cover,
                                  ),
                                );
                              case LoadState.failed:
                                return Container(
                                  color: theme.brightness == Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.grey[300],
                                );
                              case LoadState.completed:
                                return null;
                            }
                          },
                        )
                      : Container(
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[300],
                        ),
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: theme.textTheme.bodyMedium?.color,
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
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
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

class _HotTopicGridSection extends StatelessWidget {
  final List<Map<String, Object>> hotTopics;

  const _HotTopicGridSection({required this.hotTopics});

  double _calculateGridHeight(
    int itemCount,
    int crossAxisCount,
    double itemHeight,
    double mainAxisSpacing,
  ) {
    final rowCount = (itemCount / crossAxisCount).ceil();
    return rowCount * itemHeight + (rowCount - 1) * mainAxisSpacing;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = 48; // 24*2
    final double gridSpacing = 24; // 12*2
    final int crossAxisCount = 3;

    final double itemWidth =
        (screenWidth - horizontalPadding - gridSpacing) / crossAxisCount;
    final double itemHeight = itemWidth / 3.4;
    final double mainAxisSpacing = 8;
    return Container(
      color: theme.brightness == Brightness.dark
          ? Colors.transparent
          : Colors.greenAccent.withOpacity(0.1),
      height: _calculateGridHeight(
        hotTopics.length,
        crossAxisCount,
        itemHeight,
        mainAxisSpacing,
      ),
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 8,
        childAspectRatio: 3.4,
        children: hotTopics.map((topic) {
          final Color topicColor = topic['color'] as Color;
          final Color iconColor = theme.brightness == Brightness.dark
              ? topicColor.withOpacity(0.8)
              : topicColor;
          return InkWell(
            onTap: () {
              final jumpRoute = topic['jump'] as String?;
              if (jumpRoute != null && jumpRoute.isNotEmpty) {
                Navigator.pushNamed(context, '/$jumpRoute');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TemplePage()),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.transparent
                    : topicColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    topic['icon'] as IconData,
                    color: iconColor,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      topic['title'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: iconColor,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
