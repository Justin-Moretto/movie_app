import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './widgets/movie_card.dart';
import './helpers/helpers.dart';

Future main() async {
  //retrieve the api key from .env
  await dotenv.load(fileName: "assets/.env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieList',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home:
          MyHomePage(title: 'Latest Releases:', apiKey: dotenv.env['API_KEY']),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, @required this.apiKey}) : super(key: key);

  final String title;
  final String apiKey;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _latestReleases;

  var _query = "upcoming";

  Widget _createMovieCards(releases) {
    return Column(
      children: releases
          .map<StatefulWidget>(
            (movie) => MovieCard(
              movie: movie,
            ),
          )
          .toList(),
    );
  }

  Future _getLatestMovies() async {
    final apiKey = widget.apiKey;
    final apiEndpoint =
        "https://api.themoviedb.org/3/movie/$_query?api_key=$apiKey&language=en-US&page=1";
    var apiUrl = Uri.parse(apiEndpoint);
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      setState(() {
        _latestReleases = json.decode(response.body)["results"];
        //print(_latestReleases);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print("API KEY: ${widget.apiKey}");
    _latestReleases ?? _getLatestMovies();
    return Scaffold(
      appBar: AppBar(
        title: Text(displayTitle(widget.apiKey, _query)),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_movies),
            tooltip: 'Upcoming',
            onPressed: () {
              setState(() {
                if (_query == "upcoming") {
                  _query = "now_playing";
                } else if (_query == "now_playing") {
                  _query = "top_rated";
                } else if (_query == "top_rated") {
                  _query = "upcoming";
                }
                _getLatestMovies();
              });
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
