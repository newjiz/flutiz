import 'package:flutter/material.dart';
import 'package:thor/main.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterUser {
  final String username;
  final String email;
  final String description;
  final String password;

  RegisterUser({this.username, this.email, this.description, this.password});
}

class RegisterForm extends StatefulWidget {
  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _description = TextEditingController();
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
            controller: _email,
            decoration: InputDecoration(
              hintText: "Email adress"
            ),
            validator: (value) {
              if (value.isEmpty) return "Email should not empty";
              if (!value.contains("@")) return "Not valid email.";
              return null;
            },
            onSaved: (value) => _username.text = value,
          ),
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
            controller: _description,
            decoration: InputDecoration(
              hintText: "Description (Optional)"
            ),
            validator: (value) => null,
            onSaved: (value) => _description.text = value,
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
                    "email": _email.text,
                    "description": _description.text,
                    "password": _password.text
                  };
                  
                  fetchRegister(context, user);
                }
              },
              child: Text('Register'),
            ),
          ),
        ],
      ),
    );
  }
}

void fetchRegister(BuildContext ctx, Map user) async {
  final response = await http.post(
      URL + "/register",
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user)
    );

  print(response.statusCode);

  if (response.statusCode == 200) {
    Token token = Token.fromJson(json.decode(response.body));
    await storage.write(key: "token", value: token.token);    
    logged = true;
    Navigator.popAndPushNamed(ctx, '/user');
  } else {
    Navigator.popAndPushNamed(ctx, '/register');
  }
}