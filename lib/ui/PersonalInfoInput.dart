import 'package:flutter/material.dart';
import '../utils/EasonTextField.dart';

class PersonalInfoInputPage extends StatefulWidget {
  const PersonalInfoInputPage({Key? key}) : super(key: key);

  @override
  State<PersonalInfoInputPage> createState() => _PersonalInfoInputPageState();
}

class _PersonalInfoInputPageState extends State<PersonalInfoInputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('个人信息输入')),
      body: ListView(
        children: [
          EasonTextField(
            label: '姓名',
            hintText: '请输入真实姓名',
            controller: nameController,
          ),
          EasonTextField(
            label: '昵称',
            hintText: '请输入昵称',
            controller: nicknameController,
          ),
          EasonTextField(
            label: '手机号',
            hintText: '请输入手机号',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 11,
          ),
          EasonTextField(
            label: '邮箱',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          EasonTextField(
            label: '地址',
            hintText: '请输入详细地址',
            controller: addressController,
            maxLines: 3, // 支持多行输入
          ),
          EasonTextField(
            label: '密码',
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true, // 关键参数
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print('姓名: ${nameController.text}');
                print('昵称: ${nicknameController.text}');
                print('手机号: ${phoneController.text}');
                print('邮箱: ${emailController.text}');
                print('地址: ${addressController.text}');
                print('密码: ${passwordController.text}');
                // 这里可以添加提交逻辑，比如发送到服务器或保存到本地
              },
              child: const Text('提交'),
            ),
          ),
        ],
      ),
    );
  }
}
