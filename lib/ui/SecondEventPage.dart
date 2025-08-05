import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/utils/event_bus_utitls.dart';
import 'package:flutter/material.dart';

class SecondEventPage extends EasonBasePage {
  const SecondEventPage({Key? key}) : super(key: key);

  @override
  String get title => 'SecondEventPage';

  @override
  State<SecondEventPage> createState() => _SecondEventPageState();
}

class _SecondEventPageState extends BasePageState<SecondEventPage> {
  var name = '初始数据';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 注册和监听发送过来的UserEvent事件，数据
    eventBus.on<UserEvent>().listen((event) {
      // 处理UserEvent事件
      print('UserEvent received in SecondEventPage: ${event.name}');
      // 可以在这里处理事件，或者发送新的事件
      // eventBus.fire(UserEvent(name: 'New Name from SecondEventPage'));
      setState(() {
        name = event.name;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('$name', style: TextStyle(fontSize: 24, color: Colors.blue)),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '请输入事件内容',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: '点击发送事件',
        child: FloatingActionButton(
          onPressed: () {
            final inputText = _controller.text.trim();
            if (inputText.isNotEmpty) {
              eventBus.fire(UserEvent(inputText));
            }
          },
          child: Icon(Icons.send),
        ),
      ),
    );
  }
}
