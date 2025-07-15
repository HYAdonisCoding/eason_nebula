import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:flutter/material.dart';

class WalletPage extends EasonBasePage {
  const WalletPage({Key? key}) : super(key: key);

  @override
  String get title => 'WalletPage';

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends BasePageState<WalletPage> {
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Text(
        'WalletPage Content',
        style: TextStyle(fontSize: 24, color: Colors.blue),
      ),
    );
  }
}
