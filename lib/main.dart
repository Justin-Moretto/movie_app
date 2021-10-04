import 'package:flutter/material.dart';
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
  //String _language = "en-US";
  //String _language = "fr-FR";

  @override
  Widget build(BuildContext context) {
    final _apiKey = widget.apiKey.trim();
    _latestReleases ??
        getLatestMovies(query: _query, apiKey: _apiKey)
            .then((response) => setState(() {
                  _latestReleases = response;
                }));
    return Scaffold(
      appBar: AppBar(
        title: Text(displayTitle(_query)),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_movies),
            onPressed: () {
              setState(() {
                _query = changeQuery(_query);
                getLatestMovies(query: changeQuery(_query), apiKey: _apiKey)
                    .then((response) => _latestReleases = response);
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
      ),
    );
  }
}
