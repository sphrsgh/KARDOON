import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kardoon/backends/database.dart';
import 'package:kardoon/backends/persianNum.dart';
import 'package:kardoon/views/home.dart';
import 'package:quickalert/quickalert.dart';
import 'package:cross_connectivity/cross_connectivity.dart';

class AccProvider with ChangeNotifier {

  bool _visibility = false;
  bool get visibility => _visibility;

  changeVisibility(){
    _visibility = !_visibility;
    notifyListeners();
  }

  resetVisiblties() {
    _visibility = false;
    notifyListeners();
  }

  final TextEditingController _loginUserCtrl = TextEditingController();
  final TextEditingController _loginPassCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _signupUserCtrl = TextEditingController();
  final TextEditingController _signupPassCtrl = TextEditingController();
  final TextEditingController _repPassCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  TextEditingController get loginUserCtrl => _loginUserCtrl;
  TextEditingController get loginPassCtrl => _loginPassCtrl;
  TextEditingController get nameCtrl => _nameCtrl;
  TextEditingController get signupUserCtrl => _signupUserCtrl;
  TextEditingController get signupPassCtrl => _signupPassCtrl;
  TextEditingController get repPassCtrl => _repPassCtrl;
  TextEditingController get emailCtrl => _emailCtrl;

  onTapTextFields() {
    if(_loginUserCtrl.selection == TextSelection.fromPosition(TextPosition(offset: _loginUserCtrl.text.length -1))){
      _loginUserCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _loginUserCtrl.text.length));
    }
    if(_loginPassCtrl.selection == TextSelection.fromPosition(TextPosition(offset: _loginPassCtrl.text.length -1))){
      _loginPassCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _loginPassCtrl.text.length));
    }
    if(_nameCtrl.selection == TextSelection.fromPosition(TextPosition(offset: _nameCtrl.text.length -1))){
      _nameCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _nameCtrl.text.length));
    }
    if(_signupUserCtrl.selection == TextSelection.fromPosition(TextPosition(offset: _signupUserCtrl.text.length -1))){
      _signupUserCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _signupUserCtrl.text.length));
    }
    if(_signupPassCtrl.selection == TextSelection.fromPosition(TextPosition(offset: _signupPassCtrl.text.length -1))){
      _signupPassCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _signupPassCtrl.text.length));
    }
    if(_repPassCtrl.selection == TextSelection.fromPosition(TextPosition(offset:_repPassCtrl.text.length -1))){
      _repPassCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _repPassCtrl.text.length));
    }
    if(_emailCtrl.selection == TextSelection.fromPosition(TextPosition(offset: _emailCtrl.text.length -1))){
      _emailCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _emailCtrl.text.length));
    }
    notifyListeners();
  }


  login(context) async {
    FocusScope.of(context).unfocus();

    bool offline = !await Connectivity().checkConnection();
    if (offline) {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "،برای استفاده کامل از برنامه\n.اینترنت خود را روشن کنید",
        title: "!عدم اتصال به اینترنت",
        confirmBtnText: "باشه",
        titleColor: Theme.of(context).secondaryHeaderColor,
        textColor: Theme.of(context).secondaryHeaderColor,
        confirmBtnColor: Theme.of(context).primaryColor,
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        text: ".لطفا صبر کنید",
        title: "در حال بارگذاری",
        titleColor: Theme.of(context).secondaryHeaderColor,
        textColor: Theme.of(context).secondaryHeaderColor,
        confirmBtnColor: Theme.of(context).primaryColor,
      );

      // String userError = "";
      // bool userFlag = false;
      // String userAllow = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
      // for (int i = 0; i < _loginUserCtrl.text.trim().length; i++) {
      //   print('object');
      //   if(!userAllow.contains(_loginUserCtrl.text.trim()[i])){
      //     userFlag = true;
      //     userError += PersianNums("\n،نام کاربری تنها می تواند از اعداد\n.حروف انگلیسی و آندرلاین باشد");
      //     break;
      //   }
      // }


      if(_loginUserCtrl.text.trim().isEmpty || _loginPassCtrl.text.trim().isEmpty) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: ".لطفا تمام فیلد ها را پر کنید",
          title: "!مشکل",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else
        //   if (userFlag) {
        //   await QuickAlert.show(
        //     context: context,
        //     type: QuickAlertType.error,
        //     text: userError,
        //     title: "!نام کاربری مجاز نیست",
        //     confirmBtnText: "باشه",
        //     titleColor: Theme.of(context).secondaryHeaderColor,
        //     textColor: Theme.of(context).secondaryHeaderColor,
        //     confirmBtnColor: Theme.of(context).primaryColor,
        //   );
        //   Navigator.pop(context);
        // } else
      if (!await loginUser(_loginUserCtrl.text.trim(), _loginPassCtrl.text.trim())){
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: ".نام کاربری یا رمز عبور اشتباه است",
          title: "!خطا",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else {
        var box = await Hive.openBox('userInfo');
        List info = await getInfo(_loginUserCtrl.text.trim(), _loginPassCtrl.text.trim());
        box.put('user',_loginUserCtrl.text.trim());
        box.put('pass',_loginPassCtrl.text.trim());
        box.put('id', info[0]['ID']);
        box.put('fullName', info[0]['fullname']);
        box.put('email', info[0]['email']);
        box.put('tasks',await getTasks(_loginUserCtrl.text.trim(), _loginPassCtrl.text.trim()));
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: ".شما با موفقیت وارد شدید",
          title: "!ورود موفق",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        clearAll();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
      }
    }
  }

  signup(context) async {
    FocusScope.of(context).unfocus();

    bool offline = !await Connectivity().checkConnection();
    if (offline) {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "،برای استفاده کامل از برنامه\n.اینترنت خود را روشن کنید",
        title: "!عدم اتصال به اینترنت",
        confirmBtnText: "باشه",
        titleColor: Theme.of(context).secondaryHeaderColor,
        textColor: Theme.of(context).secondaryHeaderColor,
        confirmBtnColor: Theme.of(context).primaryColor,
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        text: ".لطفا صبر کنید",
        title: "در حال بارگذاری",
        titleColor: Theme.of(context).secondaryHeaderColor,
        textColor: Theme.of(context).secondaryHeaderColor,
        confirmBtnColor: Theme.of(context).primaryColor,
      );

      String userError = "";
      bool userFlag = false;
      if(_signupUserCtrl.text.trim().length<6) {
        userFlag = true;
        userError += PersianNums("\n.نام کاربری باید حداقل 6 کاراکتر باشد");
      }
      String userAllow = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
      for (int i = 0; i < _signupUserCtrl.text.trim().length; i++) {
        if(!userAllow.contains(_signupUserCtrl.text.trim()[i])){
          userFlag = true;
          userError += PersianNums("\n،نام کاربری تنها می تواند از اعداد\n.حروف انگلیسی و آندرلاین باشد");
          break;
        }
      }

      String passError = ":رمز عبور باید شامل موارد زیر باشد\n";
      bool passFlag = false;
      if(_signupPassCtrl.text.trim().length<8) {
        passFlag = true;
        passError += PersianNums(".حداقل 8 کاراکتر\n");
      }
      if(!_signupPassCtrl.text.trim().containsLowercase){
        passFlag = true;
        passError += PersianNums(".حداقل یک حرف کوچک انگلیسی\n");
      }
      if(!_signupPassCtrl.text.trim().containsUppercase){
        passFlag = true;
        passError += PersianNums(".حداقل یک حرف بزرگ انگلیسی\n");
      }
      if(!_signupPassCtrl.text.trim().containsNumber){
        passFlag = true;
        passError += PersianNums(".حداقل یک عدد\n");
      }


      if(_nameCtrl.text.trim().isEmpty || _signupUserCtrl.text.trim().isEmpty || _signupPassCtrl.text.trim().isEmpty || _repPassCtrl.text.trim().isEmpty || _emailCtrl.text.isEmpty) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: ".لطفا تمام فیلد ها را پر کنید",
          title: "!فیلد خالی",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      }
      else if(userFlag) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: userError,
          title: "!نام کاربری مجاز نیست",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else if (await uniqueUser(_signupUserCtrl.text.trim())) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: ".لطفا نام کاربری دیگری را امتحان کنید",
          title: "!نام کاربری در دسترس نیست",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else if (passFlag) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: passError,
          title: "!رمز عبور مجاز نیست",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else if (_repPassCtrl.text.trim() != _signupPassCtrl.text.trim()) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: ".لطفا تکرار رمز عبور را تصحیح کنید",
          title: "!تکرار رمز عبور برابر نیست",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else if (!_emailCtrl.text.trim().emailValidate){
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: ".لطفا ایمیل معتبر وارد کنید",
          title: "!ایمیل معتبر نیست",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else if (!await addUser(_nameCtrl.text.trim(), _signupUserCtrl.text.trim(), _signupPassCtrl.text.trim(), _emailCtrl.text.trim())){
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: ".مشکل از سمت سرور",
          title: "!خطا",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: ".ثبت نام با موفقیت انجام شد\n.می توانید وارد شوید",
          title: "!انجام شد",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
        _loginUserCtrl.text = _signupUserCtrl.text;
        _loginPassCtrl.text = _signupPassCtrl.text;
        resetVisiblties();
      }
    }
  }

  clearAll() {
    _loginUserCtrl.clear();
    _loginPassCtrl.clear();
    _nameCtrl.clear();
    _signupUserCtrl.clear();
    _signupPassCtrl.clear();
    _repPassCtrl.clear();
    _emailCtrl.clear();
    resetVisiblties();
  }

}


extension StringValidators on String {
  bool get containsUppercase => contains(RegExp(r'[A-Z]'));
  bool get containsLowercase => contains(RegExp(r'[a-z]'));
  bool get containsNumber => contains(RegExp(r'[0-9]'));
  bool get emailValidate => contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
}