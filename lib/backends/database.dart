import 'dart:convert';
import 'package:http/http.dart' as http;

String _domain = 'example.com';

Future<bool> addUser(String fullname, String user, String pass, String email) async {
  var url = Uri.https(_domain,'/db/adduser.php');
  final response = await http.post(url, body: {"fullname": fullname, "username": user.trim(), "password": pass, "email": email});

  return (response.body.toString() == 'ok');
}

Future<bool> loginUser(String user, String pass) async {
  var url = Uri.https(_domain,'/db/login.php');
  final response = await http.post(url, body: {"username": user, "password": pass},);

  // print(response.body);
  return (response.body.toString() == 'ok');
}

Future<List> getTasks(String user, String pass) async {
  var url = Uri.https(_domain,'/db/gettasks.php');
  final response = await http.post(url, body: {"username": user, "password": pass});

  return json.decode(response.body); // بازگرداندن بصورت لیست
}

Future addTask(String user, String pass, String title, String weekday, String details, String startTime, String endTime, String done) async {
  var url = Uri.https(_domain,'/db/addtask.php');
  final response = await http.post(url, body: {"username": user.trim(), "password": pass, "title": title, "weekday": weekday, "details": details, "startTime": startTime, "endTime": endTime, "done": done});

  // print(response.body);
  return (response.body.toString() == 'ok');
}

Future doneUpdate(String user, String pass, String id, String done) async {
  var url = Uri.https(_domain,'/db/doneupdate.php');
  final response = await http.post(url, body: {"username": user.trim(), "password": pass, "id": id, "done": done});

  // print(response.body);
  return (response.body.toString() == 'ok');
}

Future deleteTask(String user, String pass, String id) async {
  var url = Uri.https(_domain,'/db/deletetask.php');
  final response = await http.post(url, body: {"username": user.trim(), "password": pass, "id": id});

  // print(response.body);
  return (response.body.toString() == 'ok');
}

Future updateTask(String user, String pass, String id, String title, String weekday, String details, String startTime, String endTime) async {
  var url = Uri.https(_domain,'/db/updatetask.php');
  final response = await http.post(url, body: {"username": user.trim(), "password": pass, "id": id, "title": title, "weekday": weekday, "details": details, "startTime": startTime, "endTime": endTime});

  // print(response.body);
  return (response.body.toString() == 'ok');
}

Future<List> getInfo(String user, String pass) async { // check if order by in query works
  var url = Uri.https(_domain,'/db/getinfo.php');
  final response = await http.post(url, body: {"username": user, "password": pass});

  return json.decode(response.body);
}

Future<bool> uniqueUser(String user) async {
  var url = Uri.https(_domain,'/db/unique.php');
  final response = await http.post(url, body: {"username": user});

  // print(response.body);
  return (response.body.toString() == 'ok');
}

Future deleteUser(String user, String pass, String userid) async {
  var url = Uri.https(_domain,'/db/deleteuser.php');
  final response = await http.post(url, body: {"username": user.trim(), "password": pass, "userid": userid});

  // print(response.body);
  return (response.body.toString() == 'ok');
}

Future updateUser(String user, String pass, String id, String fullName, String newUsername, String email) async {
  var url = Uri.https(_domain,'/db/updateuser.php');
  final response = await http.post(url, body: {"username": user.trim(), "password": pass, "id": id, "fullname": fullName, "newusername": newUsername, "email": email});

  // print(response.body);
  return (response.body.toString() == 'ok');
}

Future updatePass(String user, String pass, String id, String newPass) async {
  var url = Uri.https(_domain,'/db/updatepass.php');
  final response = await http.post(url, body: {"username": user.trim(), "password": pass, "id": id, "newpassword": newPass});

  // print(response.body);
  return (response.body.toString() == 'ok');
}

// Future<List> getData() async {
//
//   var url = Uri.https(_domain,'/db/getdata.php');
//   final response = await http.post(url, body:{});
//
//   return json.decode(response.body);
//
// }


