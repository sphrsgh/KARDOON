import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/EditUserProvider.dart';
import '../providers/homeProvider.dart';
import '../providers/taskProvider.dart';
import 'home.dart';

class EditUserForm extends StatefulWidget {
  const EditUserForm({Key? key}) : super(key: key);

  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> with TickerProviderStateMixin {
  @override


  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<WeekBtnProvider>().backToday();
        context.read<taskItemsProvider>().clearAll();
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
        return Future(()=> false);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            shadowColor: Colors.transparent,
            scrolledUnderElevation: 0.0,
            centerTitle: true,
            title: Text(
              'ویرایش اطلاعات',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            leading: null,
            // IconButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
            //   },
            //   icon: const Icon(Icons.arrow_back_rounded),
            //   padding: const EdgeInsets.all(20.0),
            //   splashRadius: 20.0,
            // ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40.0),
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
                                  Icon(Icons.person_rounded, color: Theme.of(context).secondaryHeaderColor,),
                                  VerticalDivider(
                                    color: Theme.of(context).secondaryHeaderColor,
                                    thickness: 0.7,
                                    indent: 10.0,
                                    endIndent: 10.0,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: context.watch<EditUserProvider>().editNameCtrl,
                                      onTap: () => context.read<EditUserProvider>().onTapTextFields(),
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.justify,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      maxLength: 50,
                                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Theme.of(context).secondaryHeaderColor,
                                      ),
                                      // inputFormatters: <TextInputFormatter>[
                                      //   FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_\-_.\.;]+$')),
                                      // ],
                                      decoration: const InputDecoration(
                                        hintText: 'نام و نام خانوادگی',
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40.0),
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
                                  Icon(Icons.person_rounded, color: Theme.of(context).secondaryHeaderColor,),
                                  VerticalDivider(
                                    color: Theme.of(context).secondaryHeaderColor,
                                    thickness: 0.7,
                                    indent: 10.0,
                                    endIndent: 10.0,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: context.watch<EditUserProvider>().editUserCtrl,
                                      onTap: () => context.read<EditUserProvider>().onTapTextFields(),
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.justify,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      maxLength: 30,
                                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Theme.of(context).secondaryHeaderColor,
                                      ),
                                      // inputFormatters: <TextInputFormatter>[
                                      //   FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_\-_.\.;]+$')),
                                      // ],
                                      decoration: const InputDecoration(
                                        hintText: 'نام کاربری',
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 100.0),
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
                                  Icon(Icons.mail_rounded, color: Theme.of(context).secondaryHeaderColor,),
                                  VerticalDivider(
                                    color: Theme.of(context).secondaryHeaderColor,
                                    thickness: 0.7,
                                    indent: 10.0,
                                    endIndent: 10.0,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: context.watch<EditUserProvider>().editEmailCtrl,
                                      onTap: () => context.read<EditUserProvider>().onTapTextFields(),
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.justify,
                                      keyboardType: TextInputType.emailAddress,
                                      maxLength: 320,
                                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Theme.of(context).secondaryHeaderColor,
                                      ),
                                      // inputFormatters: <TextInputFormatter>[
                                      //   FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_\-_.\.;]+$')),
                                      // ],
                                      decoration: const InputDecoration(
                                        hintText: 'ایمیل',
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
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
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
                              onPressed: () => context.read<EditUserProvider>().setEditUser(context),
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text(
                                'ویرایش',
                                style: TextStyle(
                                  color: Theme.of(context).backgroundColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          Container(
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
                              onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
                            },
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text(
                                'انصراف',
                                style: TextStyle(
                                  color: Theme.of(context).backgroundColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


