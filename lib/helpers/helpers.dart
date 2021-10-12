import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../widgets/movie_card.dart';

/// Formats the release date returned by the api into something more human readable.
String formatDate(String date) {
  final dateTime = DateTime.parse(date);
  return DateFormat.yMMMMd().format(dateTime);
}

/// Displays the title in the app bar according to which query is
String displayTitle(query) {
  String title;
  switch (query) {
    case "upcoming":
      title = "Upcoming Releases:";
      break;
    case "now_playing":
      title = "Now playing:";
      break;
    case "top_rated":
      title = "Top Rated:";
      break;
    default:
      title = "Upcoming Releases:";
  }
  return title;
}

String changeQuery(query) {
  String newQuery;
  switch (query) {
    case "upcoming":
      newQuery = "now_playing";
      break;
    case "now_playing":
      newQuery = "top_rated";
      break;
    case "top_rated":
      newQuery = "upcoming";
      break;
    default:
      newQuery = "upcoming";
  }
  return newQuery;
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

/// Queries the movie database api for movies. Parameters: query, api key, language
Future getLatestMovies(
    {@required String query,
    @required String apiKey,
    String language = "en-US"}) async {
  final apiEndpoint =
      "https://api.themoviedb.org/3/movie/$query?api_key=$apiKey&language=$language&page=1";
  var apiUrl = Uri.parse(apiEndpoint);
  var response = await http.get(apiUrl);

  if (response.statusCode == 200) {
    return json.decode(response.body)["results"];
  } else {
    return null;
  }
}
