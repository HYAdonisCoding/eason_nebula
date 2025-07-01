import 'package:flutter/material.dart';
import '../utils/EasonAppBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
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
    return Scaffold(
      appBar: EasonAppBar(
        title: 'Home Page',
        showBack: false, // 首页不显示返回
        menuItems: [
          EasonMenuItem(
            title: '扫一扫',
            icon: Icons.qr_code_scanner,
            iconColor: Colors.deepPurple,
            onTap: () {
              // 你的操作
              // Navigator.of(context).pushNamed('/code_scanner');
              print('扫一扫');
            },
          ),
          EasonMenuItem(
            title: '个人中心',
            icon: Icons.person,
            iconColor: Colors.deepPurple,
            onTap: () {
              // 你的操作
              // Navigator.of(context).pushNamed('/profile');
              print('个人中心');
            },
          ),
          EasonMenuItem(
            title: '退出登录',
            icon: Icons.logout,
            iconColor: Colors.red,
            onTap: () {
              // 你的操作
              print('退出登录');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, size: size, color: Colors.blue),
                SizedBox(width: 20),
                Text('Welcome', style: TextStyle(fontSize: 24)),
                IconButton(
                  onPressed: _incrementCounter,
                  icon: Icon(Icons.add),
                  splashColor: Colors.teal,
                  highlightColor: Colors.pink,
                  disabledColor: Colors.grey,
                  color: Colors.orange,
                  iconSize: size,
                ),
                ImageIcon(
                  AssetImage('lib/assets/images/magnifyingglass.circle.png'),
                  size: size,
                  color: Colors.green,
                ),
                Icon(Icons.card_giftcard, size: size, color: Colors.red),
                // 使用unicode字符
                Text(
                  '\u{1F4A1}', // 灯泡图标
                  style: TextStyle(fontSize: size, color: Colors.yellow),
                ),
              ],
            ),
            SizedBox(height: 20),
            AnimatedIcon(
              icon: AnimatedIcons.menu_arrow,
              progress: _controller,
              semanticLabel: 'Show menu',
            ),

            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
