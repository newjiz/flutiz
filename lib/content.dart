import 'package:flutter/material.dart';
import 'package:thor/main.dart';
import 'package:thor/contest.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


class ContentForm extends StatefulWidget {
  @override
  ContentFormState createState() {
    return ContentFormState();
  }
}

class ContentFormState extends State<ContentForm> {
  final _formKey = GlobalKey<FormState>();
  Future<ContestData> contest;

  @override
  void initState() {
    super.initState();
    contest = fetchContest();
  }


  TextEditingController _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return  FutureBuilder<ContestData>(
      future: contest,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text("${snapshot.data.title}"),
                  subtitle: Text("${snapshot.data.description}")
                ),
                TextFormField(
                  controller: _content,
                  decoration: InputDecoration(
                    hintText: "Content"
                  ),
                  validator: (value) {
                    if (value.isEmpty) return "Content should not empty...";
                    if (value.length > 140) return "Content too long!";
                    return null;
                  },
                  onSaved: (value) => _content.text = value,
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        postContent(context, _content.text, snapshot.data.id);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }
}

class ContentPage extends StatefulWidget {
  ContentPage({Key key}) : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  Future<ContestData> contest;

  void initState() {
    super.initState();
    contest = fetchContest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Content"),
      ),
      body: FutureBuilder<ContestData>(
        future: contest,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("The contest id is ${snapshot.data.id}");
            return Container(
                padding: new EdgeInsets.symmetric(
                  vertical: 40.0,
                  horizontal: 40.0,
                ),
                child: ContentForm(),
              );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        }
      )
    );
  }
}

void postContent(BuildContext ctx, String content, String contestId) async {
  Map data = {
    "content": content,
    "contest_id": contestId
  };

  String token = await storage.read(key: "token");    

  final response = await http.post(
      URL + "/content",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(data)
    );

  print(response.statusCode);

  if (response.statusCode == 200) { 
    Navigator.popAndPushNamed(ctx, '/user');
  } else {
    Navigator.popAndPushNamed(ctx, '/content');
  }
}