import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kardoon/views/home.dart';
import 'package:quickalert/quickalert.dart';
import '../backends/database.dart';
import '../backends/persianNum.dart';
import 'package:cross_connectivity/cross_connectivity.dart';

class EditUserProvider with ChangeNotifier {

  final TextEditingController _editUserCtrl = TextEditingController();
  final TextEditingController _editNameCtrl = TextEditingController();
  final TextEditingController _editEmailCtrl = TextEditingController();
  TextEditingController get editUserCtrl => _editUserCtrl;
  TextEditingController get editNameCtrl => _editNameCtrl;
  TextEditingController get editEmailCtrl => _editEmailCtrl;

  onTapTextFields() {
    if(_editUserCtrl.selection == TextSelection.fromPosition(TextPosition(offset: _editUserCtrl.text.length -1))){
      _editUserCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _editUserCtrl.text.length));
    }
    if(_editNameCtrl.selection == TextSelection.fromPosition(TextPosition(offset: _editNameCtrl.text.length -1))){
      _editNameCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _editNameCtrl.text.length));
    }
    if(_editEmailCtrl.selection == TextSelection.fromPosition(TextPosition(offset: _editEmailCtrl.text.length -1))){
      _editEmailCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _editEmailCtrl.text.length));
    }
    notifyListeners();
  }

  final TextEditingController _passCtrl = TextEditingController();
  TextEditingController get passCtrl => _passCtrl;

  fillTextFields() async {
    var box = await Hive.openBox('userInfo');
    _editNameCtrl.text = box.get('fullName');
    _editUserCtrl.text = box.get('user');
    _editEmailCtrl.text = box.get('email');
  }

  setEditUser(context) async {
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
      var box = await Hive.openBox('userInfo');
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
      if(_editUserCtrl.text.trim().length<6) {
        userFlag = true;
        userError += PersianNums("\n.نام کاربری باید حداقل 6 کاراکتر باشد");
      }
      String userAllow = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
      for (int i = 0; i < _editUserCtrl.text.trim().length; i++) {
        if(!userAllow.contains(_editUserCtrl.text.trim()[i])){
          userFlag = true;
          userError += PersianNums("\n،نام کاربری تنها می تواند از اعداد\n.حروف انگلیسی و آندرلاین باشد");
          break;
        }
      }
      if(_editNameCtrl.text.trim().isEmpty || _editUserCtrl.text.trim().isEmpty || _editEmailCtrl.text.isEmpty) {
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
      } else if (await uniqueUser(_editUserCtrl.text.trim()) && _editUserCtrl.text.trim() != box.get('user')) {
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
      } else if (!_editEmailCtrl.text.trim().emailValidate){
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
      } else {
        Navigator.pop(context);
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          title: ".رمز عبور خود را وارد کنید",
          widget: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0,),
            child: Container(
              height: 45.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0,),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).secondaryHeaderColor,
                  width: 0.7,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10.0),),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _passCtrl,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.justify,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      maxLength: 255,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'رمز عبور',
                        hintTextDirection: TextDirection.rtl,
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 5.0, right: 2.0),
                        counterText: "",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          showCancelBtn: true,
          confirmBtnText: "ثبت",
          cancelBtnText: "انصراف",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
          cancelBtnTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 17.0,),
          onCancelBtnTap: () {
            _passCtrl.clear();
            Navigator.pop(context);
          },
          onConfirmBtnTap: () async {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              text: ".لطفا صبر کنید",
              title: "در حال بارگذاری",
              titleColor: Theme.of(context).secondaryHeaderColor,
              textColor: Theme.of(context).secondaryHeaderColor,
              confirmBtnColor: Theme.of(context).primaryColor,
            );
            if (passCtrl.text.trim() == box.get('pass') && await updateUser(box.get('user'), box.get('pass'), box.get('id'), _editNameCtrl.text.trim(), _editUserCtrl.text.trim(), _editEmailCtrl.text.trim())) {
              box.delete('user');
              box.put('user', _editUserCtrl.text.trim());
              box.delete('id');
              box.delete('fullName');
              box.delete('email');
              List info = await getInfo(box.get('user'), box.get('pass'));
              box.put('id', info[0]['ID']);
              box.put('fullName', info[0]['fullname']);
              box.put('email', info[0]['email']);
              Navigator.pop(context);
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: ".حساب کاربری ویرایش شد",
                confirmBtnText: "باشه",
                titleColor: Theme.of(context).secondaryHeaderColor,
                textColor: Theme.of(context).secondaryHeaderColor,
                confirmBtnColor: Theme.of(context).primaryColor,
              );
              _passCtrl.clear();
              // box.clear();
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
              notifyListeners();
            } else {
              Navigator.pop(context);
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: ".رمز عبور اشتباه است",
                title: "!خطا",
                confirmBtnText: "باشه",
                titleColor: Theme.of(context).secondaryHeaderColor,
                textColor: Theme.of(context).secondaryHeaderColor,
                confirmBtnColor: Theme.of(context).primaryColor,
              );
            }
          },
        );
      }
    }
  }

}


extension StringValidators on String {
  bool get containsUppercase => contains(RegExp(r'[A-Z]'));
  bool get containsLowercase => contains(RegExp(r'[a-z]'));
  bool get containsNumber => contains(RegExp(r'[0-9]'));
  bool get emailValidate => contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
}