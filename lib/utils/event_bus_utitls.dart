import 'package:event_bus/event_bus.dart';
// 实例化EventBus，创建一个事件总线
EventBus eventBus = EventBus();

// 定义Event事件，即要传递和共享的实体类
class UserEvent {
  final String name;

  UserEvent(this.name);
}
class BookEvent {
  final String title;
  final String author;

  BookEvent(this.title, this.author);
}

// 注册事件监听器
void registerUserEventListener() {
  eventBus.on<UserEvent>().listen((event) {
    // 处理UserEvent事件
    print('UserEvent received: ${event.name}');
  });
}

// 定义事件监听器
class UserEventListener {
  void onEvent(UserEvent event) {
    // 处理事件
    print('Event received: ${event.name}');
  }
}


