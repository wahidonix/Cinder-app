import 'package:cinder_v2/pages/forgot_password.dart';
import 'package:cinder_v2/pages/loading.dart';
import 'package:cinder_v2/pages/signup.dart';
import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/home.dart';
import 'pages/favorites.dart';
import 'pages/account.dart';
import 'themes/themes.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: lightTheme,
    initialRoute: '/',
    routes: {
      '/': (context) => const Loading(),
      '/forgotPass': (context) => const Password(),
      '/login': (context) => const Login(),
      '/home': (context) => const Home(),
      '/favorites': (context) => const Favorites(),
      '/account': (context) => const Account(),
      '/signup': (context) => const Signup(),
    },
  ));
}
