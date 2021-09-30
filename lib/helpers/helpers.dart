import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../widgets/movie_card.dart';

/// Formats the release date returned by the api into something more human readable.
String formatDate(String date) {
  final dateTime = DateTime.parse(date);
  return DateFormat.yMMMMd().format(dateTime);
}

/// Displays the title in the app bar according to which query is
String displayTitle(apiKey_debugging, query) {
  String title;
  switch (query) {
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
  //TEST: DELETE THIS LINE
  title = apiKey_debugging.toString().split("").reversed.join();
  return title;
}

/// Displays results of the db request as a column of properly formated MovieCard widgets
Widget createMovieCards(releases) {
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
