import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kardoon/providers/accountProvider.dart';
import 'package:provider/provider.dart';

import '../providers/hiveProvider.dart';

class accForm extends StatefulWidget {
  const accForm({Key? key}) : super(key: key);

  @override
  State<accForm> createState() => _accFormState();
}

class _accFormState extends State<accForm> with TickerProviderStateMixin {
  @override


  Widget build(BuildContext context) {
    TabController tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    Icon passVisibility = Icon(Icons.visibility_off_rounded, color: Theme.of(context).secondaryHeaderColor,);
    if (context.watch<AccProvider>().visibility) {
      passVisibility = Icon(Icons.visibility_rounded, color: Theme.of(context).secondaryHeaderColor,);
    } else {
      passVisibility = Icon(Icons.visibility_off_rounded, color: Theme.of(context).secondaryHeaderColor,);
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            shadowColor: Colors.transparent,
            scrolledUnderElevation: 0.0,
            centerTitle: true,
            title: Text(
              'به کــاردون خــوش آمدید!',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            leading: const Icon(null),
            bottom: const TabBar(
              tabs: [
                Tab(
                  height: 40.0,
                  child: SizedBox(
                    width: 140.0,
                    child: Center(
                      child: Text(
                        'ورود',
                        style: TextStyle(
                          height: -0.20,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
                Tab(
                  height: 40.0,
                  child: SizedBox(
                    width: 140.0,
                    child: Center(
                      child: Text(
                        'ثبت نام',
                        style: TextStyle(
                          height: -0.20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: TabBarView(
              children: [
                Padding(
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
                              Padding( // username
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
                                          controller: context.watch<AccProvider>().loginUserCtrl,
                                          onTap: () => context.read<AccProvider>().onTapTextFields(),
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
                                      Icon(Icons.lock_rounded, color: Theme.of(context).secondaryHeaderColor,),
                                      VerticalDivider(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        thickness: 0.7,
                                        indent: 10.0,
                                        endIndent: 10.0,
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          controller: context.watch<AccProvider>().loginPassCtrl,
                                          onTap: () => context.read<AccProvider>().onTapTextFields(),
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.justify,
                                          keyboardType: TextInputType.visiblePassword,
                                          obscureText: !context.watch<AccProvider>().visibility,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          maxLength: 255,
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Theme.of(context).secondaryHeaderColor,
                                          ),
                                          // inputFormatters: <TextInputFormatter>[
                                          //   FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_\-!#$%^&*()_+-=/.,><;? \.;]+$')),
                                          // ],
                                          decoration: const InputDecoration(
                                            hintText: 'رمز عبور',
                                            hintTextDirection: TextDirection.rtl,
                                            focusedBorder: InputBorder.none,
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(bottom: 5.0, right: 2.0),
                                            counterText: "",
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0,),
                                      MaterialButton(
                                        onPressed: () => context.read<AccProvider>().changeVisibility(),
                                        height: 23.0,
                                        minWidth: 23.0,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        padding: EdgeInsets.zero,
                                        child: passVisibility,
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
                                onPressed: () => context.read<AccProvider>().login(context),
                                color: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Text(
                                  'ورود',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0,),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
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
                                          controller: context.watch<AccProvider>().nameCtrl,
                                          onTap: () => context.read<AccProvider>().onTapTextFields(),
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
                                          controller: context.watch<AccProvider>().signupUserCtrl,
                                          onTap: () => context.read<AccProvider>().onTapTextFields(),
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
                                      Icon(Icons.lock_rounded, color: Theme.of(context).secondaryHeaderColor,),
                                      VerticalDivider(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        thickness: 0.7,
                                        indent: 10.0,
                                        endIndent: 10.0,
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          controller: context.watch<AccProvider>().signupPassCtrl,
                                          onTap: () => context.read<AccProvider>().onTapTextFields(),
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.justify,
                                          keyboardType: TextInputType.visiblePassword,
                                          textInputAction: TextInputAction.next,
                                          obscureText: !context.watch<AccProvider>().visibility,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          maxLength: 255,
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Theme.of(context).secondaryHeaderColor,
                                          ),
                                          // inputFormatters: <TextInputFormatter>[
                                          //   FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_\-!#$%^&*()_+-=/.,><;? \.;]+$')),
                                          // ],
                                          decoration: const InputDecoration(
                                            hintText: 'رمز عبور',
                                            hintTextDirection: TextDirection.rtl,
                                            focusedBorder: InputBorder.none,
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(bottom: 5.0, right: 2.0),
                                            counterText: "",
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0,),
                                      MaterialButton(
                                        onPressed: () => context.read<AccProvider>().changeVisibility(),
                                        height: 23.0,
                                        minWidth: 23.0,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        padding: EdgeInsets.zero,
                                        child: passVisibility,
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
                                      Icon(Icons.lock_rounded, color: Theme.of(context).secondaryHeaderColor,),
                                      VerticalDivider(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        thickness: 0.7,
                                        indent: 10.0,
                                        endIndent: 10.0,
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          controller: context.watch<AccProvider>().repPassCtrl,
                                          onTap: () => context.read<AccProvider>().onTapTextFields(),
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.justify,
                                          keyboardType: TextInputType.visiblePassword,
                                          textInputAction: TextInputAction.next,
                                          obscureText: !context.watch<AccProvider>().visibility,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          maxLength: 255,
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Theme.of(context).secondaryHeaderColor,
                                          ),
                                          // inputFormatters: <TextInputFormatter>[
                                          //   FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_\-!#$%^&*()_+-=/.,><;? \.;]+$')),
                                          // ],
                                          decoration: const InputDecoration(
                                            hintText: 'تکرار رمز عبور',
                                            hintTextDirection: TextDirection.rtl,
                                            focusedBorder: InputBorder.none,
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(bottom: 5.0, right: 2.0),
                                            counterText: "",
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0,),
                                      MaterialButton(
                                        onPressed: () => context.read<AccProvider>().changeVisibility(),
                                        height: 23.0,
                                        minWidth: 23.0,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        padding: EdgeInsets.zero,
                                        child: passVisibility,
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
                                          controller: context.watch<AccProvider>().emailCtrl,
                                          onTap: () => context.read<AccProvider>().onTapTextFields(),
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
                                onPressed: () => context.read<AccProvider>().signup(context),
                                color: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Text(
                                  'ایـــجـــاد',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0,),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HiveProvider>().isOffline(context);
  }
}


