import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _cnfPassword = TextEditingController();
  final _password = TextEditingController();

  postData(String user, String pass, String email) async {
    if (_password.text == _cnfPassword.text) {
      print('pass match');
      try {
        var dio = Dio();
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        var cookieJar = PersistCookieJar(
            ignoreExpires: true,
            storage: FileStorage(appDocPath + "/.cookies/"));
        dio.interceptors.add(CookieManager(cookieJar));
        var response =
            await Dio().post('https://vahidtest1.herokuapp.com/signup', data: {
          'email': email,
          'username': user,
          'password': pass,
          'partner': 'NaN',
          'verified': false
        });
        print(response);
        print(await cookieJar
            .loadForRequest(Uri.parse("https://vahidtest1.herokuapp.com")));
        Navigator.popAndPushNamed(context, '/login');
      } on DioError catch (e) {
        Map err = e.response?.data['errors'];
        String emailErr = err['email'].toString();
        String passErr = err['password'].toString();
        String userErr = err['username'].toString();
        print(emailErr + '\n' + passErr + '\n' + userErr);
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Center(child: Text('Registration error')),
                  content: Text(emailErr + '\n' + passErr + '\n' + userErr,
                      textAlign: TextAlign.center),
                  actions: <Widget>[
                    Center(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK')),
                    )
                  ],
                ));
      }
    } else {
      print('pass don\'t match');
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Center(child: Text('Registration error')),
                content: const Text('Passwords don`t match',
                    textAlign: TextAlign.center),
                actions: <Widget>[
                  Center(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK')),
                  )
                ],
              ));
      _password.text = '';
      _cnfPassword.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Signup',
                    textScaleFactor: 2,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: _username,
                    decoration: const InputDecoration(hintText: 'username'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: _email,
                    decoration: const InputDecoration(hintText: 'email'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(hintText: 'password'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: _cnfPassword,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration:
                        const InputDecoration(hintText: 'confirm password'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    onPressed: () {
                      postData(_username.text, _password.text, _email.text);
                    },
                    child: const Text("Sign up"),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, '/login');
                          },
                          child: const Text('Sign in')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
