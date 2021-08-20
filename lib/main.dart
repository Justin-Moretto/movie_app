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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _latestReleases;
  var apiUrl = Uri.parse(
      "https://api.themoviedb.org/3/movie/upcoming?api_key=6467cd9826ddf9112a2360aff2b1b3a2&language=en-US&page=1");

  Widget _createMovieCards(release) {
    List<Widget> list = <Widget>[];
    for (int i = 0; i < release.length; i++) {
      list.add(
        new MovieCard(
          poster: release[i]["poster_path"],
          releaseDate: release[i]["release_date"],
          title: release[i]["original_title"],
        ),
      );
    }
    return Column(
      children: list,
    );
  }

  //simple funciton to test making a request to the movie db api.
  Future _getLatestMovies() async {
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      setState(() {
        _latestReleases = json.decode(response.body)["results"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called. ex: by the _incrementCounter method above.
    _latestReleases ?? _getLatestMovies();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.indigo.shade800,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: _latestReleases.length > 1
              ? _createMovieCards(_latestReleases)
              : SizedBox(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLatestMovies,
        tooltip: 'getLatestMovie',
        child: Icon(Icons.local_movies),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
