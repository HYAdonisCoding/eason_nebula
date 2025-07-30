import 'package:eason_nebula/ui/Animations/BaseAnimation.dart';
import 'package:eason_nebula/ui/Animations/HeroAnimation.dart';
import 'package:eason_nebula/ui/Animations/StaggeredAnimation.dart';
import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class AnimationPage extends EasonBasePage {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  String get title => 'AnimationPage';

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends BasePageState<AnimationPage> {
  static const list = ['基础动画', 'Hero动画', '交错动画'];
  // baseAnimation

  @override
  Widget buildContent(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              list[index],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            leading: Icon(Icons.animation, color: Colors.blueAccent),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              // 可添加导航或交互逻辑
              debugPrint('点击了: ${list[index]}');
              // 例如，导航到对应的动画页面
              if (index == 0) {
                // 导航到基础动画页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BaseAnimation()),
                );
              } else if (index == 1) {
                // 导航到Hero动画页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HeroAnimation()),
                );
              } else if (index == 2) {
                // 导航到交错动画页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StaggeredAnimation()),
                );
              }
            },
          ),
        );
      },
    );
  }
}
