import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
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
      body: Liked(),
    );
  }
}

class Liked extends StatelessWidget {
  const Liked({Key? key}) : super(key: key);
  Future<List<Objekat>> _getLiked() async {
    var dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    dio.interceptors.add(CookieManager(cookieJar));
    var response = await dio.get('https://vahidtest1.herokuapp.com/user');
    var details = await dio
        .get('https://vahidtest1.herokuapp.com/user/' + response.toString());
    var data = await dio.get('https://vahidtest1.herokuapp.com/vitem');
    List<Objekat> users = [];
    List<Objekat> users1 = [];
    for (var u in data.data) {
      if (u["username"] == details.data['username']) {
        if (u["liked"] == 'liked') {
          Objekat user = Objekat(u["image"], u["title"], u["description"],
              u["tag"], u["username"], u["liked"]);
          users.add(user);
        }
      }
    }
    for (var u in data.data) {
      if (u["username"] == details.data['partner']) {
        if (u["liked"] == 'liked') {
          Objekat user = Objekat(u["image"], u["title"], u["description"],
              u["tag"], u["username"], u["liked"]);
          users1.add(user);
        }
      }
    }
    List<Objekat> users2 = [];
    for (var u in users) {
      for (var d in users1) {
        if (u.title == d.title) {
          Objekat user =
              Objekat(u.url, u.title, u.opis, u.tag, u.username, u.liked);
          users2.add(user);
        }
      }
    }
    return users2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _getLiked(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].opis),
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(snapshot.data[index].url),
                      backgroundColor: Colors.transparent,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(user: snapshot.data[index])));
                    },
                  );
                });
          }
        },
      ),
    );
  }
}

class Objekat {
  final String url;
  final String title;
  final String opis;
  final String tag;
  final String username;
  final String liked;

  Objekat(this.url, this.title, this.opis, this.tag, this.username, this.liked);
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key, required this.user}) : super(key: key);

  final Objekat user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.title),
      ),
      body: Center(child: Text(user.opis)),
    );
  }
}
