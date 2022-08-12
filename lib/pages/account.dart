import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Future<User> _getUser() async {
    var dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    dio.interceptors.add(CookieManager(cookieJar));
    var response = await dio.get('https://vahidtest1.herokuapp.com/user');
    // Print cookies
    print(response);
    var details = await dio
        .get('https://vahidtest1.herokuapp.com/user/' + response.toString());
    print(details);
    User user = User(details.data['_id'], details.data['username'],
        details.data['email'], details.data['partner']);
    return user;
  }

  _addPartner(String user, String code) async {
    var dio = Dio();
    var response = await dio.patch(
        'https://vahidtest1.herokuapp.com/partner/' + code,
        data: {'username': user});

    print(response);
  }

  _removePartner(String user) async {
    var dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    dio.interceptors.add(CookieManager(cookieJar));
    var user1 = await dio.get('https://vahidtest1.herokuapp.com/user');
    var response = await dio.post(
        'https://vahidtest1.herokuapp.com/partner/' + user1.toString(),
        data: {'username': user});
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    final _code = TextEditingController();
    _getUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/home');
              },
              tooltip: 'back to home',
            );
          },
        ),
      ),
      body: FutureBuilder(
          future: _getUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data.partner == 'NaN') {
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Username',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2,
                              )),
                          Text(
                            snapshot.data.username,
                            style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 2,
                                fontSize: 28),
                          ),
                          const Text('e-mail',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2,
                              )),
                          Text(
                            snapshot.data.email,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 2,
                                fontSize: 28),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          const Text('partner code',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2,
                              )),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            initialValue: snapshot.data.id,
                            readOnly: true,
                            textAlign: TextAlign.center,
                            decoration:
                                const InputDecoration(hintText: 'email'),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          const Text('enter your partners code',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2,
                              )),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 230,
                                child: TextFormField(
                                  controller: _code,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter code'),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    var dio = Dio();
                                    Directory appDocDir =
                                        await getApplicationDocumentsDirectory();
                                    String appDocPath = appDocDir.path;
                                    var cookieJar = PersistCookieJar(
                                        ignoreExpires: true,
                                        storage: FileStorage(
                                            appDocPath + "/.cookies/"));
                                    var details = await dio.get(
                                        'https://vahidtest1.herokuapp.com/user/' +
                                            _code.text);
                                    if (details.data['partner'] != 'NaN') {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Center(
                                                    child: Text(
                                                        'User has already been linked!')),
                                                actions: <Widget>[
                                                  Center(
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                        ))),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
                                                        child:
                                                            const Text('OK')),
                                                  )
                                                ],
                                              ));
                                    } else if (snapshot.data.id == _code.text) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Center(
                                                    child: Text(
                                                        'You cannot link yourself!')),
                                                actions: <Widget>[
                                                  Center(
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                        ))),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
                                                        child:
                                                            const Text('OK')),
                                                  )
                                                ],
                                              ));
                                    } else {
                                      _addPartner(
                                          snapshot.data.username, _code.text);
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/account');
                                    }
                                  },
                                  child: const Text('link'))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    User user = await _getUser();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Form(user: user)));
                                  },
                                  child: Text("Change password")),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Username',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2,
                              )),
                          Text(
                            snapshot.data.username,
                            style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 2,
                                fontSize: 28),
                          ),
                          const Text('e-mail',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2,
                              )),
                          Text(
                            snapshot.data.email,
                            style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 2,
                                fontSize: 28),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          const Text('partner',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2,
                              )),
                          Text(
                            snapshot.data.partner,
                            style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 2,
                                fontSize: 28),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _removePartner(snapshot.data.partner);
                                Future.delayed(
                                    const Duration(milliseconds: 750), () {
                                  setState(() {
                                    // Here you can write your code for open new view
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, '/account');
                                  });
                                });
                              },
                              child: Text('unlink partner')),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    User user = await _getUser();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Form(user: user)));
                                  },
                                  child: Text("Change password")),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          }),
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            var dio = Dio();
            Directory appDocDir = await getApplicationDocumentsDirectory();
            String appDocPath = appDocDir.path;
            var cookieJar = PersistCookieJar(
                ignoreExpires: true,
                storage: FileStorage(appDocPath + "/.cookies/"));
            cookieJar.deleteAll();
            Navigator.popAndPushNamed(context, '/login');
          },
          child: const Text('Logout')),
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
  final String? partner;

  User(this.id, this.username, this.email, this.partner);
}
