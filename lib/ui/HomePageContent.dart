import 'package:eason_nebula/ui/Animations/AnimationPage.dart';
import 'package:eason_nebula/ui/DatabasePage.dart';
import 'package:eason_nebula/ui/FileOperationPage.dart';
import 'package:eason_nebula/ui/GesturePage.dart';
import 'package:eason_nebula/ui/HotPhonePage.dart';
import 'package:eason_nebula/ui/RankListenPage.dart';
import 'package:eason_nebula/ui/ScanCodePage.dart';
import 'package:eason_nebula/ui/WalletPage.dart';
import 'package:eason_nebula/ui/WebSocketPage.dart';
import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:eason_nebula/utils/EasonFaceAuth.dart';
import 'package:eason_nebula/utils/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import '../utils/EasonMessenger.dart';
import 'SettingPage.dart';
import 'HotDetailPage.dart';
import 'dart:math';
import 'package:eason_nebula/utils/EasonGlobal.dart';

class HomePageContent extends StatefulWidget {
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  List<dynamic> _hotList = [];

  @override
  void initState() {
    super.initState();
    _loadHotSearch();
  }

  Future<void> _loadHotSearch() async {
    try {
      final String jsonStr = await rootBundle.loadString(
        'lib/assets/data/hotsearch.json',
      );
      final List<dynamic> list = json.decode(jsonStr);
      list.sort(
        (a, b) => int.parse(a['index']).compareTo(int.parse(b['index'])),
      );
      setState(() {
        _hotList = list;
      });
    } catch (e) {
      debugPrint('加载热搜失败: $e');
      setState(() {
        _hotList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 顶部菜单项
    final menuItems = [
      EasonMenuItem(
        title: '扫一扫',
        icon: Icons.qr_code_scanner,
        iconColor: Colors.deepPurple,
        onTap: () {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => ScanCodePage()),
          );
        },
      ),
    ];

    return Column(
      children: [
        // 自定义导航栏
        EasonAppBar(title: '首页', menuItems: menuItems, showBack: false),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              _buildWelcomeCard(),
              SizedBox(height: 24),
              _buildQuickActions(),
              SizedBox(height: 32),
              _buildHotSearchSection(),
            ],
          ),
        ),
      ],
    );
  }

  /// 欢迎卡片区域，显示欢迎语和用户信息
  Widget _buildWelcomeCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '欢迎回来！',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text('你好，Eason'),
            subtitle: Text('今天也要元气满满哦！'),
            trailing: Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  /// 快捷功能区，包含常用操作入口
  Widget _buildQuickActions() {
    // 快捷功能数据
    final quickActions = [
      {
        'icon': Icons.qr_code_scanner,
        'label': '扫一扫',
        'onTap': () {
          debugPrint('扫一扫');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ScanCodePage()),
          );
        },
      },
      {
        'icon': Icons.radio,
        'label': '排行榜',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RankListenPage()),
          );
        },
      },
      {
        'icon': Icons.message,
        'label': '消息',
        'onTap': () {
          debugPrint('消息');
          // 这里可以添加跳转到消息页面的逻辑
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => WebSocketPage()),
          );
        },
      },
      {
        'icon': Icons.settings,
        'label': '设置',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SettingPage()),
          );
        },
      },
      {
        'icon': Icons.file_copy,
        'label': '文件',
        'onTap': () {
          debugPrint('文件');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FileOperationPage()),
          );
        },
      },
      {
        'icon': Icons.phone_iphone,
        'label': '推荐',
        'onTap': () {
          debugPrint('推荐');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HotPhonePage()),
          );
        },
      },
      {
        'icon': Icons.camera,
        'label': '拍照',
        'onTap': () {
          debugPrint('拍照');
          // 这里可以添加拍照逻辑
        },
      },
      {
        'icon': Icons.gesture,
        'label': '手势',
        'onTap': () {
          debugPrint('手势');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GesturePage()),
          );
        },
      },
      {
        'icon': Icons.dataset_linked_outlined,
        'label': '数据库',
        'onTap': () {
          debugPrint('数据库');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DatabasePage()),
          );
        },
      },
      {
        'icon': Icons.wallet,
        'label': '钱包',
        'onTap': () async {
          debugPrint('钱包');
          LoadingDialog.show(
            context,
            message: '正在进入钱包',
            onDismiss: () async {
              // 在进入钱包前进行面容识别
              final success = await EasonFaceAuth.verifyFace();
              if (success) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WalletPage()),
                );
              } else {
                EasonMessenger.showError(context, message: '面容识别失败，无法进入钱包');
              }
            },
          );
        },
      },
      {
        'icon': Icons.animation,
        'label': '动画',
        'onTap': () {
          debugPrint('动画');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AnimationPage()),
          );
        },
      },
      {
        'icon': Icons.share,
        'label': '分享',
        'onTap': () async {
          debugPrint('分享');
          LoadingDialog.show(
            context,
            message: '',
            onDismiss: () async {
              //
              debugPrint('分享了');
            },
          );
        },
      },
      {
        'icon': Icons.help,
        'label': '帮助',
        'onTap': () async {
          debugPrint('帮助');
          LoadingDialog.show(
            context,
            message: '加载中',
            onDismiss: () async {
              //
              debugPrint('帮助了');
            },
          );
        },
      },
      {'icon': Icons.feedback, 'label': '反馈', 'onTap': () => debugPrint('反馈')},
      {'icon': Icons.info, 'label': '关于', 'onTap': () => debugPrint('关于')},
      {'icon': Icons.bookmark, 'label': '书签', 'onTap': () => debugPrint('书签')},
      {
        'icon': Icons.notifications,
        'label': '通知',
        'onTap': () => debugPrint('通知'),
      },
      {'icon': Icons.language, 'label': '语言', 'onTap': () => debugPrint('语言')},
      {'icon': Icons.palette, 'label': '主题', 'onTap': () => debugPrint('主题')},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '快捷功能',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 12, // 水平间距
          runSpacing: 12, // 垂直间距
          alignment: WrapAlignment.start,
          children: quickActions.map((action) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 24 * 2 - 12 * 4) / 5,
              child: _QuickAction(
                icon: action['icon'] as IconData,
                label: action['label'] as String,
                onTap: action['onTap'] as void Function()?,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 热搜榜区，展示热搜数据
  Widget _buildHotSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '热搜榜',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        if (_hotList.isEmpty)
          /*************  ✨ Windsurf Command ⭐  *************/
          /// Builds the top card widget displaying the most popular hot search item.
          ///
          /// The card has a deep purple background with a high elevation to stand out,
          /// and it includes an icon, title, and heat score of the item.
          /// Tapping the card will launch a URL associated with the item.
          ///
          /// - Parameter item: A dynamic object containing details of the hot search item,
          ///   with expected fields 'card_title' for the title and 'heat_score' for the heat score.
          /*******  70e595b2-991d-4e2b-bbf0-8cf8fccb431c  *******/
          Center(child: CircularProgressIndicator())
        else ...[
          _buildTopCard(_hotList[0]),
          SizedBox(height: 18),
          ...List.generate(
            _hotList.length > 4 ? 3 : _hotList.length - 1,
            (i) => _buildMedalCard(_hotList[i + 1], i + 1),
          ),
          ..._hotList.skip(4).map((item) => _buildNormalCard(item)),
        ],
      ],
    );
  }

  Widget _buildTopCard(dynamic item) {
    return Card(
      elevation: 8,
      color: Colors.deepPurple.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _launchUrl(item),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Row(
            children: [
              Icon(Icons.whatshot, color: Colors.amber, size: 38),
              SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['card_title'] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '热度：${item['heat_score']}',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedalCard(dynamic item, int rank) {
    final medalColors = [
      Colors.amber, // 金
      Color(0xFFC0C0C0), // 银
      Color(0xFFCD7F32), // 铜
    ];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _launchUrl(item),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: medalColors[rank - 1].withOpacity(0.18),
            child: Text(
              '$rank',
              style: TextStyle(
                color: medalColors[rank - 1],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          title: Text(
            item['card_title'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text('热度：${item['heat_score']}'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Widget _buildNormalCard(dynamic item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchUrl(item),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purple.withOpacity(0.13),
            child: Text(
              item['index'],
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            item['card_title'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text('热度：${item['heat_score']}'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  void _launchUrl(dynamic item) async {
    final decoded = Uri.decodeFull(item['linkurl']);
    final uri = Uri.parse(decoded);
    if (await canLaunchUrl(uri)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HotDetailPage(
            title: item['card_title'] ?? '',
            heatScore: item['heat_score'] ?? '',
            linkUrl: item['linkurl'] ?? '',
          ),
        ),
      );
    } else {
      // 可以弹窗提示失败
      EasonMessenger.showError(context, message: "无法打开链接: $item['linkurl']");
    }
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _QuickAction({required this.icon, required this.label, this.onTap});

  // 随机生成柔和的浅色背景色
  Color _randomLightColor() {
    final random = Random(icon.codePoint); // 用图标 codePoint 保证同一图标颜色一致
    return Color.fromARGB(
      255,
      150 + random.nextInt(100),
      150 + random.nextInt(100),
      150 + random.nextInt(100),
    );
  }

  // 随机生成图标颜色
  Color _randomIconColor() {
    final random = Random(icon.codePoint * 2);
    return Color.fromARGB(
      255,
      100 + random.nextInt(155),
      100 + random.nextInt(155),
      100 + random.nextInt(155),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _randomLightColor().withOpacity(0.2);
    final iconColor = _randomIconColor();
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            child: Icon(icon, color: iconColor),
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
