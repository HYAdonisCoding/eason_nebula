import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class HeroAnimation extends EasonBasePage {
  final String tag;

  const HeroAnimation({Key? key, required this.tag}) : super(key: key);

  @override
  String get title => 'HeroAnimation';

  @override
  State<HeroAnimation> createState() => _HeroAnimationState();
}

class _HeroAnimationState extends BasePageState<HeroAnimation> {
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: widget.tag,
            child: Icon(
              Icons.fire_hydrant_alt_outlined,
              color: Colors.blueAccent,
              size: 100,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Hero 动画是 Flutter 提供的一种特殊动画，用于在不同页面间实现共享元素的平滑过渡。它能让一个元素在页面切换时，以动画的形式从一个位置移动到另一个位置，保持视觉上的连贯性。比如在一个列表页面点击图片，跳转到详情页时，图片以动画形式放大展示，这一效果就可以通过 Hero 动画实现。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
