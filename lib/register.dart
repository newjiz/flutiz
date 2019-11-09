import 'package:flutter/material.dart';
import 'package:thor/main.dart';

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
                  addItem("username", _username.text);
                  Navigator.pushNamed(context, '/user');
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

void addItem(String key, String value) async {
  await storage.write(key: key, value: value);
}