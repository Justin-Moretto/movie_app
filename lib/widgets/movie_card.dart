import 'package:flutter/cupertino.dart';

class MovieCard extends StatelessWidget {
  MovieCard({
    Key key,
    @required this.poster,
    @required this.title,
    @required this.releaseDate,
  });

  final String poster;
  final String title;
  final String releaseDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Image.network(
            poster,
            height: 350,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            releaseDate,
          ),
        ],
      ),
    );
  }
}
