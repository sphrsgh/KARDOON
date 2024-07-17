import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kardoon/backends/database.dart';
import 'package:kardoon/backends/persianNum.dart';
import 'package:quickalert/quickalert.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:cross_connectivity/cross_connectivity.dart';


class ScheduleProvider with ChangeNotifier {

  List _weekday = [0];
  List _startTime = [const TimeOfDay(hour: 12, minute: 00)];
  List _endTime = [const TimeOfDay(hour: 12, minute: 00)];
  List _startTimeCrtl = [TextEditingController(text: PersianNums('12:00'))];
  List _endTimeCrtl = [TextEditingController(text: PersianNums('12:00'))];
  int _itemCount = 1;
  get weekday => _weekday;
  get startTime => _startTime;
  get endTime => _endTime;
  get startTimeCrtl => _startTimeCrtl;
  get endTimeCrtl => _endTimeCrtl;
  get itemCount => _itemCount;

  List _ids = [-1];
  get ids => _ids;
  List _delIds = [];
  get delIds => _delIds;
  List _addIndex = [];
  get addIndex => _addIndex;

  add(){
    _weekday.add(0);
    _startTime.add(const TimeOfDay(hour: 12, minute: 00));
    _endTime.add(const TimeOfDay(hour: 12, minute: 00));
    _startTimeCrtl.add(TextEditingController(text: PersianNums('12:00')));
    _endTimeCrtl.add(TextEditingController(text: PersianNums('12:00')));
    _itemCount++;
    _ids.add(-1);
    notifyListeners();
  }

  clearAll(){
    _weekday = [0];
    _startTimeCrtl = [TextEditingController(text: PersianNums('12:00'))];
    _endTimeCrtl = [TextEditingController(text: PersianNums('12:00'))];
    _startTime = [const TimeOfDay(hour: 12, minute: 00)];
    _endTime = [const TimeOfDay(hour: 12, minute: 00)];
    _itemCount = 1;
    _ids = [-1];
    _delIds = [];
    _addIndex = [];
    _taskTitleCrtl.clear();
    _taskDetailCrtl.clear();
    notifyListeners();
  }

  delete(int index){
    _weekday.removeAt(index);
    _startTime.removeAt(index);
    _endTime.removeAt(index);
    _startTimeCrtl.removeAt(index);
    _endTimeCrtl.removeAt(index);
    _itemCount--;
    if(_ids[index] != -1){
      _delIds.add(_ids[index]);
    }
    _ids.removeAt(index);
    notifyListeners();
  }


  setStartTime(int index, context) async{
    await Navigator.of(context).push(
      showPicker(
        context: context,
        value: _startTime[index],
        onChange: (newTime) => _startTime[index] = newTime,
        iosStylePicker: true,
        is24HrFormat: true,
        okText: "تایید",
        cancelText: "لغو",
        minuteLabel: "دقیقه",
        hourLabel: "ساعت",
        okStyle: TextStyle(fontFamily: "IranYekan", color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.w700),
        cancelStyle: TextStyle(fontFamily: "IranYekan", color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.w700),
          themeData: ThemeData(
            fontFamily: "DIMAMITRA",
          ),
      ),
    );

    DateTime parsedTime = intl.DateFormat.jm().parse(_startTime[index].format(context).toString());
    String formattedTime = intl.DateFormat('HH:mm').format(parsedTime);
    _startTimeCrtl[index].text = PersianNums(formattedTime);
    notifyListeners();
  }


  setEndTime(int index, context) async{
    await Navigator.of(context).push(
      showPicker(
        context: context,
        value: _endTime[index],
        onChange: (newTime) => _endTime[index] = newTime,
        iosStylePicker: true,
        is24HrFormat: true,
        okText: "تایید",
        cancelText: "لغو",
        minuteLabel: "دقیقه",
        hourLabel: "ساعت",
        okStyle: TextStyle(fontFamily: "IranYekan", color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.w700),
        cancelStyle: TextStyle(fontFamily: "IranYekan", color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.w700),
        themeData: ThemeData(
          fontFamily: "DIMAMITRA",
        ),
      ),
    );

    // var pickedTime =  await showTimePicker(
    //   initialTime: const TimeOfDay(hour: 12, minute: 00),
    //   context: context,
    //   helpText: '',
    //   cancelText: "لغو",
    //   confirmText: "تایید",
    //   minuteLabelText: "دقیقه",
    //   hourLabelText: "ساعت",
    //   builder: (context, child) {
    //     return MediaQuery(
    //       data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
    //       child: child ?? Container(),
    //     );
    //   },
    // );

    DateTime parsedTime = intl.DateFormat.jm().parse(_endTime[index].format(context).toString());
    String formattedTime = intl.DateFormat('HH:mm').format(parsedTime);
    _endTimeCrtl[index].text = PersianNums(formattedTime);
    notifyListeners();
  }

  setWeekday(int index, value){
    weekday[index] = value;
    notifyListeners();
  }

  final TextEditingController _taskTitleCrtl = TextEditingController();
  TextEditingController get taskTitleCrtl => _taskTitleCrtl;
  final TextEditingController _taskDetailCrtl = TextEditingController();
  TextEditingController get taskDetailCrtl => _taskDetailCrtl;

