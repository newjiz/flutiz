import 'package:flutter/material.dart';

import 'package:thor/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class ContestData {
  final String id;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final double progress;

  ContestData({
    this.id,
    this.title,
    this.description,
    this.start,
    this.end,
    this.progress
    }
  );

  factory ContestData.fromJson(Map<String, dynamic> json) {
    return ContestData(
      id: json['data']['_id']['\$oid'],
      title: json['data']['title'],
      description: json['data']['description'],
      start: DateTime.fromMicrosecondsSinceEpoch(json['data']['start']['\$date'] * 1000),
      end: DateTime.fromMicrosecondsSinceEpoch(json['data']['end']['\$date'] * 1000),
      progress: double.parse(json['data']['progress'].toString())
    );
  }
}

class ContestView extends StatelessWidget {
  final ContestData contest;
 
  ContestView({Key key, this.contest}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${contest.title}"),
      subtitle: Text("${contest.description}"),
      leading: Text(
        "${(contest.progress * 100).toString().substring(0, 2)}%"
      ),
      onTap: () => Navigator.popAndPushNamed(context, '/content'),
    );
  }
}

class Contest extends StatefulWidget {
  @override
  ContestState createState() {
    return ContestState();
  }
}

class ContestState extends State<Contest> {
  Future<ContestData> contest;

  @override
  void initState() {
    super.initState();
    contest = fetchContest();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<ContestData>(
        future: contest,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ContestView(contest: snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}

Future<ContestData> fetchContest() async {
  final response =
      await http.get(URL + "/contest");

  if (response.statusCode == 200)
    return ContestData.fromJson(
        json.decode(response.body)
      );
  
  throw Exception('Failed to load post');
}