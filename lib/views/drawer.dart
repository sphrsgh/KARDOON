import 'package:flutter/material.dart';
import 'package:kardoon/providers/DrawerProvider.dart';
import 'package:kardoon/providers/EditUserProvider.dart';
import 'package:kardoon/providers/hiveProvider.dart';
import 'package:kardoon/views/EditUserForm.dart';
import 'package:provider/provider.dart';

import 'EditPassForm.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: 230.0,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).backgroundColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          minRadius: 30.0,
                          maxRadius: 30.0,
                          child: Text('${context.watch<DrawerProvider>().username[0]}', style: const TextStyle(fontSize: 40.0),textAlign: TextAlign.center,),
                        ),
                      ),
                      Text(context.watch<DrawerProvider>().username, style: TextStyle(fontSize: 25.0, color: Theme.of(context).backgroundColor,),),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, right: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('خوش اومدی', style: TextStyle(color: Theme.of(context).backgroundColor, fontWeight: FontWeight.w200, fontSize: 16.0,),),
                          Text('${context.watch<DrawerProvider>().fullName}!', style: TextStyle(color: Theme.of(context).backgroundColor, fontSize: 16.0,),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: IconButton(
                        onPressed: () => Scaffold.of(context).isDrawerOpen? Scaffold.of(context).closeDrawer():Null,
                        icon: Icon(Icons.arrow_back_ios_rounded, size: 18.0, color: Theme.of(context).backgroundColor,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListBody(
            children: [
              ListTile(
                onTap: () {
                  context.read<EditUserProvider>().fillTextFields();
                  Scaffold.of(context).isDrawerOpen? Scaffold.of(context).closeDrawer():Null;
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditUserForm()));
                },
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ویرایش', style: TextStyle(color: Theme.of(context).secondaryHeaderColor,),),
                      Icon(Icons.manage_accounts_rounded, color: Theme.of(context).secondaryHeaderColor,),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  context.read<EditUserProvider>().fillTextFields();
                  Scaffold.of(context).isDrawerOpen? Scaffold.of(context).closeDrawer():Null;
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditPassForm()));
                },
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('تغییر رمز عبور', style: TextStyle(color: Theme.of(context).secondaryHeaderColor,),),
                      Icon(Icons.lock_reset_rounded, color: Theme.of(context).secondaryHeaderColor,),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () async => context.read<HiveProvider>().logOut(context),
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('خروج از حساب', style: TextStyle(color: Theme.of(context).secondaryHeaderColor,),),
                      Icon(Icons.logout_rounded, color: Theme.of(context).secondaryHeaderColor,),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () async => context.read<HiveProvider>().deleteAccount(context),
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('حذف حساب کاربری', style: TextStyle(color: Colors.red,),),
                      Icon(Icons.delete_forever_rounded, color: Colors.red,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



// const SizedBox(height: 50.0),
// MaterialButton(
// onPressed: () async => context.read<HiveProvider>().logOut(context),
// color: Colors.white,
// child: const Text("LogOut"),
// // icon: Icon(Icons.logout_rounded),
// )