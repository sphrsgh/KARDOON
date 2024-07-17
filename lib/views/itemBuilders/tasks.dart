import 'package:flutter/material.dart';
import 'package:kardoon/providers/taskProvider.dart';
import 'package:kardoon/providers/homeProvider.dart';
import 'package:provider/provider.dart';
import '../../backends/persianNum.dart';
import '../../providers/scheduleItemProvider.dart';
import '../editTask.dart';

class TaskItem extends StatelessWidget {
  const TaskItem(this.homeContext, this.index, {Key? key}) : super(key: key);

  final int index;
  final homeContext;

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        color: Theme.of(context).canvasColor, // details BG Color
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                ),
              ],
            ),
            child: RawMaterialButton(
              onPressed: (){
                context.read<taskItemsProvider>().openOrClose(index);
              },
              fillColor: Theme.of(context).cardColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0, left: 10.0,),
                        child: MaterialButton(
                          onPressed: (){
                            context.read<WeekBtnProvider>().doneChange(context, index);
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          color: Theme.of(context).primaryColor,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0)),),
                          padding: const EdgeInsets.all(0.0),
                          minWidth: 40.0,
                          height: 40.0,
                          child: Icon(Icons.done_rounded,
                            color: context.watch<WeekBtnProvider>().doneList[index]=="0"? const Color(0xFF2F49D1):Colors.white,
                            size: 40.0,
                            // shadows: [ BoxShadow(
                            //   color: context.watch<taskItemsProvider>().checkColor[index],
                            //   blurRadius: 6.0,
                            //   spreadRadius: 2.0,
                            //   blurStyle: BlurStyle.solid
                            // ),],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width-220,
                        child: Column(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              PersianNums(context.watch<WeekBtnProvider>().titles[index]),
                              textDirection: TextDirection.rtl,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                                wordSpacing: -2.0,
                              ),
                            ),
                            Text(
                              PersianNums(context.watch<WeekBtnProvider>().times[index]),
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: MaterialButton(
                          onPressed: (){
                            context.read<taskItemsProvider>().openOrClose(index);
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          color: const Color(0xFFAFAFAF),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),),
                          padding: const EdgeInsets.all(1.0),
                          minWidth: 23.0,
                          height: 23.0,
                          elevation: 0.0,
                          child: Icon(context.watch<taskItemsProvider>().arrowIcon[index], color: Colors.white, size: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: MaterialButton(
                          onPressed: () async => await context.read<WeekBtnProvider>().deleteBtn(homeContext, index),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          color: const Color(0xFFFD5F52),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),),
                          padding: const EdgeInsets.all(1.0),
                          minWidth: 23.0,
                          height: 23.0,
                          elevation: 0.0,
                          child: const Icon(Icons.delete_rounded, color: Colors.white, size: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: MaterialButton(
                          onPressed: () async {
                            String title = Provider.of<WeekBtnProvider>(context, listen: false).titles[index];
                            String details = Provider.of<WeekBtnProvider>(context, listen: false).details[index];
                            context.read<ScheduleProvider>().setEditView(title, details);
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditTaskView()));
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          color: const Color(0xFFFFBE05),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),),
                          padding: const EdgeInsets.all(1.0),
                          minWidth: 23.0,
                          height: 23.0,
                          elevation: 0.0,
                          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: context.watch<taskItemsProvider>().isExtend[index],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    PersianNums(context.watch<WeekBtnProvider>().details[index]),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      wordSpacing: -2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
