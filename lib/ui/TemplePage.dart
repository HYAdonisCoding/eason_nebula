import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class TemplePage extends EasonBasePage {
  const TemplePage({Key? key}) : super(key: key);

  @override
  String get title => 'TemplePage';

  @override
  State<TemplePage> createState() => _TemplePageState();
}

class _TemplePageState extends BasePageState<TemplePage> {
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Text(
        'TemplePage Content',
        style: TextStyle(fontSize: 24, color: Colors.blue),
      ),
    );
  }
}