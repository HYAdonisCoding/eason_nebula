import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/ui/SecondEventPage.dart';
import 'package:eason_nebula/utils/event_bus_utitls.dart';
import 'package:flutter/material.dart';

class FirstEventPage extends EasonBasePage {
  const FirstEventPage({Key? key}) : super(key: key);

  @override
  String get title => 'FirstEventPage';

  @override
  State<FirstEventPage> createState() => _FirstEventPageState();
}

class _FirstEventPageState extends BasePageState<FirstEventPage> {
  var name = '初始数据';

  @override
  void initState() {
    super.initState();
    // Register the UserEvent listener
    eventBus.on<UserEvent>().listen((event) {
      // Handle UserEvent
      print('UserEvent received in FirstEventPage: ${event.name}');
      setState(() {
        // Update the UI
        name = event.name;
      });
    });
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$name',
          style: TextStyle(fontSize: 24, color: Colors.blue),
        ),
      ),
      floatingActionButton: Tooltip(
        message: '点击发送事件',
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SecondEventPage()),
            );
          },
          child: Icon(Icons.send),
        ),
      ),
    );
  }
}
