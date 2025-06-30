import 'package:eason_nebula/main.dart';
import 'package:flutter/material.dart';

import '../utils/HighlightText.dart';

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
                    child: Image.network(imageUrl),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: HighlightText(
                      text: title,
                      highlights: ['荷叶', '小青蛙', '小水珠'],
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
                      },
                    ),
                  ),
                  ElevatedButton(onPressed: _changeTitle, child: Text('点击内容')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
