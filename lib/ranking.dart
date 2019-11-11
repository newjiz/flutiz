import 'package:flutter/material.dart';

import 'package:thor/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class RankingUser {
  final int position;
  final String id;
  final String userId;
  final String content;
  final DateTime created;
  final double elo;

  RankingUser({
      this.position, 
      this.id,
      this.userId, 
      this.content, 
      this.created, 
      this.elo
    }
  );

  factory RankingUser.fromJson(Map<String, dynamic> json) {
    return RankingUser(
      position: json['position'],
      id: json['_id']['\$oid'],
      userId: json['user_id']['\$oid'],
      content: json['content']['data'],
      created: DateTime.fromMicrosecondsSinceEpoch(json['created']['\$date'] * 1000),
      elo: double.parse(json['votes']['elo'].toString())
    );
  }
}

class RankingItem extends StatelessWidget {
  final RankingUser item;
 
  RankingItem({Key key, this.item}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${item.elo}"),
      subtitle: Text("${item.content}"),
      leading: Text(
        item.position.toString()
      ),
    );
  }
}

class Ranking extends StatefulWidget {
  @override
  RankingState createState() {
    return RankingState();
  }
}

class RankingState extends State<Ranking> {
  Future<List<RankingUser>> ranking;

  @override
  void initState() {
    super.initState();
    ranking = fetchRanking();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RankingUser>>(
      future: ranking,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext ctxt, int index) {
              return RankingItem(item: snapshot.data[index]);
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

Future<List<RankingUser>> fetchRanking() async {
  final response =
      await http.get(URL + "/ranking");

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    return (responseJson['data'] as List)
        .map((p) => RankingUser.fromJson(p))
        .toList();
  }
  
  throw Exception('Failed to load post');
}