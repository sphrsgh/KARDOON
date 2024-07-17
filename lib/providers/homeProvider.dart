import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kardoon/backends/calendar.dart';
import 'package:kardoon/backends/database.dart';
import 'package:kardoon/backends/persianNum.dart';
import 'package:kardoon/views/weekBtns.dart';
import 'package:quickalert/quickalert.dart';
import 'package:cross_connectivity/cross_connectivity.dart';

class WeekBtnProvider with ChangeNotifier {

  int _dayChange = 0;
  int get dayChange => _dayChange;
  nextPrevWeek(int num){
    _dayChange += num;
    notifyListeners();
  }
  backToday(){
    _dayChange = 0;
    setTheWeekDay(getToWeekday());
    switchBtn(getTheWeekDay());
  }

  List _backColor = [0xFF2F49D1, 0xFF2F49D1, 0xFF2F49D1, 0xFF2F49D1, 0xFF2F49D1, 0xFF2F49D1, 0xFF2F49D1];
  List _textColor = [0xFFFAF9FE, 0xFFFAF9FE, 0xFFFAF9FE, 0xFFFAF9FE, 0xFFFAF9FE, 0xFFFAF9FE, 0xFFFAF9FE];
  List get backColor => _backColor;
  List get textColor => _textColor;

  setBtns(int weekDayNum) async {
    _backColor = [0xFF2F49D1, 0xFF2F49D1, 0xFF2F49D1, 0xFF2F49D1, 0xFF2F49D1, 0xFF2F49D1, 0xFF2F49D1];
    _textColor = [0xFFFAF9FE, 0xFFFAF9FE, 0xFFFAF9FE, 0xFFFAF9FE, 0xFFFAF9FE, 0xFFFAF9FE, 0xFFFAF9FE];
    _backColor[weekDayNum] = 0xFFFAF9FE;
    _textColor[weekDayNum] = 0xFF051956;
    setTheWeekDay(weekDayNum);
    await setTaskItems(weekDayNum);
  }
  switchBtn(int weekDayNum) async {
    await setBtns(weekDayNum);
    notifyListeners();
  }

  final List _idList = [];
  final List _titles = [];
  final List _times = [];
  final List _details = [];
  final List _doneList = [];
  List get idList => _idList;
  List get titles => _titles;
  List get times => _times;
  List get details => _details;
  List get doneList => _doneList;

  setTaskItems(int weekdayNumber) async {
    var box = await Hive.openBox('userInfo');
    List tasks = await box.get('tasks');
    clearTaskItems();
    for(int i = 0; i<tasks.length; i++){
      if(tasks[i]['weekday'] == '$weekdayNumber') {
        _idList.add(tasks[i]['ID']);
        _titles.add(tasks[i]['taskTitle']);
        _times.add(tasks[i]['startTime'].substring(0, tasks[i]['startTime'].length - 3)+' الی '+tasks[i]['endTime'].substring(0, tasks[i]['endTime'].length - 3));
        _details.add(tasks[i]['taskDetails']);
        _doneList.add(tasks[i]['done']);
      }
    }
  }

  clearTaskItems() {
    _idList.clear();
    _titles.clear();
    _times.clear();
    _details.clear();
    _doneList.clear();
  }


  doneChange(context, int index) async {

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
      var box = await Hive.openBox('userInfo');
      if(_doneList[index] == "0") {
        if (await doneUpdate(box.get('user'), box.get('pass'), _idList[index], "1")){
          _doneList[index] = "1";
          await box.delete('tasks');
          await box.put('tasks', await getTasks(box.get('user'), box.get('pass')));
          await switchBtn(getTheWeekDay());
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "",
            title: "!ثبت شد",
            confirmBtnText: "باشه",
            titleColor: Theme.of(context).secondaryHeaderColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            confirmBtnColor: Theme.of(context).primaryColor,
          );
          Navigator.pop(context);
        } else {
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
        }
      } else {
        if (await doneUpdate(box.get('user'), box.get('pass'), _idList[index], "0")){
          _doneList[index] = "0";
          await box.delete('tasks');
          await box.put('tasks', await getTasks(box.get('user'), box.get('pass')));
          await switchBtn(getTheWeekDay());
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "",
            title: "!ثبت شد",
            confirmBtnText: "باشه",
            titleColor: Theme.of(context).secondaryHeaderColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            confirmBtnColor: Theme.of(context).primaryColor,
          );
          Navigator.pop(context);
        } else {
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
        }
      }
      notifyListeners();
    }
  }

  deleteBtn(context, int index) async {
    String title = PersianNums(_titles[index]);
    bool flag = false;
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
        text: "کار $title حذف شود؟",
        title: "!هشدار",
        showCancelBtn: true,
        confirmBtnText: "بله",
        cancelBtnText: "خیر",
        titleColor: Theme.of(context).secondaryHeaderColor,
        textColor: Theme.of(context).secondaryHeaderColor,
        confirmBtnColor: Theme.of(context).primaryColor,
        cancelBtnTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 17.0,),
        onConfirmBtnTap: () {
          flag = true;
          Navigator.pop(context);
        },
      );
      var box = await Hive.openBox('userInfo');
      if(flag) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          text: ".لطفا صبر کنید",
          title: "در حال بارگذاری",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        if (await deleteTask(box.get('user'), box.get('pass'), _idList[index])){
          _idList.removeAt(index);
          _titles.removeAt(index);
          _times.removeAt(index);
          _details.removeAt(index);
          _doneList.removeAt(index);
          await box.delete('tasks');
          await box.put('tasks', await getTasks(box.get('user'), box.get('pass')));
          await switchBtn(getTheWeekDay());
          await QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: ".کار ${title} حذف شد",
              title: "!حذف شد",
              confirmBtnText: "باشه",
              titleColor: Theme.of(context).secondaryHeaderColor,
              textColor: Theme.of(context).secondaryHeaderColor,
              confirmBtnColor: Theme.of(context).primaryColor,
              onConfirmBtnTap: () {
                Navigator.pop(context);
              }
          );
        } else {
          await QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: ".مشکل از سمت سرور",
              title: "!خطا",
              confirmBtnText: "باشه",
              titleColor: Theme.of(context).secondaryHeaderColor,
              textColor: Theme.of(context).secondaryHeaderColor,
              confirmBtnColor: Theme.of(context).primaryColor,
              onConfirmBtnTap: () {
                Navigator.pop(context);
              }
          );
        }
        Navigator.pop(context);
      }
      notifyListeners();
    }
  }

}
