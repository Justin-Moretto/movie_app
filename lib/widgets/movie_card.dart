import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  MovieCard({
    Key key,
    @required this.poster,
    @required this.title,
    @required this.releaseDate,
  });

  String poster;
  final String title;
  final String releaseDate;

  @override
  Widget build(BuildContext context) {
    poster = "https://image.tmdb.org/t/p/original/" + poster;
    return Column(
      children: [
        Container(
          width: 285,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: Colors.blueGrey.shade100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                poster,
                height: 400,
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
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
