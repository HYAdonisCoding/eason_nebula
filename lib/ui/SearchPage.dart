import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class SearchPage extends EasonBasePage {
  const SearchPage({Key? key}) : super(key: key);

  @override
  String get title => 'SearchPage';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends BasePageState<SearchPage> {
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Text(
        'SearchPage Content',
        style: TextStyle(fontSize: 24, color: Colors.blue),
      ),
    );
  }
}
