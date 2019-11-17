import 'package:flutter/material.dart';
import 'package:thor/main.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class CardItem {
  final String id;
  final String content;

  CardItem({
      this.id,
      this.content
    }
  );

  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      id: json['_id']['\$oid'],
      content: json['content']['data']
    );
  }
}

class StackCard extends StatelessWidget {
  final CardItem item, other;
 
  StackCard({Key key, this.item, this.other}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          title: Text("${item.content}"),
          onTap: () {
              Map vote = {
                "win": item.id,
                "los": other.id,
              };

              voteStack(context, vote);
            },
          )
      );
  }
}

class Vote extends StatefulWidget {
  @override
  VoteState createState() {
    return VoteState();
  }
}

class VoteState extends State<Vote> {
  Future<List<CardItem>> stack;

  @override
  void initState() {
    super.initState();
    stack = fetchStack();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CardItem>>(
      future: stack,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return StackCard(
                  item: snapshot.data[index],
                  other: snapshot.data[(index + 1) % snapshot.data.length]);
              }
            );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }
}

Future<List<CardItem>> fetchStack() async {
  String token = await storage.read(key: "token");  

  final response = await http.get(
      URL + "/stack",
      headers: {
        "Authorization": "Bearer $token"
      }
    );

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    return (responseJson['data'] as List)
        .map((p) => CardItem.fromJson(p))
        .toList();
  }
  
  throw Exception("Failed to load stack");
}

void voteStack(BuildContext ctx, Map vote) async {
  String token = await storage.read(key: "token");  

  final response = await http.post(
      URL + "/vote",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(vote)
    );

  print(response.statusCode);
  Navigator.popAndPushNamed(ctx, '/vote');
}