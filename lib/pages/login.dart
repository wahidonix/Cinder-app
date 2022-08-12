import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  postData(String user, String pass) async {
    try {
      /*
      print(response.headers['Set-Cookie']);*/
      var dio = Dio();
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      var cookieJar = PersistCookieJar(
          ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
      dio.interceptors.add(CookieManager(cookieJar));
      var response = await dio.post('https://vahidtest1.herokuapp.com/login',
          data: {'email': user, 'password': pass});
      // Print cookies
      print(response);
      print(await cookieJar
          .loadForRequest(Uri.parse("https://vahidtest1.herokuapp.com")));
      Navigator.popAndPushNamed(context, '/home');
    } on DioError catch (e) {
      Map err = e.response?.data['errors'];
      String emailErr = err['email'].toString();
      String passErr = err['password'].toString();
      String verErr = err['verification'].toString();
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Center(child: Text('Login error')),
                content: Text(emailErr + '\n' + passErr + '\n' + verErr,
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
                  const Image(
                    image: AssetImage('assets/Cinder_logo.png'),
                    height: 200,
                    width: 200,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: _username,
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
                      //Navigator.popAndPushNamed(context, '/home');
                      postData(_username.text, _password.text);
                    },
                    child: const Text("Log in"),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/forgotPass');
                      },
                      child: Text('Forgot password?')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account? '),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text('Sign up')),
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
