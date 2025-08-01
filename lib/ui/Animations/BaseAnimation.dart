import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class BaseAnimation extends EasonBasePage {
  final String tag;

  const BaseAnimation({Key? key, required this.tag}) : super(key: key);

  @override
  String get title => 'BaseAnimation';

  @override
  State<BaseAnimation> createState() => _BaseAnimationState();
}

class _BaseAnimationState extends BasePageState<BaseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _valueController;
  late Animation<double> _doubleAnimation;

  @override
  void initState() {
    super.initState();
    _valueController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _doubleAnimation = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(parent: _valueController, curve: Curves.easeInOut),
    );

    _doubleAnimation.addStatusListener((status) {
      debugPrint('Animation status: $status');
      if (status == AnimationStatus.forward) {
        debugPrint('Animation started');
      } else if (status == AnimationStatus.reverse) {
        debugPrint('Animation reversed');
      } else if (status == AnimationStatus.completed) {
        debugPrint('Animation completed');
      } else if (status == AnimationStatus.dismissed) {
        debugPrint('Animation dismissed');
        _valueController.forward();
      }
    });

    _valueController.forward();
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Widget animation(BuildContext context) {
    return AnimatedBuilder(
      animation: _doubleAnimation,
      builder: (context, child) {
        return Hero(
          tag: widget.tag,
          child: Container(
            width: _doubleAnimation.value,
            height: _doubleAnimation.value,
            color: Colors.teal,
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Icon(Icons.ballot_sharp, color: Colors.blueAccent),
          ),
        );
      },
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Center(child: animation(context));
  }
}
