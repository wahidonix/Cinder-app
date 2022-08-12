import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

Future<User> _getUser(String email) async {
  var dio = Dio();
  var details = await dio
      .get('https://vahidtest1.herokuapp.com/forgotPassword/user/' + email);
  User user = User(details.data['_id'], details.data['username'],
      details.data['email'], details.data['canChangePassword']);
  print(details);
  return user;
}

class Password extends StatefulWidget {
  const Password({Key? key}) : super(key: key);

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot password"),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/login');
              },
              tooltip: 'back to home',
            );
          },
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: email,
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    User user = await _getUser(email.text);
                    if (user.canChange == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Form(user: user)));
                    } else {
                      var dio = Dio();
                      dio.post(
                          'https://vahidtest1.herokuapp.com/forgotPassword/user/' +
                              user.email,
                          data: {'id': user.id, 'email': user.email});
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Center(child: Text('Request')),
                                content: Text('Mail has been sent',
                                    textAlign: TextAlign.center),
                                actions: <Widget>[
                                  Center(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ))),
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK')),
                                  )
                                ],
                              ));
                    }
                  },
                  child: Text('Request password change')),
            ],
          ),
        ),
      ),
    );
  }
}

class Form extends StatelessWidget {
  const Form({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    TextEditingController pass = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter new password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: pass,
            ),
            ElevatedButton(
                onPressed: () {
                  var dio = Dio();
                  dio.patch(
                      'https://vahidtest1.herokuapp.com/forgotPassword/' +
                          user.email,
                      data: {'password': pass.text, 'email': user.email});
                  Navigator.pop(context);
                },
                child: Text("Change password"))
          ],
        ),
      ),
    );
  }
}

class User {
  final String username;
  final String id;
  final String email;
  final bool? canChange;

  User(this.id, this.username, this.email, this.canChange);
}
