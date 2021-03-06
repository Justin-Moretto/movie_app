import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

///A container which displays the movie's title, poster and release date. If the poster is clicked by the user, it displays a brief description of the movie, rather than the poster.
class MovieCard extends StatefulWidget {
  MovieCard({
    Key key,
    this.toggle = true,
    @required this.movie,
  });

  final movie;
  var toggle;

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  ///displays either the film's poster or it's description
  /// TODO: move this to helpers? Maybe after I learn to save the poster images so that the aren't requested every time
  Widget _displayImage(poster, description, toggle) {
    if (toggle) {
      return Container(
        height: 400,
        child: CachedNetworkImage(
          imageUrl: poster,
          alignment: Alignment.center,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Container(
        height: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: Colors.blueGrey.shade100),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 220),
            child: Text(
              description,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String poster =
        "https://image.tmdb.org/t/p/original/" + widget.movie["poster_path"];
    final String releaseDate = widget.movie["release_date"];
    final String title = widget.movie["original_title"];
    final String description = widget.movie["overview"];

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              widget.toggle = !widget.toggle;
            });
          },
          child: Container(
            width: 285,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: Colors.blueGrey.shade200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _displayImage(poster, description, widget.toggle),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatDate(releaseDate),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
