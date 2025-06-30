import 'package:eason_nebula/main.dart';
import 'package:flutter/material.dart';

import '../utils/HighlightText.dart';
import '../utils/EasonButton.dart';
import '../utils/EasonImage.dart';

class Showapp extends StatelessWidget {
  const Showapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '夏天',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: '夏天'),
    );
  }
}

//
class ShowAppPage extends StatefulWidget {
  const ShowAppPage({super.key});

  @override
  State<ShowAppPage> createState() => _ShowAppPageState();
}

class _ShowAppPageState extends State<ShowAppPage> {
  String title = '夏天到了,池塘上长满了圆圆的绿绿的荷叶,小水珠';
  String boldText = '荷叶';
  String imageUrl =
      'https://pic.chaopx.com/chao_origin_pic/20/24/04/ae341fd20234002307896efea6410730.png';

  bool change = false;

  void _changeTitle() {
    setState(() {
      // 切换标题
      // 如果change为true,则标题不包含小青蛙,否则包含小
      if (change) {
        title = '夏天到了,池塘上长满了圆圆的绿绿的荷叶,小水珠';
        imageUrl =
            'https://pic.chaopx.com/chao_origin_pic/20/24/04/ae341fd20234002307896efea6410730.png';
      } else {
        title = '夏天到了,池塘上长满了圆圆的绿绿的荷叶,小水珠,小青蛙';
        imageUrl =
            'https://qcloud.dpfile.com/pc/0D6vlNLo2IgS8rZ-vTygFkC-Onzrl95KdPlL9Fk3ckZhCNhCNE_CUFkHbnIxoUZl.jpg';
      }
      change = !change;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('夏天')),
      body: Column(
        children: [
          // 横线分割
          Divider(height: 1, thickness: 1, color: Colors.grey[300]),
          // 其余内容
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: EasonImage(
                      src: imageUrl,
                      height: 300,
                      borderRadius: 12,
                      placeholder: 'lib/assets/images/feilong_1.jpeg',
                      onTap: (e) => print('点击了图片: $e'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: HighlightText(
                      text: title,
                      highlights: ['荷叶', '小青蛙', '小水珠', '夏天'],
                      style: TextStyle(fontSize: 20, color: Colors.green),
                      highlightStyles: {
                        '荷叶': TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        '小青蛙': TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        '小水珠': TextStyle(
                          fontSize: 20,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                        '夏天': TextStyle(
                          fontSize: 30,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      },
                      highlightTaps: {
                        '荷叶': () => print('点击了荷叶'),
                        '小青蛙': () => print('点击了小青蛙'),
                        '夏天': () => print('点击了夏天'),
                        // 其它词不传则无点击
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: EasonButton(
                            text: '取消',
                            onPressed: _changeTitle,
                            color: Colors.lightGreenAccent,
                            textColor: Colors.white,
                            borderRadius: 8,
                            fontSize: 20,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            enabled: true,
                            border: BorderSide(color: Colors.blue, width: 1.0),
                          ),
                        ),
                        SizedBox(width: 16), // 按钮间距
                        Expanded(
                          child: EasonButton(
                            text: '切换标题',
                            onPressed: _changeTitle,
                            color: Colors.pinkAccent,
                            textColor: Colors.white,
                            borderRadius: 8,
                            fontSize: 20,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            enabled: true,
                            border: BorderSide(color: Colors.blue, width: 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
