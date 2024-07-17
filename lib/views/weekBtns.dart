import 'package:flutter/material.dart';
import 'package:kardoon/backends/calendar.dart';
import 'package:kardoon/providers/taskProvider.dart';
import 'package:provider/provider.dart';
import 'package:kardoon/providers/homeProvider.dart';
import '../backends/persianNum.dart';

int _theWeekday = getToWeekday();
setTheWeekDay(int num){
  _theWeekday = num;
}
getTheWeekDay(){
  return _theWeekday;
}

class WeekArea extends StatelessWidget {
  const WeekArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        textDirection: TextDirection.rtl,
        children: const [
          WeekBtn(
            weekDayNum: 0,
            title: 'شنبه',
          ),
          WeekBtn(
            weekDayNum: 1,
            title: 'یکشنبه',
          ),
          WeekBtn(
            weekDayNum: 2,
            title: 'دوشنبه',
          ),
          WeekBtn(
            weekDayNum: 3,
            title: 'سه شنبه',
          ),
          WeekBtn(
            weekDayNum: 4,
            title: 'چهارشنبه',
          ),
          WeekBtn(
            weekDayNum: 5,
            title: 'پنجشنبه',
          ),
          WeekBtn(
            weekDayNum: 6,
            title: 'جمعه',
          ),
        ],
      ),
    );
  }
}


class WeekBtn extends StatelessWidget {
  const WeekBtn({Key? key, required this.weekDayNum, required this.title,}) : super(key: key);

  final int weekDayNum;
  final String title;

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;

    return MaterialButton(
      onPressed: () {
        _theWeekday = weekDayNum;
        context.read<taskItemsProvider>().closeAll();
        context.read<WeekBtnProvider>().switchBtn(weekDayNum);
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      elevation: 0.0,
      minWidth: (width-40)/7,
      height: 110.0,
      color: Color(context.watch<WeekBtnProvider>().backColor[weekDayNum]),
      padding: const EdgeInsets.all(0.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      textColor: Color(context.watch<WeekBtnProvider>().textColor[weekDayNum]),
      child: SizedBox(
        height: 75.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 7.0,),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w400,
                wordSpacing: -2,
              ),
            ),
            const SizedBox(height: 10.0,),
            Text(
              PersianNums(getPerDMY('d', weekDayNum, context.watch<WeekBtnProvider>().dayChange)),
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
