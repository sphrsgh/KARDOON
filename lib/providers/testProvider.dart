import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kardoon/backends/persianNum.dart';
import 'package:kardoon/views/account.dart';
import 'package:kardoon/views/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

Future<bool> checkInfo() async {
  await Hive.initFlutter();
  var boxUserInfo = await Hive.openBox('userInfo');
  return (boxUserInfo.get('user') != null && boxUserInfo.get('pass') != null);
}

class TestProvider with ChangeNotifier {

  Widget _view = const accForm();
  Widget get view => _view;

  setView() async {
    if (await checkInfo()){
      _view = const HomeView();
    } else {
      _view = const accForm();
    }
    notifyListeners();
  }

}