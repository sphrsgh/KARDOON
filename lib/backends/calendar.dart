import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

DateTime dateENG = DateTime.now();
String weekDayENG = DateFormat('EEEE').format(dateENG);

Jalali j = Jalali.fromDateTime(dateENG);
var monthDaysPER = [31,31,31,31,31,31,30,30,30,30,30,29];
var monthPER = ["فروردین","اردیبهشت","خرداد","تیر","مرداد","شهریور","مهر","آبـــان","آذر","دی","بهمن","اسفند"];

String getPerDMY(String DMY, int dayOfWeek, int dayChange){
  int d, m, y;
  int dc = j.weekDay*-1;
  var days = ['','','','','','',''];
  var months = ['','','','','','',''];
  var years = ['','','','','','',''];

  for (int i = 0; i<7 ; i++) {
    d = dayChange + j.day + 1;
    m = j.month;
    y = j.year;
    if(Jalali(y).isLeapYear())
      monthDaysPER[11]=30;

    d += dc;

    while (d>monthDaysPER[m-1]) {
      if(Jalali(y+1).isLeapYear())
        monthDaysPER[11]=30;
      d -= monthDaysPER[m-1];
      m += 1;
      if (m > 12) {
        m -= 12;
        y += 1;
      }
    }
    while (d<1) {
      if(Jalali(y-1).isLeapYear())
        monthDaysPER[11]=30;
      m -= 1;
      if (m < 1) {
        m += 12;
        y -= 1;
      }
      d += monthDaysPER[m-1];
    }

    dc++;
    days[i] = '$d';
    months[i] = monthPER[m-1];
    years[i] = '$y';

    monthDaysPER[11]=29;
  }
  if (DMY == 'd')
    return days[dayOfWeek];
  else if (DMY == 'm')
    return months[dayOfWeek];
  else if (DMY == 'y')
    return years[dayOfWeek];
  else
    return 'incorrect';
}

// String getWeekDayENG(){
//   return weekDayENG;
// }
//
// String getDatePER(){
//   String res = '${j.year}/${j.month}/${j.day}';
//   return res;
// }


// String getWeekDates(int day , int dayChange){
//   int d, m, y;
//   int dc = j.weekDay*-1;
//   var res = ['','','','','','',''];
//
//   for (int i = 0; i<7 ; i++) {
//     d = dayChange + j.day + 1;
//     m = j.month;
//     y = j.year;
//     if(Jalali(y).isLeapYear())
//       monthDaysPER[11]=30;
//
//     d += dc;
//
//     while (d>monthDaysPER[m-1]) {
//       if(Jalali(y+1).isLeapYear())
//         monthDaysPER[11]=30;
//       d -= monthDaysPER[m-1];
//       m += 1;
//       if (m > 12) {
//         m -= 12;
//         y += 1;
//       }
//     }
//     while (d<1) {
//       if(Jalali(y-1).isLeapYear())
//         monthDaysPER[11]=30;
//       m -= 1;
//       if (m < 1) {
//         m += 12;
//         y -= 1;
//       }
//       d += monthDaysPER[m-1];
//     }
//
//     dc++;
//     res[i] = '$y/$m/$d';
//     monthDaysPER[11]=29;
//   }
//   return res[day];
// }


// bool isEven(int dayChange){
//   int theDay = j.weekDay+1+dayChange;
//   while (theDay % 7 != 0)
//     theDay++;
//   int sum = theDay;
//   for (int i = 1 ; i<=j.month ; i++)
//     sum += monthDaysPER[i];
//   sum+= j.day;
//   return  ((sum / 7) % 2 == 0);
// }

int getToWeekday(){
  return j.weekDay-1;
}



