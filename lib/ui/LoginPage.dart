import 'package:eason_nebula/utils/EasonAppBar.dart';
import 'package:flutter/material.dart';
import '../utils/EasonMessenger.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _obscure = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // 这里可以处理登录逻辑
      print('用户名: $_username, 密码: $_password');
      if (_username == 'Eason' && _password == 'eason') {
        EasonMessenger.showSuccess(
          context,
          message: '登录成功！',
          onComplete: () {
            Navigator.pop(context); // 关闭登录页面
            // 可以跳转到主页或其他页面
          },
        );
        // 可以跳转到主页或其他页面
      } else {
        EasonMessenger.showError(
          context,
          message: '用户名或密码错误',
          onComplete: () {
            // 清空输入框
            _formKey.currentState!.reset();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: EasonAppBar(title: '登录', showBack: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_rounded, size: 64, color: Colors.deepPurple),
              SizedBox(height: 16),
              Text(
                '欢迎登录',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 32),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: '用户名',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onSaved: (v) => _username = v ?? '',
                          validator: (v) =>
                              v == null || v.isEmpty ? '请输入用户名' : null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: '密码',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          obscureText: _obscure,
                          onSaved: (v) => _password = v ?? '',
                          validator: (v) =>
                              v == null || v.isEmpty ? '请输入密码' : null,
                        ),
                        SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style:
                                ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ).copyWith(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith((
                                        states,
                                      ) {
                                        return null;
                                      }),
                                  foregroundColor: MaterialStateProperty.all(
                                    Colors.white,
                                  ),
                                ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.blueAccent,
                                    Colors.cyan,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '登录',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: () {},
                child: Text(
                  '忘记密码？',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
