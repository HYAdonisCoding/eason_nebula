import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class BaseAnimation extends EasonBasePage {
  const BaseAnimation({Key? key}) : super(key: key);

  @override
  String get title => 'BaseAnimation';

  @override
  State<BaseAnimation> createState() => _BaseAnimationState();
}

class _BaseAnimationState extends BasePageState<BaseAnimation> {
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Text(
        'BaseAnimation Content',
        style: TextStyle(fontSize: 24, color: Colors.blue),
      ),
    );
  }
}