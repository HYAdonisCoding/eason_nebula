import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class StaggeredAnimation extends EasonBasePage {
  const StaggeredAnimation({Key? key}) : super(key: key);

  @override
  String get title => 'StaggeredAnimation';

  @override
  State<StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends BasePageState<StaggeredAnimation> {
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Text(
        'StaggeredAnimation Content',
        style: TextStyle(fontSize: 24, color: Colors.blue),
      ),
    );
  }
}