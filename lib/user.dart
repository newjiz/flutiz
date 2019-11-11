import 'package:flutter/material.dart';

import 'package:thor/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class User {
  String id;
  String username;
  String description;

  List<Content> content; 

  User({
    this.id,
    this.username,
    this.description,
    this.content
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var content = (json['data']['content'] as List)
        .map((c) => Content.fromJson(c))
        .toList();

    return User(
      id: json['data']['user']['_id']['\$oid'],
      username: json['data']['user']['username'],
      description: json['data']['user']['description'],
      content: content
    );
  }
}

class Content {
  final String id;
  final String userId;
  final String contestId;
  final String content;
  final DateTime created;

  Content({
      this.id,
      this.userId, 
      this.contestId, 
      this.content, 
      this.created, 
    }
  );

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['_id']['\$oid'],
      userId: json['user_id']['\$oid'],
      contestId: json['contest_id']['\$oid'],
      content: json['content']['data'],
      created: DateTime.fromMicrosecondsSinceEpoch(json['created']['\$date'] * 1000)
    );
  }
}

class UserView extends StatelessWidget {
  final User user;
 
  UserView({Key key, this.user}) : super(key: key);
  
  /*
  ListTile(
          title: Text("${user.username}"),
          subtitle: Text("${user.description}"),
          leading: Text(user.id),
          onTap: () => Navigator.pop(context),
        ),
  */

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("Hi, ${user.username}!"),
          subtitle: Text("${user.description}")
        ),
        Divider(height: 20.0),
        Flexible(
          child: ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: user.content.length,
            itemBuilder: (BuildContext ctx, int index) {
              return ListTile(
                title: Text(
                  "\"${user.content[index].content}\""
                  ),
                subtitle: Text(
                  "Contest(${user.content[index].contestId})"
                  )
              );
            }
          )
        )
      ]
    );
  }
}

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool gotData = false;
  Future<User> user;

  void initState() {
      super.initState();
      if(!gotData){
        readItem("token").then(
            (String token) => setState(() {
              user = fetchUser(token);
              gotData = true;
            })
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return UserView(user: snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        }
      )
    );
  }
}

Future<String> readItem(String key) async {
  final value = await storage.read(key: key);
  return value;
}

Future<User> fetchUser(String token) async {
  final response = await http.get(
      URL + "/",
      headers: {"Authorization": "Bearer $token"}
    );

  if (response.statusCode == 200)
    return User.fromJson(
        json.decode(response.body)
      );
  else
    throw Exception("Could not get user's data");
}