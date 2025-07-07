import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import '../utils/EasonMessenger.dart';
import 'SettingPage.dart';
import 'HotDetailPage.dart';

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
        'lib/assets/hotsearch.json',
      );
      final List<dynamic> list = json.decode(jsonStr);
      list.sort(
        (a, b) => int.parse(a['index']).compareTo(int.parse(b['index'])),
      );
      setState(() {
        _hotList = list;
        print(list.length);
      });
    } catch (e) {
      print('加载热搜失败: $e');
      setState(() {
        _hotList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(24),
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
        SizedBox(height: 24),
        Text(
          '快捷功能',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _QuickAction(icon: Icons.qr_code_scanner, label: '扫一扫'),
            _QuickAction(icon: Icons.message, label: '消息'),
            _QuickAction(
              icon: Icons.settings,
              label: '设置',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingPage()),
                );
              },
            ),
            _QuickAction(icon: Icons.star, label: '收藏'),
          ],
        ),
        SizedBox(height: 32),
        Text(
          '热搜榜',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        if (_hotList.isEmpty)
          Center(child: CircularProgressIndicator())
        else ...[
          // 第0个特殊大卡片
          _buildTopCard(_hotList[0]),
          SizedBox(height: 18),
          // 1、2、3 金银铜
          ...List.generate(
            _hotList.length > 4 ? 3 : _hotList.length - 1,
            (i) => _buildMedalCard(_hotList[i + 1], i + 1),
          ),
          // 其余普通卡片
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.15),
            child: Icon(icon, color: Colors.blueAccent),
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
