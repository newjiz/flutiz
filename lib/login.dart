import 'package:flutter/material.dart';
import 'package:thor/main.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _username,
            decoration: InputDecoration(
              hintText: "Username"
            ),
            validator: (value) {
              if (value.isEmpty) return "Username should not empty";
              return null;
            },
            onSaved: (value) => _username.text = value,
          ),
          TextFormField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password"
            ),
            validator: (value) {
              if (value.isEmpty) return "Password should not empty";
              return null;
            },
            onSaved: (value) => _password.text = value,
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Map user = {
                    "username": _username.text,
                    "password": _password.text
                  };
                  
                  fetchLogin(context, user);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

void fetchLogin(BuildContext ctx, Map user) async {
  final response = await http.post(
      URL + "/login",
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user)
    );

  print(response.statusCode);

  if (response.statusCode == 200) {
    Token token = Token.fromJson(json.decode(response.body));
    await storage.write(key: "token", value: token.token);    
    Navigator.popAndPushNamed(ctx, '/user');
  } else {
    Navigator.popAndPushNamed(ctx, '/login');
  }
}