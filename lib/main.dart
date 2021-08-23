import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './widgets/movie_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Latest Releases:'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _latestReleases;
  final apiEndpoints = {
    "upcoming":
        "https://api.themoviedb.org/3/movie/upcoming?api_key=6467cd9826ddf9112a2360aff2b1b3a2&language=en-US&page=1",
    "latest":
        "https://api.themoviedb.org/3/movie/latest?api_key=6467cd9826ddf9112a2360aff2b1b3a2&language=en-US",
    "now_playing":
        "https://api.themoviedb.org/3/movie/now_playing?api_key=6467cd9826ddf9112a2360aff2b1b3a2&language=en-US&page=1",
  };

  var _query = "upcoming";

  var apiUrl = Uri.parse(
      "https://api.themoviedb.org/3/movie/upcoming?api_key=6467cd9826ddf9112a2360aff2b1b3a2&language=en-US&page=1");

  Widget _createMovieCards(releases) {
    return Column(
      children: releases
          .map<Widget>(
            (movie) => MovieCard(
              poster: movie["poster_path"],
              releaseDate: movie["release_date"],
              title: movie["original_title"],
            ),
          )
          .toList(),
    );
  }

  Future _getLatestMovies() async {
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      setState(() {
        _latestReleases = json.decode(response.body)["results"];
        print(_latestReleases);
      });
    }
  }

  String _displayTitle() {
    String title;
    switch (_query) {
      case "upcoming":
        title = "Upcoming Releases:";
        break;
      case "latest":
        title = "Latest Releases:";
        break;
      case "now_playing":
        title = "Now playing:";
        break;
      default:
        title = "Upcoming Releases:";
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    _latestReleases ?? _getLatestMovies();
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.local_movies),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_movies),
            tooltip: 'Upcoming',
            onPressed: () {
              print('switch display');
            },
          ),
        ],
        backgroundColor: Colors.indigo.shade500,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: _latestReleases != null
              ? _createMovieCards(_latestReleases)
              : SizedBox(),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
