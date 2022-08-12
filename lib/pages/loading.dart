import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  checkUser() async {
    var dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    dio.interceptors.add(CookieManager(cookieJar));
    var response = await cookieJar
        .loadForRequest(Uri.parse("hhttps://vahidtest1.herokuapp.com"));
    print(response.toString());
    if (response.toString() == '[]') {
      print('if');
      Navigator.popAndPushNamed(context, '/login');
    } else {
      try {
        var response = await dio.get("https://vahidtest1.herokuapp.com/user");
        print(response);
        Navigator.popAndPushNamed(context, '/home');
      } on DioError {
        print('dio error');
        Navigator.popAndPushNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUser();
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
