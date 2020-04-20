import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      Container(width: MediaQuery.of(context).size.width-48,child: Center(child: CircularProgressIndicator(),)),
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
    return Container(
      width: MediaQuery.of(context).size.width - 48,
      child: Center(child: Image.asset(catPath)),
    );
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
  String cat = "cica.jpg";
  Future<void> next(String path) async {
    await Future.delayed(Duration(seconds: 1));
    cat = path;
  }
}