  onTapTextFields() {
    if(_taskTitleCrtl.selection == TextSelection.fromPosition(TextPosition(offset: _taskTitleCrtl.text.length -1))){
      _taskTitleCrtl.selection = TextSelection.fromPosition(TextPosition(offset: _taskTitleCrtl.text.length));
    }
    if(_taskDetailCrtl.selection == TextSelection.fromPosition(TextPosition(offset: _taskDetailCrtl.text.length -1))){
      _taskDetailCrtl.selection = TextSelection.fromPosition(TextPosition(offset: _taskDetailCrtl.text.length));
    }
    notifyListeners();
  }

  Future<bool> createTask(context) async {
    FocusScope.of(context).unfocus();
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
      if(_taskTitleCrtl.text.trim().isEmpty || _taskDetailCrtl.text.trim().isEmpty) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: ".لطفا فیلد ها را پر کنید",
          title: "!فیلد خالی",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else if(_itemCount == 0) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: ".لطفا زمان بندی ثبت کنید",
          title: "!بدون زمان بندی",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else if (!await loginUser(box.get('user'), box.get('pass'))){
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
        for(int i = 0; i<_itemCount; i++){
          addTask(box.get('user'), box.get('pass'), _taskTitleCrtl.text.trim(), _weekday[i].toString(), _taskDetailCrtl.text.trim(),
              '${EnglishNums( _startTimeCrtl[i].text)}:00', '${EnglishNums( _endTimeCrtl[i].text)}:00', '0');
        }
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: ".کار جدید با موفقیت ثبت شد",
          title: "!ثبت شد",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        flag = true;
      }
    }
    return flag;
  }




  setEditView(String title, String details) async {
    var box = await Hive.openBox('userInfo');
    List tasks = await box.get('tasks');

    _weekday.clear();
    _startTime.clear();
    _endTime.clear();
    _startTimeCrtl.clear();
    _endTimeCrtl.clear();
    _itemCount = 0;
    _addIndex.clear();
    _delIds.clear();
    _ids.clear();

    _taskTitleCrtl.text = PersianNums(title);
    _taskDetailCrtl.text = PersianNums(details);
    for(int i = 0; i<tasks.length; i++){
      if(tasks[i]['taskTitle'] == title && tasks[i]['taskDetails'] == details) {
        _ids.add(tasks[i]['ID']);
        _weekday.add(int.parse(tasks[i]['weekday']));
        _startTime.add(TimeOfDay(hour:int.parse(tasks[i]['startTime'].split(":")[0]),minute: int.parse(tasks[i]['startTime'].split(":")[1])));
        _endTime.add(TimeOfDay(hour:int.parse(tasks[i]['endTime'].split(":")[0]),minute: int.parse(tasks[i]['endTime'].split(":")[1])));
        _startTimeCrtl.add(TextEditingController(text: PersianNums(tasks[i]['startTime'].substring(0, tasks[i]['startTime'].length - 3))));
        _endTimeCrtl.add(TextEditingController(text: PersianNums(tasks[i]['endTime'].substring(0, tasks[i]['endTime'].length - 3))));
        _itemCount++;
      }
    }
  }

  Future<bool> editTask(context) async {
    FocusScope.of(context).unfocus();
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
      if(_taskTitleCrtl.text.trim().isEmpty || _taskDetailCrtl.text.trim().isEmpty) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: ".لطفا فیلد ها را پر کنید",
          title: "!فیلد خالی",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else if(_itemCount == 0) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: ".لطفا زمان بندی ثبت کنید",
          title: "!بدون زمان بندی",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        Navigator.pop(context);
      } else if (!await loginUser(box.get('user'), box.get('pass'))){
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
        for(int i = 0; i<_ids.length; i++){
          if (_ids[i] != -1){
            updateTask(box.get('user'), box.get('pass'), _ids[i].toString(), _taskTitleCrtl.text.trim(), _weekday[i].toString(), _taskDetailCrtl.text.trim(),
                '${EnglishNums( _startTimeCrtl[i].text)}:00', '${EnglishNums( _endTimeCrtl[i].text)}:00');
          } else {
            _addIndex.clear;
            _addIndex.add(i);
          }
        }
        for(int i = 0; i<_addIndex.length; i++){
          addTask(box.get('user'), box.get('pass'), _taskTitleCrtl.text.trim(), _weekday[_addIndex[i]].toString(), _taskDetailCrtl.text.trim(),
              '${EnglishNums( _startTimeCrtl[_addIndex[i]].text)}:00', '${EnglishNums( _endTimeCrtl[_addIndex[i]].text)}:00', '0');
        }
        for(int i = 0; i<_delIds.length; i++){
          if (_delIds[i] != -1){
            deleteTask(box.get('user'), box.get('pass'), _delIds[i].toString());
          }
        }
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: ".کار با موفقیت ویرایش شد",
          title: "!ثبت شد",
          confirmBtnText: "باشه",
          titleColor: Theme.of(context).secondaryHeaderColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          confirmBtnColor: Theme.of(context).primaryColor,
        );
        flag = true;
      }
    }
    return flag;
  }
}