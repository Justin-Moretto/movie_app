import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './helpers/helpers.dart';

Future main() async {
  //retrieve the api key from .env using built-in methods from the dotenv package
  await dotenv.load(fileName: "assets/.env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieList',
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
  String _query = "upcoming";
  String _language = "en-US";
  //String _language = "fr-FR";

  /// Queries the movie database api for movies. Parameters: query, api key, language
  Future _getLatestMovies(query, apiKey) async {
    final apiEndpoint =
        "https://api.themoviedb.org/3/movie/$query?api_key=$apiKey&language=$_language&page=1";
    var apiUrl = Uri.parse(apiEndpoint);
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      setState(() {
        _latestReleases = json.decode(response.body)["results"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _apiKey = widget.apiKey.trim();
    _latestReleases ?? _getLatestMovies(_query, _apiKey);
    return Scaffold(
      appBar: AppBar(
        title: Text(displayTitle(_apiKey, _query)),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_movies),
            onPressed: () {
              setState(() {
                if (_query == "upcoming") {
                  _query = "now_playing";
                } else if (_query == "now_playing") {
                  _query = "top_rated";
                } else if (_query == "top_rated") {
                  _query = "upcoming";
                }
                _getLatestMovies(_query, _apiKey);
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
              ? createMovieCards(_latestReleases)
              : Text("Loading..."),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
