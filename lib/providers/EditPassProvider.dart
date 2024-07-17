import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kardoon/views/home.dart';
import 'package:quickalert/quickalert.dart';
import '../backends/database.dart';
import '../backends/persianNum.dart';
import 'package:cross_connectivity/cross_connectivity.dart';

class EditPassProvider with ChangeNotifier {

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

  final TextEditingController _editPassCtrl = TextEditingController();
  final TextEditingController _editPassRepCtrl = TextEditingController();
  TextEditingController get editPassCtrl => _editPassCtrl;
  TextEditingController get editPassRepCtrl => _editPassRepCtrl;

  onTapTextFields() {
    if(_editPassCtrl.selection == TextSelection.fromPosition(TextPosition(offset: _editPassCtrl.text.length -1))){
      _editPassCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _editPassCtrl.text.length));
    }
    if(_editPassRepCtrl.selection == TextSelection.fromPosition(TextPosition(offset: _editPassRepCtrl.text.length -1))){
      _editPassRepCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _editPassRepCtrl.text.length));
    }
    notifyListeners();
  }

  clearAll() {
    _editPassCtrl.clear();
    _editPassRepCtrl.clear();
    resetVisiblties();
  }

  final TextEditingController _passCtrl = TextEditingController();
  TextEditingController get passCtrl => _passCtrl;

  setEditPass(context) async {
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
      String passError = ":رمز عبور باید شامل موارد زیر باشد\n";
      bool passFlag = false;
      if(_editPassCtrl.text.trim().length<8) {
        passFlag = true;
        passError += PersianNums(".حداقل 8 کاراکتر\n");
      }
      if(!_editPassCtrl.text.trim().containsLowercase){
        passFlag = true;
        passError += PersianNums(".حداقل یک حرف کوچک انگلیسی\n");
      }
      if(!_editPassCtrl.text.trim().containsUppercase){
        passFlag = true;
        passError += PersianNums(".حداقل یک حرف بزرگ انگلیسی\n");
      }
      if(!_editPassCtrl.text.trim().containsNumber){
        passFlag = true;
        passError += PersianNums(".حداقل یک عدد\n");
      }
      if(_editPassCtrl.text.trim().isEmpty || _editPassRepCtrl.text.trim().isEmpty) {
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
      } else if (_editPassCtrl.text.trim() != _editPassRepCtrl.text.trim()) {
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
      } else {
        Navigator.pop(context);
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          title: ".رمز قبلی خود را وارد کنید",
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
                        hintText: 'رمز عبور قبلی',
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
            if (passCtrl.text.trim() == box.get('pass') && await updatePass(box.get('user'), box.get('pass'), box.get('id'), _editPassCtrl.text.trim())) {
              box.delete('pass');
              box.put('pass', _editPassCtrl.text.trim());
              Navigator.pop(context);
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: ".رمز عبور ویرایش شد",
                confirmBtnText: "باشه",
                titleColor: Theme.of(context).secondaryHeaderColor,
                textColor: Theme.of(context).secondaryHeaderColor,
                confirmBtnColor: Theme.of(context).primaryColor,
              );
              _passCtrl.clear();
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
              clearAll();
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