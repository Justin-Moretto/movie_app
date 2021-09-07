import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './widgets/movie_card.dart';

Future main() async {
  await dotenv.load(fileName: "assets/.env");

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
    final apiEndpoints = {
      "upcoming":
          "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=en-US&page=1",
      "top_rated":
          "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=en-US&page=1",
      "now_playing":
          "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&language=en-US&page=1",
    };
    var apiUrl = Uri.parse(apiEndpoints[_query]);
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      setState(() {
        _latestReleases = json.decode(response.body)["results"];
        //print(_latestReleases);
      });
    }
  }

  String _displayTitle() {
    String title;
    switch (_query) {
      case "upcoming":
        title = "Upcoming Releases:";
        break;
      case "top_rated":
        title = "Top Rated:";
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
    //print("API KEY: ${widget.apiKey}");
    _latestReleases ?? _getLatestMovies();
    return Scaffold(
      appBar: AppBar(
        title: Text(_displayTitle()),
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
