import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firebase.dart';

void main() {
  /*initializeApp(
    apiKey: "AIzaSyDGP4Ly3zgMxhNk3RxSxYKFvz0iAk32WZM",
    authDomain: "stocknotifier-d762f.firebaseapp.com",
    databaseURL: "https://stocknotifier-d762f.firebaseio.com",
    projectId: "stocknotifier-d762f",
    storageBucket: "stocknotifier-d762f.appspot.com");
  */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.signInAnonymously();
    return MaterialApp(
      title: 'Cuccli',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Cicamica weblap'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Injector(
        inject: [
          Inject<AuthService>(() => AuthService()),
        ],
        builder: (ctx) {
          final cat = Injector.getAsReactive<AuthService>(context: ctx);

          return cat.whenConnectionState(
              onIdle: () => Row(
                    children: <Widget>[
                      _sidePageChooser(context),
                      _sideBody(context, "cica.jpg"),
                    ],
                  ),
              onWaiting: () => Row(
                    children: <Widget>[
                      _sidePageChooser(context),
                      Container(
                          width: MediaQuery.of(context).size.width - 48,
                          child: Center(
                            child: CircularProgressIndicator(),
                          )),
                    ],
                  ),
              onData: (data) => Row(
                    children: <Widget>[
                      _sidePageChooser(context),
                      _sideBody(context, data.cat),
                    ],
                  ),
              onError: (err) => Container(color: Colors.red));
        },
      ),
    );
  }

  Widget _sideBody(BuildContext context, String catPath) {
    final ref = fb
        .storage()
        .refFromURL("gs://stocknotifier-d762f.appspot.com/")
        .child(catPath);

    return FutureBuilder(
        future: ref.getDownloadURL(),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return Container();
          }

          return Container(
            width: MediaQuery.of(context).size.width - 48,
            child: Center(child: Image.network(snap.data.toString())),
          );
        });
  }

  Widget _sidePageChooser(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: () {
              Injector.getAsReactive<AuthService>().setState((authS) async {
                await authS.next("cica.jpg");
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.backspace),
            onPressed: () {
              Injector.getAsReactive<AuthService>().setState((authS) async {
                await authS.next("cica1.jpg");
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.cached),
            onPressed: () {
              Injector.getAsReactive<AuthService>().setState((authS) async {
                await authS.next("cica2.jpg");
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {
              Injector.getAsReactive<AuthService>().setState((authS) async {
                await authS.next("cica3.jpg");
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.face),
            onPressed: () {
              Injector.getAsReactive<AuthService>().setState((authS) async {
                await authS.next("cica4.jpg");
              });
            },
          ),
        ],
      ),
    );
  }
}

class AuthService {
  String cat = "cica";
  Future<void> next(String path) async {
    await Future.delayed(Duration(seconds: 1));
    cat = path;
  }
}
