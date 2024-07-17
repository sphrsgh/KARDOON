import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DrawerProvider with ChangeNotifier {

  String _userid = 'userid';
  String _username = 'username';
  String _fullName = 'fullName';
  String _email = 'example@email.com';
  get userid => _userid;
  get username => _username;
  get fullName => _fullName;
  get email => _email;

  setInfo() async {
    var box = await Hive.openBox('userInfo');
    _userid = box.get('id');
    _username = box.get('user');
    _fullName = box.get('fullName');
    _email = box.get('email');
    notifyListeners();
  }

}