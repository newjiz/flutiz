import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:thor/login.dart';
import 'package:thor/register.dart';


FlutterSecureStorage storage = new FlutterSecureStorage();

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "jiz",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/ranking': (context) => RankingPage(),
        '/user': (context) => UserPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0
          ),
        child: Container(
          padding: new EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 40.0
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "jizzz",
                  style: TextStyle(
                    fontSize: 48
                  )
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: RaisedButton(
                      child: Text('Login'),
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                    ),
                  ),
                  Center(
                    child: RaisedButton(
                      child: Text('Register'),
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                    ),
                  ),
              ]),
              Center(
                child: RaisedButton(
                  child: Text('Ranking'),
                  onPressed: () => Navigator.pushNamed(context, '/ranking'),
                ),
              ),
          ])
        )
      )
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: new EdgeInsets.symmetric(
          vertical: 40.0,
          horizontal: 40.0  
        ),
        child: Center(
          child: LoginForm(),
        )
      )
    );
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Container(
        padding: new EdgeInsets.symmetric(
          vertical: 40.0,
          horizontal: 40.0  
        ),
        child: Center(
          child: RegisterForm(),
        )
      )
    );
  }
}

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ranking"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Home'),
        ),
      ),
    );
  }
}


class UserPage extends StatefulWidget {
  UserPage({Key key, this.username}) : super(key: key);
  final String username;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _username;

  void initState() {
      super.initState();
      if(_username == null){
        readItem("username").then(
            (String s) => setState(() {_username = s;})
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Hi, $_username!"),
          Center(
            child: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Home'),
            ),
          ),
        ])
    );
  }
}

Future<String> readItem(String key) async {
  final value = await storage.read(key: key);
  return value;
}