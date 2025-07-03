import 'package:flutter/material.dart';
import '../utils/EasonAppBar.dart';
import '../utils/EasonBottomAppBar.dart';
import '../utils/EasonCupertinoTabBar.dart';
import '../utils/EasonTabBar.dart';
import 'DiscoverPageContent.dart';
import 'HomePageContent.dart';
import 'ProfilePageContent.dart';
import 'LoginPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  int _tabIndex = 0;
  double size = 40;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _controller!.forward();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 根据当前tab动态设置标题和菜单
    String title;
    List<EasonMenuItem> menuItems;
    switch (_tabIndex) {
      case 0:
        title = '首页';
        menuItems = [
          EasonMenuItem(
            title: '扫一扫',
            icon: Icons.qr_code_scanner,
            iconColor: Colors.deepPurple,
            onTap: () => print('扫一扫'),
          ),
        ];
        break;
      case 1:
        title = '发现';
        menuItems = [
          EasonMenuItem(
            title: '热门',
            icon: Icons.local_fire_department,
            iconColor: Colors.orange,
            onTap: () => print('热门'),
          ),
        ];
        break;
      case 2:
        title = '我的';
        menuItems = [
          EasonMenuItem(
            title: '登录',
            icon: Icons.login_outlined,
            iconColor: Colors.blue,
            onTap: () {
              print('登录');
              // 这里可以跳转到登录页面 LoginPage
              Navigator.pushNamed(context, '/login');
            },
          ),
        ];
        break;
      default:
        title = '首页';
        menuItems = [];
    }
    return Scaffold(
      appBar: EasonAppBar(title: title, showBack: false, menuItems: menuItems),
      body: IndexedStack(
        index: _tabIndex,
        children: [
          HomePageContent(), // 首页内容
          DiscoverPageContent(), // 发现页内容
          ProfilePageContent(), // 我的页内容
        ],
      ),
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Icon(Icons.home, size: size, color: Colors.blue),
      //           SizedBox(width: 20),
      //           Text('Welcome', style: TextStyle(fontSize: 24)),
      //           IconButton(
      //             onPressed: _incrementCounter,
      //             icon: Icon(Icons.add),
      //             splashColor: Colors.teal,
      //             highlightColor: Colors.pink,
      //             disabledColor: Colors.grey,
      //             color: Colors.orange,
      //             iconSize: size,
      //           ),
      //           ImageIcon(
      //             AssetImage('lib/assets/images/magnifyingglass.circle.png'),
      //             size: size,
      //             color: Colors.green,
      //           ),
      //           Icon(Icons.card_giftcard, size: size, color: Colors.red),
      //           // 使用unicode字符
      //           Text(
      //             '\u{1F4A1}', // 灯泡图标
      //             style: TextStyle(fontSize: size, color: Colors.yellow),
      //           ),
      //         ],
      //       ),
      //       SizedBox(height: 20),
      //       AnimatedIcon(
      //         icon: AnimatedIcons.menu_arrow,
      //         progress: _controller,
      //         semanticLabel: 'Show menu',
      //       ),

      //       Text('You have pushed the button this many times:'),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headlineMedium,
      //       ),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: EasonCupertinoTabBar(
        items: [
          EasonCupertinoTabBarItem(label: '首页', icon: Icons.home_rounded),
          EasonCupertinoTabBarItem(label: '发现', icon: Icons.explore_rounded),
          EasonCupertinoTabBarItem(label: '我的', icon: Icons.person_rounded),
        ],
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
        indicatorGradient: [
          Colors.blueAccent,
          Colors.purpleAccent,
          Colors.cyan,
        ],
      ),
      // EasonBottomAppBar(
      //   // 可不传，默认主页+设置
      //   leftItems: [
      //     EasonBottomBarItem(
      //       icon: Icons.explore,
      //       iconColor: Colors.orange,
      //       onTap: () => print('发现'),
      //     ),
      //     EasonBottomBarItem(
      //       icon: Icons.ac_unit,
      //       iconColor: Colors.pinkAccent,
      //       onTap: () => print('更多'),
      //     ),
      //   ],
      //   onRightAction: () {
      //     // 右侧按钮点击
      //     print('右侧加号');
      //   },
      //   // rightWidget: ... // 也可自定义右侧内容
      // ),
    );
  }
}
