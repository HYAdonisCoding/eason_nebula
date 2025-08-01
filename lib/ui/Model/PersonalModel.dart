import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Personalmodel extends Model {
  void updateFromControllers({
    required TextEditingController nameCtrl,
    required TextEditingController nicknameCtrl,
    required TextEditingController phoneCtrl,
    required TextEditingController emailCtrl,
    required TextEditingController addressCtrl,
    required TextEditingController passwordCtrl,
  }) {
    _name = nameCtrl.text;
    _nickname = nicknameCtrl.text;
    _phone = phoneCtrl.text;
    _email = emailCtrl.text;
    _address = addressCtrl.text;
    _password = passwordCtrl.text;
  }

  String _name = "Name";
  String get name => _name;
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  String _nickname = "Nickname";
  String get nickname => _nickname;
  void setNickname(String nickname) {
    _nickname = nickname;
    notifyListeners();
  }

  String _email = "";
  String get email => _email;
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  String _avatar = "";
  String get avatar => _avatar;
  void setAvatar(String avatar) {
    _avatar = avatar;
    notifyListeners();
  }

  String _phone = "";
  String get phone => _phone;
  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  String _address = "";
  String get address => _address;
  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  String _password = "";
  String get password => _password;
  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  // 保存到本地
  Future<void> saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('nickname', nickname);
    prefs.setString('phone', phone);
    prefs.setString('email', email);
    prefs.setString('address', address);
    prefs.setString('password', password);
  }

  // 从本地加载
  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? '';
    _nickname = prefs.getString('nickname') ?? '';
    _phone = prefs.getString('phone') ?? '';
    _email = prefs.getString('email') ?? '';
    _address = prefs.getString('address') ?? '';
    _password = prefs.getString('password') ?? '';
    notifyListeners();
  }
}
