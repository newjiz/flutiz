import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:thor/login.dart';
import 'package:thor/register.dart';
import 'package:thor/contest.dart';
import 'package:thor/ranking.dart';
import 'package:thor/user.dart';
import 'package:thor/content.dart';
import 'package:thor/vote.dart';


const URL = "http://10.0.2.2:5000";
bool logged = false;

FlutterSecureStorage storage = new FlutterSecureStorage();

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "jiz",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.yellow,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/ranking': (context) => RankingPage(),
        '/user': (context) => UserPage(),
        '/contest': (context) => ContestPage(),
        '/content': (context) => ContentPage(),
        '/vote': (context) => VotePage(),
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
    if (logged) {
      return Scaffold(
        appBar: null,
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
                    "logged in mama",
                    style: TextStyle(
                      fontSize: 32
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RaisedButton(
                        child: Text('Profile'),
                        onPressed: () => Navigator.pushNamed(context, '/user'),
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        child: Text('Ranking'),
                        onPressed: () => Navigator.pushNamed(context, '/ranking'),
                      ),
                    )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RaisedButton(
                        child: Text('Contest'),
                        onPressed: () => Navigator.pushNamed(context, '/contest'),
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        child: Text('Vote'),
                        onPressed: () => Navigator.pushNamed(context, '/vote'),
                      ),
                    )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RaisedButton(
                        child: Text('Logout'),
                        onPressed: () async {
                            logged = false;
                            await storage.delete(key: "token");
                            Navigator.popAndPushNamed(context, "/");
                          },
                      ),
                    )
                ]),
            ])
          )
        )
      );
    } else {
        return Scaffold(
        appBar: null,
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
                    "jiz, can u log in?",
                    style: TextStyle(
                      fontSize: 32
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RaisedButton(
                        child: Text('Login'),
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        child: Text('Register'),
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                      ),
                    )
                  ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RaisedButton(
                        child: Text('Ranking'),
                        onPressed: () => Navigator.pushNamed(context, '/ranking'),
                      ),
                    )
                ])
            ])
          )
        )
      );
    }
  }
}

class VotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vote"),
      ),
      body: Container(
        padding: new EdgeInsets.symmetric(
          vertical: 40.0,
          horizontal: 40.0  
        ),
        child: Center(
          child: Vote(),
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
      body: Ranking()
    );
  }
}

class ContestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Current contest"),
      ),
      body: Contest()
    );
  }
}

class Token {
  final String token;

  Token({this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token']
    );
  }
}