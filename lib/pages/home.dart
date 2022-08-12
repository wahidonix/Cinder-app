import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    MovieList(),
    MusicList(),
    BookList(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/Cinder_logo.png'),
          height: 120,
          width: 120,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/favorites');
              },
              icon: const Icon(Icons.favorite),
              tooltip: 'Leads to favorites page'),
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/account');
            },
            icon: const Icon(Icons.account_circle),
            tooltip: 'Account page',
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_outlined),
            activeIcon: Icon(Icons.movie_filter_rounded),
            label: 'Movies',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            activeIcon: Icon(Icons.library_music),
            label: 'Music',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            activeIcon: Icon(Icons.menu_book),
            label: 'Books',
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[300],
        onTap: _onItemTapped,
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  const MovieList({Key? key}) : super(key: key);
  Future<List<Objekat>> _getMovies() async {
    var dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    dio.interceptors.add(CookieManager(cookieJar));
    var response = await dio.get('https://vahidtest1.herokuapp.com/user');
    var details = await dio
        .get('https://vahidtest1.herokuapp.com/user/' + response.toString());
    var data = await dio.get('https://vahidtest1.herokuapp.com/item');
    var data1 = await dio.get('https://vahidtest1.herokuapp.com/vitem');
    List<Objekat> users = [];
    for (var u in data.data) {
      bool notSame = true;
      if (u["tag"] == 'movie') {
        for (var d in data1.data) {
          if (u['title'] == d['title'] &&
              details.data['username'] == d['username']) {
            notSame = false;
          }
        }
        if (notSame) {
          Objekat user =
              Objekat(u["image"], u["title"], u["description"], u["tag"]);
          users.add(user);
        }
      }
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMovies(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key('item ${snapshot.data[index]}'),
                  background: Container(
                    color: Colors.green,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.favorite_border,
                          size: 50,
                        )),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete_forever,
                          size: 50,
                        )),
                  ),
                  onDismissed: (DismissDirection direction) {
                    if (direction == DismissDirection.startToEnd) {
                      const snackBar = SnackBar(
                        content: Text('Added to liked'),
                      );
                      _addToVoted(
                          snapshot.data[index].title,
                          snapshot.data[index].opis,
                          snapshot.data[index].url,
                          'movie',
                          'liked');
                      //snapshot.data.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      const snackBar = SnackBar(
                        content: Text('Added to disliked'),
                      );
                      _addToVoted(
                          snapshot.data[index].title,
                          snapshot.data[index].opis,
                          snapshot.data[index].url,
                          'movie',
                          'disliked');
                      //snapshot.data.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: ListTile(
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
                  ),
                );
              });
        }
      },
    );
  }
}

class MusicList extends StatelessWidget {
  const MusicList({Key? key}) : super(key: key);
  Future<List<Objekat>> _getMovies() async {
    var dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    dio.interceptors.add(CookieManager(cookieJar));
    var response = await dio.get('https://vahidtest1.herokuapp.com/user');
    var details = await dio
        .get('https://vahidtest1.herokuapp.com/user/' + response.toString());
    var data = await dio.get('https://vahidtest1.herokuapp.com/item');
    var data1 = await dio.get('https://vahidtest1.herokuapp.com/vitem');
    List<Objekat> users = [];
    for (var u in data.data) {
      bool notSame = true;
      if (u["tag"] == 'music') {
        for (var d in data1.data) {
          if (u['title'] == d['title'] &&
              details.data['username'] == d['username']) {
            notSame = false;
          }
        }
        if (notSame) {
          Objekat user =
              Objekat(u["image"], u["title"], u["description"], u["tag"]);
          users.add(user);
        }
      }
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMovies(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key('item ${snapshot.data[index]}'),
                  background: Container(
                    color: Colors.green,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.favorite_border,
                          size: 50,
                        )),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete_forever,
                          size: 50,
                        )),
                  ),
                  onDismissed: (DismissDirection direction) {
                    if (direction == DismissDirection.startToEnd) {
                      const snackBar = SnackBar(
                        content: Text('Added to liked'),
                      );
                      _addToVoted(
                          snapshot.data[index].title,
                          snapshot.data[index].opis,
                          snapshot.data[index].url,
                          'movie',
                          'liked');
                      //snapshot.data.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      const snackBar = SnackBar(
                        content: Text('Added to disliked'),
                      );
                      _addToVoted(
                          snapshot.data[index].title,
                          snapshot.data[index].opis,
                          snapshot.data[index].url,
                          'movie',
                          'disliked');
                      //snapshot.data.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: ListTile(
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
                  ),
                );
              });
        }
      },
    );
  }
}

class BookList extends StatelessWidget {
  const BookList({Key? key}) : super(key: key);
  Future<List<Objekat>> _getMovies() async {
    var dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    dio.interceptors.add(CookieManager(cookieJar));
    var response = await dio.get('https://vahidtest1.herokuapp.com/user');
    var details = await dio
        .get('https://vahidtest1.herokuapp.com/user/' + response.toString());
    var data = await dio.get('https://vahidtest1.herokuapp.com/item');
    var data1 = await dio.get('https://vahidtest1.herokuapp.com/vitem');
    List<Objekat> users = [];
    for (var u in data.data) {
      bool notSame = true;
      if (u["tag"] == 'book') {
        for (var d in data1.data) {
          if (u['title'] == d['title'] &&
              details.data['username'] == d['username']) {
            notSame = false;
          }
        }
        if (notSame) {
          Objekat user =
              Objekat(u["image"], u["title"], u["description"], u["tag"]);
          users.add(user);
        }
      }
    }
    print(users);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMovies(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key('item ${snapshot.data[index]}'),
                  background: Container(
                    color: Colors.green,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.favorite_border,
                          size: 50,
                        )),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete_forever,
                          size: 50,
                        )),
                  ),
                  onDismissed: (DismissDirection direction) {
                    if (direction == DismissDirection.startToEnd) {
                      const snackBar = SnackBar(
                        content: Text('Added to liked'),
                      );
                      _addToVoted(
                          snapshot.data[index].title,
                          snapshot.data[index].opis,
                          snapshot.data[index].url,
                          'movie',
                          'liked');
                      //snapshot.data.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      const snackBar = SnackBar(
                        content: Text('Added to disliked'),
                      );
                      _addToVoted(
                          snapshot.data[index].title,
                          snapshot.data[index].opis,
                          snapshot.data[index].url,
                          'movie',
                          'disliked');
                      //snapshot.data.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: ListTile(
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
                  ),
                );
              });
        }
      },
    );
  }
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 90.0,
              backgroundImage: NetworkImage(user.url),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(user.opis),
          ],
        )),
      ),
    );
  }
}

class Objekat {
  final String url;
  final String title;
  final String opis;
  final String tag;

  Objekat(this.url, this.title, this.opis, this.tag);
}

_addToVoted(
    String title, String desc, String image, String tag, String liked) async {
  var dio = Dio();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  var cookieJar = PersistCookieJar(
      ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
  dio.interceptors.add(CookieManager(cookieJar));
  var response = await dio.get('https://vahidtest1.herokuapp.com/user');
  var details = await dio
      .get('https://vahidtest1.herokuapp.com/user/' + response.toString());
  await dio.post('https://vahidtest1.herokuapp.com/vitem', data: {
    'image': image,
    'username': details.data['username'],
    'title': title,
    'tag': tag,
    'liked': liked,
    'description': desc
  });
}
