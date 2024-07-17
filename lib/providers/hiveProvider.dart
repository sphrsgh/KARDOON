
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:kardoon/views/account.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:quickalert/quickalert.dart';
import '../backends/database.dart';
import '../views/weekBtns.dart';


class HiveProvider with ChangeNotifier {

  loadTasks() async { // Offline
    var box = await Hive.openBox('userInfo');
  }
  reloadTasks() async { // Online
    var box = await Hive.openBox('userInfo');
    box.delete('tasks');
    box.put('tasks', await getTasks(box.get('user'), box.get('pass')));
    return true;
  }
  reloadInfo() async { // Online
    var box = await Hive.openBox('userInfo');
    box.delete('id');
    box.delete('fullName');
    box.delete('email');
    List info = await getInfo(box.get('user'), box.get('pass'));
    box.put('id', info[0]['ID']);
    box.put('fullName', info[0]['fullname']);
    box.put('email', info[0]['email']);
  }

  logOut(context) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      text: "از حساب کاربری خارج می شوید؟",
      title: "!هشدار",
      showCancelBtn: true,
      confirmBtnText: "بله",
      cancelBtnText: "خیر",
      titleColor: Theme.of(context).secondaryHeaderColor,
      textColor: Theme.of(context).secondaryHeaderColor,
      confirmBtnColor: Theme.of(context).primaryColor,
      cancelBtnTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 17.0,),
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        var boxUserInfo = await Hive.openBox('userInfo');
        boxUserInfo.clear();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const accForm()));
        notifyListeners();
      },
    );
  }

  final TextEditingController _passCtrl = TextEditingController();
  TextEditingController get passCtrl => _passCtrl;
  deleteAccount(context) async {
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
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "حساب کاربری را حذف می کنید؟",
        title: "!هشدار",
        showCancelBtn: true,
        confirmBtnText: "بله",
        cancelBtnText: "خیر",
        titleColor: Theme.of(context).secondaryHeaderColor,
        textColor: Theme.of(context).secondaryHeaderColor,
        confirmBtnColor: Theme.of(context).primaryColor,
        cancelBtnTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 17.0,),
        onConfirmBtnTap: () async {
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
            confirmBtnText: "حذف حساب",
            cancelBtnText: "انصراف",
            titleColor: Theme.of(context).secondaryHeaderColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            confirmBtnColor: Colors.red,
            cancelBtnTextStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.w700, fontSize: 17.0,),
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
              var box = await Hive.openBox('userInfo');
              if (passCtrl.text.trim() == box.get('pass') && await deleteUser(box.get('user'), passCtrl.text.trim(), box.get('id'))) {
                Navigator.pop(context);
                await QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: ".حساب کاربری شما حذف شد",
                  confirmBtnText: "باشه",
                  titleColor: Theme.of(context).secondaryHeaderColor,
                  textColor: Theme.of(context).secondaryHeaderColor,
                  confirmBtnColor: Theme.of(context).primaryColor,
                );
                _passCtrl.clear();
                box.clear();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const accForm()));
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
        },
      );
    }
  }

  isOffline(context) async {
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
    }
    return offline;
  }

}