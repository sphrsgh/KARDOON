import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kardoon/providers/hiveProvider.dart';
import 'package:kardoon/providers/taskProvider.dart';
import 'package:provider/provider.dart';
import '../providers/homeProvider.dart';
import '../providers/scheduleItemProvider.dart';
import 'home.dart';
import 'itemBuilders/scheduleItems.dart';

class EditTaskView extends StatelessWidget {
  const EditTaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<WeekBtnProvider>().backToday();
        context.read<taskItemsProvider>().clearAll();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomeView()));
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          flexibleSpace: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const IconButton(
                  onPressed: null,
                  icon: Icon(null),
                  padding: EdgeInsets.all(20.0),
                ),
                Text(
                  'ویرایش کار',
                  style: TextStyle(fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<WeekBtnProvider>().backToday();
                    context.read<taskItemsProvider>().clearAll();
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView())); // add to onwillpop too
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  padding: const EdgeInsets.all(20.0),
                  splashRadius: 20.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          leading: const Icon(null),
        ),
        body: Column(
          children: [
            const TitleDetails(),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0),),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Scrollbar(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 30.0, right: 40.0),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'لیست زمــان بنــدی',
                                    style: TextStyle(
                                      color: Theme.of(context).secondaryHeaderColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                      wordSpacing: -2,
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      context.read<ScheduleProvider>().add();
                                    },
                                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                                    minWidth: 0.0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_rounded,
                                          size: 16.0,
                                          color: Theme.of(context).secondaryHeaderColor,
                                        ),
                                        const SizedBox(width: 3.0,),
                                        Text(
                                          'افـــزودن',
                                          style: TextStyle(
                                            color: Theme.of(context).secondaryHeaderColor,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: context.watch<ScheduleProvider>().itemCount,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                    child: SchWeeklyItem(index),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 40.0,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 7.0,
                              ),
                            ],
                          ),
                          child: MaterialButton(
                            onPressed: () async {
                              if(await context.read<ScheduleProvider>().editTask(context)) {
                                if(await context.read<HiveProvider>().reloadTasks()) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
                                }
                              }
                            },
                            color: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Text(
                              'ویرایش',
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class TitleDetails extends StatelessWidget {
  const TitleDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 30.0),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'عنــوان',
            style: TextStyle(
              fontSize: 11.0,
              color: Theme.of(context).backgroundColor,
            ),
          ),
          TextField(
            controller: context.watch<ScheduleProvider>().taskTitleCrtl,
            cursorColor: Theme.of(context).backgroundColor,
            textDirection: TextDirection.rtl,
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.justify,
            maxLength: 50,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
              fontSize: 15.0,
            ),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54,),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54,),),
              counterText: "",
            ),
          ),
          const SizedBox(height: 20.0,),
          Text(
            'جزئیــات',
            style: TextStyle(
              fontSize: 11.0,
              color: Theme.of(context).backgroundColor,
            ),
          ),
          Column(
            children: [
              TextFormField(
                controller: context.watch<ScheduleProvider>().taskDetailCrtl,
                cursorColor: Colors.white,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.justify,
                maxLength: 102400,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                  fontSize: 15.0,
                ),
                minLines: 1,
                maxLines: 10,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  counterText: "",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

