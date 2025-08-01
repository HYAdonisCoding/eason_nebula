import 'package:eason_nebula/ui/Base/EasonBasePage.dart';
import 'package:eason_nebula/ui/Model/PersonalModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../utils/EasonTextField.dart';

class PersonalInfoInputPage extends EasonBasePage {
  const PersonalInfoInputPage({Key? key}) : super(key: key);

  @override
  State<PersonalInfoInputPage> createState() => _PersonalInfoInputPageState();

  @override
  // TODO: implement title
  String get title => "个人信息修改";
}

class _PersonalInfoInputPageState extends BasePageState<PersonalInfoInputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late Personalmodel _model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model = ScopedModel.of<Personalmodel>(context, rebuildOnChange: true);
      _loadModel();
    });
  }

  Future<void> _loadModel() async {
    await _model.loadFromLocal();
    nameController.text = _model.name;
    nicknameController.text = _model.nickname;
    phoneController.text = _model.phone;
    emailController.text = _model.email;
    addressController.text = _model.address;
    passwordController.text = _model.password;
    setState(() {}); // 触发界面更新
  }

  @override
  Widget buildContent(BuildContext context) {
    return ListView(
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
            onPressed: () async {
              // 这里可以添加提交逻辑，比如发送到服务器或保存到本地
              _model.updateFromControllers(
                nameCtrl: nameController,
                nicknameCtrl: nicknameController,
                phoneCtrl: phoneController,
                emailCtrl: emailController,
                addressCtrl: addressController,
                passwordCtrl: passwordController,
              );

              debugPrint('姓名: ${_model.name}');
              debugPrint('昵称: ${_model.nickname}');
              debugPrint('手机号: ${_model.phone}');
              debugPrint('邮箱: ${_model.email}');
              debugPrint('地址: ${_model.address}');
              debugPrint('密码: ${_model.password}');
              await _model.saveToLocal(); // 保存到本地
              // 返回前一页
              Navigator.pop(context);
            },
            child: const Text('提交'),
          ),
        ),
      ],
    );
  }
}
