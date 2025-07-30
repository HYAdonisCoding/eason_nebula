import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class HeroAnimation extends EasonBasePage {
  const HeroAnimation({Key? key}) : super(key: key);

  @override
  String get title => 'HeroAnimation';

  @override
  State<HeroAnimation> createState() => _HeroAnimationState();
}

class _HeroAnimationState extends BasePageState<HeroAnimation> {
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Text(
        'HeroAnimation Content',
        style: TextStyle(fontSize: 24, color: Colors.blue),
      ),
    );
  }
}