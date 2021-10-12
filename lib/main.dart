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

//TODO: Save the responses from the api requests as state, so that there is no loading when the user switches views
class _MyHomePageState extends State<MyHomePage> {
  String _query = "upcoming";
  //String _language = "en-US";
  //String _language = "fr-FR";
  //TODO
  final Map _cachedResponse = {
    "upcoming": null,
    "now_playing": null,
    "top_rated": null,
  };

  @override
  Widget build(BuildContext context) {
    final _apiKey = widget.apiKey.trim();
    if (_cachedResponse[_query] == null) {
      getLatestMovies(query: _query, apiKey: _apiKey)
          .then((response) => setState(() {
                _cachedResponse[_query] = response;
              }));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(displayTitle(_query)),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_movies),
            onPressed: () {
              setState(() {
                _query = changeQuery(_query);
                if (_cachedResponse[changeQuery(_query)] == null) {
                  getLatestMovies(query: changeQuery(_query), apiKey: _apiKey)
                      .then((response) =>
                          _cachedResponse[changeQuery(_query)] = response);
                }
              });
            },
          ),
        ],
        backgroundColor: Colors.indigo.shade500,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: _cachedResponse[_query] != null
              ? createMovieCards(_cachedResponse[_query])
              : Text("Loading..."),
        ),
      ),
    );
  }
}
