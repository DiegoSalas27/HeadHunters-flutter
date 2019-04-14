import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Most listened',
      theme:ThemeData(
        primaryColor: Color(0xFF6200EE),
        secondaryHeaderColor: Color(0xFF3700B3),
      ),
      home:  CardList(),
    );
  }
}

class CardList extends StatefulWidget {
  @override
  CardListState createState() => new CardListState();
}

class CardListState extends State<CardList> {

  List albumData;

  Future<String> getData() async {
    http.Response response = await http.get(
      Uri.encodeFull("https://albumapp-api.herokuapp.com/albums")
    );
    setState(() {
      albumData = jsonDecode(response.body);
    });

    debugPrint(albumData[0]['title']);

    return 'Success';
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3700B3),
      appBar: AppBar(
        title: Text('Most listened'),
      ),
      body:_renderCards(),
    );
  }

  Widget _renderCards() {
    return ListView.builder(
      itemCount: albumData == null ? 0 : albumData.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _renderCard(albumData[i]),
        );
      }
    );
  }

  Widget _renderCard(album) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child:
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.network(album['thumbnail_image'], width: 50, height: 50),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(album['title'], style: TextStyle(fontSize: 18.0)),
                  Text(album['artist'], style: TextStyle(fontSize: 14.0)),
                ]
              )
            ]
          ),
          Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.network(album['image'], fit: BoxFit.cover),
          )
        ],
      )
    );
  }
}