import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  String _movieTitle = "Movie Title";
  String _releaseDate = 'August 18 2021';
  String _moviePoster =
      "https://c.tenor.com/I6kN-6X7nhAAAAAi/loading-buffering.gif";

  //simple funciton to test making a request to the movie db api.
  Future _getLatestMovie() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/550?api_key=6467cd9826ddf9112a2360aff2b1b3a2");
    var response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var movieInfo = json.decode(response.body);
      print(movieInfo);
      setState(() {
        _movieTitle = movieInfo["original_title"];
        _releaseDate = movieInfo["release_date"];
        _moviePoster =
            "https://image.tmdb.org/t/p/original/" + movieInfo["poster_path"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called. ex: by the _incrementCounter method above.

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.indigo.shade800,
      ),
      body: Center(
        child: Column(
          //this is the column where movies are displayed
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              _moviePoster ?? null,
              height: 350,
            ),
            Text(
              _movieTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _releaseDate,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLatestMovie,
        tooltip: 'getLatestMovie',
        child: Icon(Icons.local_movies),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
