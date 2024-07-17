import 'package:flutter/material.dart';
import 'package:kardoon/backends/calendar.dart';
import 'package:kardoon/main.dart';
import 'package:kardoon/providers/DrawerProvider.dart';
import 'package:kardoon/providers/hiveProvider.dart';
import 'package:kardoon/providers/taskProvider.dart';
import 'package:kardoon/providers/homeProvider.dart';
import 'package:kardoon/views/addTask.dart';
import 'package:kardoon/views/drawer.dart';
import 'package:kardoon/views/itemBuilders/tasks.dart';
import 'package:kardoon/views/weekBtns.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/quickalert.dart';
import '../backends/persianNum.dart';
import '../providers/scheduleItemProvider.dart';
import 'account.dart';

bool firstStart = true;
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  DateTime backPressTime = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if(now.difference(backPressTime)< const Duration(seconds: 2)){
      return Future(() => true);
    }
    else{
      backPressTime = DateTime.now();
      Fluttertoast.showToast(
        msg: "برای خروج دوباره دکمه بازگشت را بزنید.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: const Color(0xFF5B5B5B),
      );
      return Future(()=> false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = context.watch<WeekBtnProvider>().titles.length;
    if (itemCount < 1){
      itemCount = 1;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            shadowColor: Colors.transparent,
            backgroundColor: Theme.of(context).backgroundColor,
            foregroundColor: Colors.black,
            flexibleSpace: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu_rounded),
                    padding: const EdgeInsets.all(20.0),
                    splashRadius: 20.0,
                  ),),
                  const IconButton(
                    onPressed: null,
                    icon: Icon(null),
                    // const Icon(Icons.search_rounded),
                    padding: EdgeInsets.all(20.0),
                    splashRadius: 20.0,
                  ),
                ],
              ),
            ),
            leading: const Icon(null),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0,),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      '  ${getPerDMY('m', getTheWeekDay(), context.watch<WeekBtnProvider>().dayChange)} ${PersianNums(getPerDMY('y', getTheWeekDay(), context.watch<WeekBtnProvider>().dayChange))}',
                      style: TextStyle( // MonthAndYear
                        fontSize: 32.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        context.read<ScheduleProvider>().clearAll();
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const addTaskView()));
                      },
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0)),),
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      elevation: 10.0,
                      child: Row(
                        textDirection: TextDirection.ltr,
                        children: const [
                          Text(
                            'افزودن کار',
                            textWidthBasis: TextWidthBasis.parent,
                            style: TextStyle(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          Icon(
                            Icons.add_rounded,
                            size: 22.0,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                const WeekArea(),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        context.read<WeekBtnProvider>().nextPrevWeek(-7);
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          Text(' هفته قبل',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_back_rounded,
                            size: 15.0,
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        context.read<WeekBtnProvider>().backToday();
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      elevation: 10.0,
                      child: const Text(
                        'برگشت به امروز',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        context.read<WeekBtnProvider>().nextPrevWeek(7);
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 15.0,
                          ),
                          Text('هفته بعد ',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'لیست کار  ',
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: itemCount,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      context.read<taskItemsProvider>().add();
                      if (context.watch<WeekBtnProvider>().titles.isEmpty){
                        return Center(
                          child: Text('کاری برای نمایش وجود ندارد.', style: TextStyle(color: Theme.of(context).secondaryHeaderColor),),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          child: TaskItem(_scaffoldKey.currentContext, index),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          drawer: const HomeDrawer(),
          // drawerEnableOpenDragGesture: true,
          drawerScrimColor: Colors.black54,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if(firstStart) {
      context.read<HiveProvider>().isOffline(context);
      firstStart = false;
    }
    context.read<DrawerProvider>().setInfo();
    context.read<WeekBtnProvider>().switchBtn(getToWeekday());
  }

}



