import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';

import '../../providers/scheduleItemProvider.dart';

class SchWeeklyItem extends StatelessWidget {
  const SchWeeklyItem(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 20.0),
          child: Container(
            width: width-50,
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor,
                  blurRadius: 7.0,
                  spreadRadius: -0.50,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 10.0,  left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Text('  روز هفته',
                        style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      WeekDaysDropDown(index),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            '  زمان شروع',
                            style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                            width: 50.0,
                            child: TextField(
                              onTap: () => context.read<ScheduleProvider>().setStartTime(index, context),
                              controller: context.watch<ScheduleProvider>().startTimeCrtl[index],
                              readOnly: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).backgroundColor,
                                contentPadding: const EdgeInsets.all(0.0),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            '  زمان پایان',
                            style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                            width: 50.0,
                            child: TextField(
                              onTap: () => context.read<ScheduleProvider>().setEndTime(index, context),
                              controller: context.watch<ScheduleProvider>().endTimeCrtl[index],
                              readOnly: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).backgroundColor,
                                contentPadding: const EdgeInsets.all(0.0),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 30.0),
              child: MaterialButton(
                onPressed: () => context.read<ScheduleProvider>().delete(index),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                color: const Color(0xFFFD5F52),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)),),
                padding: const EdgeInsets.all(1.0),
                minWidth: 20.0,
                height: 20.0,
                elevation: 5.0,
                child: const Icon(Icons.clear_rounded, color: Colors.white, size: 20.0),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class WeekDaysDropDown extends StatelessWidget {
  const WeekDaysDropDown(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          items: [
            DropdownMenuItem(value: 0, child: Row(textDirection: TextDirection.rtl, children: [Text(
              'شنبه',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'IranYekan',
              ),
            ),],),),
            DropdownMenuItem(value: 1, child: Row(textDirection: TextDirection.rtl, children: [Text(
              'یکشنبه',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'IranYekan',
              ),
            ),],),),
            DropdownMenuItem(value: 2, child: Row(textDirection: TextDirection.rtl, children: [Text(
              'دوشنبه',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'IranYekan',
              ),
            ),],),),
            DropdownMenuItem(value: 3, child: Row(textDirection: TextDirection.rtl, children: [Text(
              'سه شنبه',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'IranYekan',
              ),
            ),],),),
            DropdownMenuItem(value: 4, child: Row(textDirection: TextDirection.rtl, children: [Text(
              'چهارشنبه',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'IranYekan',
              ),
            ),],),),
            DropdownMenuItem(value: 5, child: Row(textDirection: TextDirection.rtl, children: [Text(
              'پنجشنبه',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'IranYekan',
              ),
            ),],),),
            DropdownMenuItem(value: 6, child: Row(textDirection: TextDirection.rtl, children: [Text(
              'جمعه',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'IranYekan',
              ),
            ),],),),
          ],

          value: context.watch<ScheduleProvider>().weekday[index],
          buttonWidth: 150.0,
          buttonHeight: 25.0,
          isExpanded: true,
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor,),
          buttonPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          dropdownPadding: EdgeInsets.zero,
          itemHeight: 40.0,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Theme.of(context).secondaryHeaderColor,),
          buttonDecoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(7.0),),
          ),
          dropdownDecoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(7.0),),
          ),
          onChanged: (value){
            context.read<ScheduleProvider>().setWeekday(index, value);
          },
        ),
      ),
    );
  }
}
