import 'package:flutter/material.dart';

class CounterProvider with ChangeNotifier {
  int _number = 0;
  String get number => _number.toString();

  increament(){
    _number++;
    notifyListeners();
  }
}

class taskItemsProvider with ChangeNotifier {
  final List _arrowIcon = [];
  final List _isExtend = [];
  get arrowIcon => _arrowIcon;
  get isExtend => _isExtend;

  add(){
    _arrowIcon.add(Icons.keyboard_arrow_down_rounded);
    _isExtend.add(false);
  }

  clearAll(){
    _arrowIcon.clear();
    _isExtend.clear();
  }

  openOrClose(int index){
    _isExtend[index] = !_isExtend[index];
    if(_isExtend[index] == false) {
      _arrowIcon[index] = Icons.keyboard_arrow_down_rounded;
    } else {
      _arrowIcon[index] = Icons.keyboard_arrow_up_rounded;
    }
    notifyListeners();
  }

  closeAll() {
    for(int i = 0; i < _arrowIcon.length; i++){
      _arrowIcon[i] = Icons.keyboard_arrow_down_rounded;
      _isExtend[i] = false;
    }
  }

}


